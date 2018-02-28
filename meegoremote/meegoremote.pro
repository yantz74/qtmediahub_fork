# Add more folders to ship with the application, here

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

QT+= declarative network
symbian:TARGET.UID3 = 0xE34F59FB

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

include(jsonparser/json.pri)

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    rpcconnection.cpp \
    actionmapper.cpp \
    devicelist.cpp \
    inputcontextrpc.cpp \
    devicediscovery.cpp \
    contextcontentrpc.cpp

HEADERS += \
    rpcconnection.h \
    actionmapper.h \
    devicelist.h \
    inputcontextrpc.h \
    devicediscovery.h \
    contextcontentrpc.h

OTHER_FILES += \
    qml/main.qml \
    meegoremote.desktop \
    meegoremote.svg \
    meegoremote.png \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/TargetsPage.qml \
    qml/ControlPage.qml \
    qml/Trackpad.qml \
    qml/BusyPage.qml \
    qml/NewDeviceSheet.qml \
    qml/UpdateDeviceSheet.qml \
    qml/AboutDialog.qml \
    qml/DeviceDeleteDialog.qml \
    qml/VirtualKeyboard.qml \
    qml/Key.qml \
    QMHLogo.png \
    qml/AllDeviceDeleteDialog.qml

RESOURCES += \
    res.qrc

# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()

# enable booster
CONFIG += qdeclarative-boostable
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic



