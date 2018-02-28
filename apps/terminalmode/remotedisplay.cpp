/*
 * RemoteDisplay QML plugin
 * Copyright (C) 2011 Nokia Corporation
 *
 * This file is part of the RemoteDisplay QML plugin.
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at
 * your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library;  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QPainter>
#include "QTmUpnpControlPoint.h"
#include "QTmNetworkObserver.h"
#include "QTmRfbClient.h"
#include "remotedisplay.h"

RemoteDisplay::RemoteDisplay(QDeclarativeItem *parent)
    : QDeclarativeItem(parent), m_surface(0)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    setFlag(QGraphicsItem::ItemIsFocusable, true);
    setAcceptedMouseButtons(Qt::LeftButton);

    m_networkObserver = new QTmNetworkObserver(this, true, false);  // no IPv6
    connect(m_networkObserver, SIGNAL(addedAddress(QString, QNetworkAddressEntry)),
            this,              SLOT  (deviceDetected(QString, QNetworkAddressEntry)),
            Qt::DirectConnection);
    //connect(m_networkObserver, SIGNAL(removedAddress(QNetworkAddressEntry)),
    //        this,              SLOT  (deviceLost(QNetworkAddressEntry)),
    //        Qt::DirectConnection);
    m_networkObserver->checkNetworks();

    connect(this, SIGNAL(redraw()), this, SLOT(redrawSurface())); //, Qt::QueuedConnection);
}

void RemoteDisplay::deviceDetected(QString networkInterfaceName, QNetworkAddressEntry networkEntry)
{
    if(!m_upnpControlPoint) {
        m_upnpControlPoint = new QTmUpnpControlPoint();
        connect(m_upnpControlPoint, SIGNAL(remoteServerDeviceAdded(QTmRemoteServer *)),
                this,               SLOT  (remoteServerDeviceAdded(QTmRemoteServer *)),
                Qt::DirectConnection);
    }

    if (!m_upnpControlPoint->connectUpnp(networkInterfaceName, networkEntry.ip()))
        qWarning() << "UPnP connect error";

    if (!m_upnpControlPoint->sendMSearchQuery(networkEntry.ip()))
        qWarning() << "Could not send M-SEARCH";
}

void RemoteDisplay::remoteServerDeviceAdded(QTmRemoteServer *remoteServer)
{
    remoteServer->getApplicationList();

    QList<QTmApplication *> applist = remoteServer->applicationList();

    foreach(QTmApplication *app, applist) {
        if(app->name() == QLatin1String("VNC Server")) {
            connect(remoteServer, SIGNAL(applicationLaunched(QTmApplication*)),
                    this,         SLOT  (appStarted(QTmApplication*)));
            remoteServer->launchApplication(app);
        }
    }
}

void RemoteDisplay::appStarted(QTmApplication *app)
{
    rfbClient = new QTmRfbClient();

    /*
    rfbClient->setClientConfig(QTmConfiguration::ConfigKeyboardLanguage,    ('e' << 8) | 'n');
    rfbClient->setClientConfig(QTmConfiguration::ConfigKeyboardCountry,     ('u' << 8) | 's');
    rfbClient->setClientConfig(QTmConfiguration::ConfigUiLanguage,          ('e' << 8) | 'n');
    rfbClient->setClientConfig(QTmConfiguration::ConfigUiCountry,           ('u' << 8) | 's');
    //Key Event Configuration
    rfbClient->setClientConfig(QTmConfiguration::ConfigEventKnobKey,         0x00000000);
    rfbClient->setClientConfig(QTmConfiguration::ConfigEventDeviceKey,       0x00000023);
    rfbClient->setClientConfig(QTmConfiguration::ConfigEventMediaKey,        0x00000000);
    rfbClient->setClientConfig(QTmConfiguration::ConfigEventItuKeypad,       false);
    rfbClient->setClientConfig(QTmConfiguration::ConfigEventFunctionKeys,    0x00);
    //Pointer Event Configuration
    rfbClient->setClientConfig(QTmConfiguration::ConfigEventPointer,         0x00000101);
    rfbClient->setClientConfig(QTmConfiguration::ConfigEventTouch,           0);
    rfbClient->setClientConfig(QTmConfiguration::ConfigButtonMask,           0x00000101);
    rfbClient->setClientConfig(QTmConfiguration::ConfigEventPointer,         0x00000101);
    rfbClient->setClientConfig(QTmConfiguration::ConfigTouchNumber,          0x00);
    rfbClient->setClientConfig(QTmConfiguration::ConfigPressureMask,         0x00);
    */

    // Enable framebuffer updates
    rfbClient->setClientConfig(QTmConfiguration::ConfigFbUpdates,            true);

    rfbClient->setSurface(this);

    connect(this,      SIGNAL(tmPointerEvent(QTmPointerEvent *)),
            rfbClient, SLOT  (  pointerEvent(QTmPointerEvent *)),
            Qt::BlockingQueuedConnection);

    // Start session
    if (!rfbClient->sessionStart(app->url())) {
        qWarning() << "RFB client session could not be started";
        return;
    }

    m_thread = new QThread();
    m_thread->start();
    rfbClient->moveToThread(m_thread);
}


