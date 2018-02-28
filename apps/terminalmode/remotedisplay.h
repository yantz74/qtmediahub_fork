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

#ifndef REMOTEDSIPLAY_H
#define REMOTEDISPLAY_H

#include <QDeclarativeItem>
#include <QColor>
#include <QNetworkInterface>
#include "QTmSurface.h"

class QTmUpnpControlPoint;
class QTmNetworkObserver;
class QTmRemoteServer;
class QTmApplication;
class QTmPointerEvent;
class QTmRfbClient;

class RemoteDisplay : public QDeclarativeItem, QTmSurface
{
    Q_OBJECT
    //Q_PROPERTY(QString name READ name WRITE setName)
    //Q_PROPERTY(QColor color READ color WRITE setColor)

public:
    RemoteDisplay(QDeclarativeItem *parent = 0);

    virtual uchar* allocateSurface(const QSize& s, QTmGlobal::TmColorFormat colorFormat);
    virtual void deallocateSurface();
    virtual void updateSurface(const QRect& updateRect);

    //QString name() const;
    //void setName(const QString &name);

    //QColor color() const;
    //void setColor(const QColor &color);

    virtual void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);
    virtual void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget = 0);
    virtual void mousePressEvent(QGraphicsSceneMouseEvent *event);
    virtual void mouseReleaseEvent(QGraphicsSceneMouseEvent *event);
    //virtual void  mouseMoveEvent(QGraphicsSceneMouseEvent *event);
    //virtual void  keyPressEvent(QKeyEvent *event);
    //virtual void  keyReleaseEvent(QKeyEvent *event);

private slots:
    void  deviceDetected(QString networkInterfaceName, QNetworkAddressEntry networkEntry);
    //void  deviceLost(QNetworkAddressEntry networkEntry);
    void remoteServerDeviceAdded(QTmRemoteServer *remoteServer);
    void appStarted(QTmApplication*);
    void redrawSurface();

signals:
    void tmPointerEvent(QTmPointerEvent *pointerEvent);
    void redraw();

private:
    //QString m_name;
    //QColor m_color;

    QTmNetworkObserver  *m_networkObserver;
    QTmUpnpControlPoint *m_upnpControlPoint;
    QTmRfbClient        *rfbClient;

    QThread             *m_thread;

    QImage              *m_surface;
    QRectF               m_rect;
    QTransform           m_transform;
    QTransform           m_transformInverted;
};

#endif //REMOTEDISPLAY_H

