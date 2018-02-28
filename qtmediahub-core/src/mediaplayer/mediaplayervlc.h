/** This file is part of Qt Media Hub**

Copyright (c) 2012 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Nokia Corporation qmh-development@qt-project.org

You may use this file under the terms of the BSD license
as follows:

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:
* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of Nokia Corporation and its Subsidiary(-ies)
nor the names of its contributors may be used to endorse or promote
products derived from this software without specific prior
written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. **/

#ifndef MEDIAPLAYERVLC_H
#define MEDIAPLAYERVLC_H

#include "abstractmediaplayer.h"

#include <vlc/vlc.h>

class QWidget;

class MediaPlayerVLC : public AbstractMediaPlayer
{
    Q_OBJECT
public:
#ifdef QT5
    explicit MediaPlayerVLC(QQuickItem *parent = 0);
#else
    explicit MediaPlayerVLC(QDeclarativeItem *parent = 0);
#endif
    ~MediaPlayerVLC();

    virtual QString source() const;

    virtual bool hasVideo() const;
    virtual bool hasAudio() const;

    virtual bool playing() const;
    virtual qreal volume() const;
    virtual int position() const;
    virtual bool seekable() const;
    virtual bool paused() const;
    virtual qreal playbackRate() const;
    virtual int duration() const;

public slots:
    virtual void setSource(const QString &source);
    virtual void play();
    virtual void stop();
    virtual void pause();
    virtual void resume();
    virtual void mute(bool on = true);
    virtual void setPosition(int position);
    virtual void setPositionPercent(qreal position);
    virtual void setVolumePercent(qreal volume);
    virtual void setVolume(qreal volume);
    virtual void setPlaybackRate(qreal rate);

protected:
    void timerEvent(QTimerEvent *);
    virtual void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);

private:
    void setHasAudio(bool a);
    void setHasVideo(bool v);

    libvlc_instance_t * m_instance;
    libvlc_media_player_t *m_mediaPlayer;
    libvlc_media_t *m_media;
    QWidget *m_surface;

    QString m_source;
    bool m_hasVideo;
    bool m_hasAudio;
    bool m_playing;
    qreal m_volume;
    qreal m_position;
    bool m_seekable;
    bool m_paused;
    qreal m_playbackRate;
    int m_duration;
};

#endif // MEDIAPLAYERVLC_H