void RemoteDisplay::geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    Q_UNUSED(oldGeometry);
    QDeclarativeItem::geometryChanged(newGeometry, oldGeometry);

    //QWriteLocker wLocker(&m_surfaceResizeLock);
    m_rect = newGeometry;

    if (m_surface) {
        m_transform = getTransformation(m_rect.size().toSize(), m_surface->size());
        m_transformInverted = m_transform.inverted();
    }
}


uchar* RemoteDisplay::allocateSurface(const QSize &s, QTmGlobal::TmColorFormat colorFormat)
{
    //if(m_surface && m_surfaceTmColorFormat == colorFormat && m_surface->width() == s.width()
    //                                                      && m_surface->height() == s.height())
    //    return (uchar*) m_surface->bits();

    QImage *tmp;
    switch (colorFormat) {
    case QTmGlobal::RGB888:
        tmp = new QImage(s, QImage::Format_RGB32);
        break;
    case QTmGlobal::RGB565:
        tmp = new QImage(s, QImage::Format_RGB16);
        break;
    case QTmGlobal::RGB555:
        tmp = new QImage(s, QImage::Format_RGB555);
        break;
    case QTmGlobal::RGB444:
    case QTmGlobal::RGB343:
        tmp = new QImage(s, QImage::Format_RGB444);
        break;
    default:
        qWarning() << "Surface: unknown color format";
        return 0;
    }

    // Fill in background color
    tmp->fill(128);

    // QWriteLocker wLocker(&m_surfaceResizeLock);
    if (m_surface)
        delete m_surface;

    // m_surfaceTmColorFormat = colorFormat;
    m_surface = tmp;

    m_transform = getTransformation(m_rect.size().toSize(), m_surface->size());
    m_transformInverted = m_transform.inverted();

    return static_cast<uchar*>(m_surface->bits());
}

void RemoteDisplay::deallocateSurface()
{
    //QWriteLocker wLocker(&m_surfaceResizeLock);
    if (m_surface) {
        delete m_surface;
        m_surface = 0;
    }
    m_transform.reset();
    m_transformInverted.reset();
    update();
}

void RemoteDisplay::updateSurface(const QRect &updateRect)
{
    Q_UNUSED(updateRect);
    emit redraw();
}

void RemoteDisplay::redrawSurface()
{
    update();
}

void RemoteDisplay::paint(QPainter *p, const QStyleOptionGraphicsItem *, QWidget *)
{
    //QReadLocker rLocker(&m_surfaceResizeLock);
    if (m_surface && isVisible()) {
        p->save();
        p->setRenderHints(QPainter::Antialiasing |
                          QPainter::SmoothPixmapTransform |
                          QPainter::HighQualityAntialiasing, true);
        QRect tRect = m_surface->rect();
        // set transformation
        p->setTransform(m_transform, true);
        // draw surface
        //p->drawImage(tRect, (*m_surface), tRect);
        //p->drawImage(tRect, (*m_surface));
        //TODO draw image instead of pixmap
        QPixmap pixmap = QPixmap::fromImage(*m_surface);
        p->drawPixmap(tRect, pixmap); //, tRect);
        p->restore();
    }
}

void RemoteDisplay::mousePressEvent(QGraphicsSceneMouseEvent *event)
{
    QTmPointerEvent pointerEvent(m_transformInverted.map(event->pos()).toPoint(), true);
    emit tmPointerEvent(&pointerEvent);
}

void RemoteDisplay::mouseReleaseEvent(QGraphicsSceneMouseEvent *event)
{
    QTmPointerEvent pointerEvent(m_transformInverted.map(event->pos()).toPoint(), false);
    emit tmPointerEvent(&pointerEvent);
}

