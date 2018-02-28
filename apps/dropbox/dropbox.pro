TEMPLATE     = lib
CONFIG      += plugin
QT          += declarative network
TARGET       = dropboxplugin
DESTDIR      = imports/Dropbox
MOC_DIR      = .moc
OBJECTS_DIR  = .obj

INCLUDEPATH = ../../qtmediahub-core/src/3rdparty/jsonparser/

HEADERS      = dropboxplugin.h \
               dropboxdeclarative.h \
               dropboxsession.h

SOURCES      = dropboxplugin.cpp \
               dropboxdeclarative.cpp \
               dropboxsession.cpp \
               ../../qtmediahub-core/src/3rdparty/jsonparser/json.cpp

system(mkdir -p $$DESTDIR)
system([ -f $$DESTDIR/qmldir ] || echo "plugin $$TARGET" >> $$DESTDIR/qmldir)
system([ -f qmhmanifest.qml ] || mv qmhmanifest qmhmanifest.qml)

