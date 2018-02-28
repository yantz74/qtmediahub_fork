TEMPLATE     = lib
CONFIG      += plugin
QT          += declarative xml network
TARGET       = remotedisplayplugin
DESTDIR      = imports/RemoteDisplay
MOC_DIR      = .moc
OBJECTS_DIR  = .obj

LIBS        += -L$$[QT_INSTALL_LIBS]/libqterminalmode/ -lQtTerminalMode
INCLUDEPATH += $$[QT_INSTALL_HEADERS]/QtTerminalMode/

HEADERS      = remotedisplay.h \
               remotedisplayplugin.h

SOURCES      = remotedisplay.cpp \
               remotedisplayplugin.cpp

system(mkdir -p $$DESTDIR)
system(echo "plugin $$TARGET" >> $$DESTDIR/qmldir)
system(mv qmhmanifest qmhmanifest.qml)

