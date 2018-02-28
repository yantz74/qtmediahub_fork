#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "Please specify path to NokiaDrive application"
    exit 1
elif [ ! -d $1 ]; then
    echo "$1 is not a directory"
else
    mkdir -p imports

    subfolders=( components models resources utils views )

    for f in ${subfolders[@]}; do
        if [ ! -d "$1/$f" ]; then
            echo "$1/$f does not exist"
        else
            ln -s $1/$f/ imports/$f
        fi
    done

    cp QmhNokiaDrive.qml $1/views
    ln -s $1/views/main.qml $1/views/QmhMain.qml
    echo "Window 1.0 ../../../../skins/rapid/480/Window.qml" > $1/views/qmldir

    mkdir -p imports/SettingsManager
    cp $1/libmamba-plugin.so imports/SettingsManager/
    echo "plugin mamba-plugin" > imports/SettingsManager/qmldir

    cp qmhmanifest qmhmanifest.qml
fi
