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

import QtQuick 1.1
import "components/"

Window {
    id: root

    focalWidget: forecastPanel

    anchors.fill: parent

    function fahrenheit2celsius(f) {
        return ((f-32)*5/9.0).toFixed(0);
    }

    function showCast(name) {
        runtime.skin.settings.weatherCity = name;
        weather.opacity=1.0;
    }

    function fullWeekDay(name) {
        var map = {
            "Mon" : qsTr("MONDAY"),
            "Tue" : qsTr("TUESDAY"),
            "Wed" : qsTr("WEDNESDAY"),
            "Thu" : qsTr("THURSDAY"),
            "Fri" : qsTr("FRIDAY"),
            "Sat" : qsTr("SATURDAY"),
            "Sun" : qsTr("SUNDAY"),
    };
        if (typeof map[name] != "undefined")
            return map[name];
        else
            return "";
    }

    function mapToFile(name) {
        if (typeof name != "undefined") {
            var map = {
                "chance_of_rain" : "Rain.qml",
                "sunny" : "Sunny.qml",
                "mostly_sunny" : "MostlySunny.qml",
                "partly_cloudy" : "PartlyCloudy.qml",
                "mostly_cloudy" : "MostlyCloudy.qml",
                "chance_of_storm" : "Storm.qml",
                "showers" : "Rain.qml",
                "rain" : "Rain.qml",
                "chance_of_snow" : "UnknownForecast.qml",
                "cloudy" : "MostlyCloudy.qml",
                "mist" : "Mist.qml",
                "storm" : "Storm.qml",
                "thunderstorm" : "Thunderstorm.qml",
                "chance_of_tstorm" : "Thunderstorm.qml",
                "sleet" : "UnknownForecast.qml",
                "snow" : "UnknownForecast.qml",
                "icy" : "UnknownForecast.qml",
                "dust" : "UnknownForecast.qml",
                "fog" : "Fog.qml",
                "smoke" : "UnknownForecast.qml",
                "haze" : "Haze.qml",
                "flurries" : "UnknownForecast.qml"
            }

            var tmp = "UnknownForecast.qml";
            var slice = name.substring(name.lastIndexOf("/")+1,name.lastIndexOf("."));

            if (map[slice])
                tmp = map[slice]

            return "weather/forecasts/"+tmp;
        }
       return "weather/forecasts/UnknownForecast.qml";
    }

    function stripLast5(string) {
        return (string.substr(0, string.length-5))
    }

    function loadForecastQml() {
        if (weatherMeasurements.count > 0) {
            forecastLoader.source = ""
            forecastLoader.source = mapToFile(weatherMeasurements.get(0).icon)
        }
    }

    bladeComponent: Blade {
        parent: root
        bladeWidth: banner.x + banner.width + 50
        bladePixmap: themeResourcePath + "/media/HomeBlade.png"

        hoverEnabled: true
        onEntered: open();
        onExited: close()

        content: Item {
            anchors { fill: parent; topMargin: 50; leftMargin: closedBladePeek + 5; rightMargin: 5 }

            Image {
                id: banner
                source: themeResourcePath + "/media/Confluence_Logo.png"
                anchors.bottomMargin: 10
            }

            ConfluenceListView {
                id: listView
                anchors { top: banner.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }

                scrollbar: false
                focus: true
                model: cityList

                delegate: Item {
                    id: delegateItem
                    width: listView.width
                    height: thistext.height + 8
                    Image {
                        anchors.fill: parent;
                        source: themeResourcePath + "/media/" + (delegateItem.ListView.isCurrentItem ? "MenuItemFO.png" : "MenuItemNF.png");
                    }
                    ConfluenceText {
                        id: thistext
                        anchors.verticalCenter: parent.verticalCenter
                        color: "white"
                        text: name
                    }
                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true
                        onEntered:
                            delegateItem.ListView.view.currentIndex = index
                        onClicked:
                            showCast(name)
                    }
                    Keys.onEnterPressed: {
                        showCast(name)
                        event.accepted = true
                    }
                }
            }
        }
    }

    Row {
        id: weather
        anchors.fill: parent

        Panel {
            width: parent.width*0.67
            height: parent.height

            Loader {
                id: forecastLoader
                anchors.fill: parent

                onLoaded: {
                    var tmp = weatherMeasurements.get(0);
                    var info = forecastInformation.get(0);
                    item.cityName = runtime.skin.settings.weatherCity;
                    forecastLoader.item.present()

                    if (typeof info != "undefined" && typeof info.current_date_time != "undefined") {
                        var date_time = info.current_date_time;
                        var slice = date_time.substring(date_time.indexOf(" ")+1,date_time.indexOf(":"));
                        item.isDay = slice > 18 || slice < 6 ? false : true;
                    } else {
                        item.isDay = true;
                    }

                    if (typeof tmp != "undefined") {
                        item.currentTemperature = typeof tmp.temp_c != "undefined" ? tmp.temp_c : "";
                        item.currentHumidity = typeof tmp.humidity != "undefined" ? tmp.humidity : "";
                        item.currentWindCondition = typeof tmp.wind_condition != "undefined" ? tmp.wind_condition : "";
                    }
                }
            }


            MouseArea {
                anchors.fill: parent
                onPressed: { forecastLoader.item.state = "" }
                onReleased: { forecastLoader.item.state = "final" }
            }
        }

        Panel {
            id: forecastPanel
            width: parent.width*0.33
            height: parent.height

            Column {
                anchors.centerIn: parent
                width: parent.width
                height: childrenRect.height

                ConfluenceText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("WEATHER FORECAST")
                    font.pixelSize: parent.width/11
                }

                Item {
                    width: parent.width
                    height: 50
                }

                ListView {
                    id: forecastListView
                    //Need to find out why implicitHeight
                    //does not use item.height*itemCount
                    property real contentHeightHack: 120*count
                    height: Math.min(contentHeightHack, forecastPanel.height/1.3)
                    width: parent.width
                    clip: true
                    model: weatherForecast
                    interactive: contentHeightHack > height

                    delegate: Item {
                        height: 120
                        width: forecastPanel.width

                        Rectangle {
                            id: sep
                            width: parent.width
                            height: 4
                            radius: 2
                            color: "#40FFFFFF"
                            anchors.topMargin: 5
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        ConfluenceText {
                            id: dayofweek
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: sep.bottom; anchors.topMargin: 8
                            text: weatherForecast.count > 0 && weatherForecast.get(index)
                                  && typeof weatherForecast.get(index).day_of_week != "undefined"
                                  ? fullWeekDay(weatherForecast.get(index).day_of_week)
                                  : ""
                        }

                        Item {
                            id: forecastTextInfo
                            anchors.top: dayofweek.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: childrenRect.height; width: childrenRect.width
                            ConfluenceText {
                                id: hightemptext
                                smooth: true
                                color: "grey"
                                text: qsTr("High: ")
                            }
                            ConfluenceText {
                                id: hightempvalue
                                anchors.left: hightemptext.right
                                font.weight: Font.Normal
                                text: weatherForecast.count > 0
                                      && weatherForecast.get(index)
                                      && typeof weatherForecast.get(index).high_f != "undefined"
                                      ? root.fahrenheit2celsius(weatherForecast.get(index).high_f) + " °C"
                                      : ""
                            }
                            ConfluenceText {
                                id: lowtemptext
                                anchors.left: hightempvalue.right; anchors.leftMargin: 25
                                smooth: true
                                color: "grey"
                                text: qsTr("Low: ")
                            }
                            ConfluenceText {
                                anchors.left: lowtemptext.right;
                                font.weight: Font.Normal
                                text: weatherForecast.count > 0 && weatherForecast.get(index) && typeof weatherForecast.get(index).low_f != "undefined"  ? root.fahrenheit2celsius(weatherForecast.get(index).low_f)  + " °C" : ""
                            }
                            ConfluenceText {
                                id: condition
                                anchors.top: hightemptext.bottom
                                font.weight: Font.Normal
                                text: weatherForecast.count > 0 && weatherForecast.get(index) && typeof weatherForecast.get(index).condition != "undefined" ? weatherForecast.get(index).condition : ""
                            }
                        }
//                        Image {
//                            id: weatherIconSmall
//                            width: forecastTextInfo.height/1.5
//                            height: width
//                            smooth: true
//                            asynchronous: true
//                            source: weatherForecast.count > 0 && weatherForecast.get(index) && typeof weatherForecast.get(index).icon != "undefined"  ? mapIcon(weatherForecast.get(index).icon) : ""
//                            anchors.left: forecastTextInfo.right

////                            SequentialAnimation {
////                                NumberAnimation { target: weatherIconSmall.anchors; property: "rightMargin"; from: 30; to: 10; duration: 2000; easing.type: Easing.InOutBack }
////                                NumberAnimation { target: weatherIconSmall.anchors; property: "rightMargin"; from: 10; to: 30; duration: 2000; easing.type: Easing.InOutBack }

////                                running: true
////                                loops: Animation.Infinite
////                            }
//                        }
                    }
                }
            }
        }

        Behavior on opacity { PropertyAnimation { duration: 500 } }
    }

    XmlListModel {
        id: forecastInformation
        source: "http://www.google.com/ig/api?weather=" + runtime.skin.settings.weatherCity
        query: "/xml_api_reply/weather/forecast_information"

        //forecast information
        XmlRole { name: "city"; query: "city/@data/string()" }
        XmlRole { name: "forecast_date"; query: "forecast_date/@data/string()" }
        XmlRole { name: "current_date_time"; query: "current_date_time/@data/string()" }
    }

    XmlListModel {
        id: weatherMeasurements
        source: "http://www.google.com/ig/api?weather=" + runtime.skin.settings.weatherCity
        query: "/xml_api_reply/weather/current_conditions"

        onCountChanged: if (count > 0) root.loadForecastQml()

        //current condition
        XmlRole { name: "condition"; query: "condition/@data/string()" }
        XmlRole { name: "temp_c"; query: "temp_c/@data/string()" }
        XmlRole { name: "humidity"; query: "humidity/@data/string()" }
        XmlRole { name: "icon"; query: "icon/@data/string()" }
        XmlRole { name: "wind_condition"; query: "wind_condition/@data/string()" }

    }

    XmlListModel {
        id: weatherForecast
        source: "http://www.google.com/ig/api?weather=" + runtime.skin.settings.weatherCity
        query: "/xml_api_reply/weather/forecast_conditions"

        XmlRole { name: "day_of_week"; query: "day_of_week/@data/string()" }
        XmlRole { name: "low_f"; query: "low/@data/string()" }
        XmlRole { name: "high_f"; query: "high/@data/string()" }
        XmlRole { name: "icon"; query: "icon/@data/string()" }
        XmlRole { name: "condition"; query: "condition/@data/string()" }

    }

    ListModel {
        id: cityList
        ListElement { name: "Amsterdam" }
        ListElement { name: "Atlanta" }
        ListElement { name: "Bangalore" }
        ListElement { name: "Bangkok" }
        ListElement { name: "Barcelona" }
        ListElement { name: "Beijing" }
        ListElement { name: "Berlin" }
        ListElement { name: "Bogota" }
        ListElement { name: "Boston" }
        ListElement { name: "Cape Town" }
        ListElement { name: "Casablanca" }
        ListElement { name: "Durban" }
        ListElement { name: "Helsinki" }
        ListElement { name: "Juneau" }
        ListElement { name: "Landshut" }
        ListElement { name: "Las Vegas" }
        ListElement { name: "Lhasa" }
        ListElement { name: "Lima" }
        ListElement { name: "London" }
        ListElement { name: "Manila" }
        ListElement { name: "Munich" }
        ListElement { name: "Moscow" }
        ListElement { name: "New York" }
        ListElement { name: "Nuuk" }
        ListElement { name: "Paris" }
        ListElement { name: "Rome" }
        ListElement { name: "San Francisco" }
        ListElement { name: "Seoul" }
        ListElement { name: "Sydney" }
        ListElement { name: "Tokyo" }
        ListElement { name: "Ulm" }
        ListElement { name: "Untermarchtal" }
    }
}
