/****************************************************************************
**
** Copyright (C) 2018 Leonid Manieiev.
** Contact: leonid.manieiev@gmail.com
**
** This file is part of Versality Club.
**
** Versality Club is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** Versality Club is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/

//help properties
pragma Singleton
import QtQuick 2.11
import QtQuick.Window 2.11
import "js/helpFunc.js" as Helper

QtObject
{
    readonly property color backgroundWhite: "#FFFFFF"
    readonly property color backgroundBlack: "#000000"
    readonly property color toastGrey: "#76797c"
    readonly property color listViewGrey: "#e8e9ea"
    readonly property color mainPurple: "#631964"
    readonly property color errorRed: "RED"
    readonly property color activeCouponColor: "#f93738"

    readonly property var emailRegEx: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

    readonly property string xorStr: "8fdda158eeb8c0ed9d151991aff3c84c"
    readonly property int posTimeOut: 30*60000//minutes to milliseconds
    readonly property int posGetFar: 500//in meters
    readonly property int promCloseDist: 100//in meters

    readonly property real footerButtonsFieldHeight: screenHeight*0.125
    readonly property real footerButtonsHeight: screenWidth*0.1
    readonly property real footerButtonsSpacing: screenWidth*0.05
    readonly property real pageHeight: screenHeight-footerButtonsFieldHeight

    readonly property int dpi: Screen.pixelDensity * 25.4
    readonly property int screenHeight: Qt.platform.os === "windows" ?
                                        Helper.toDp(480, dpi) :
                                        Helper.toDp(Screen.height, dpi)
    readonly property int screenWidth: Qt.platform.os === "windows" ?
                                       Helper.toDp(320, dpi) :
                                       Helper.toDp(Screen.width, dpi)
    property string promsResponse: ''
    readonly property int listItemRadius: 20

    readonly property string mapHTML: '<!DOCTYPE html>
                                       <html><head>
                                           <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                                           <script src="https://api-maps.yandex.ru/2.1/?apikey=<1a61a32c-93ff-4f0e-9812-b6a359dc13b9>&lang=ru_RU"
                                                   type="text/javascript"></script>
                                           <script> ymaps.ready(function () {
                                                    var myMap = new ymaps.Map("map", {
                                                            center: [59.933284, 30.343614],
                                                            zoom: 13,
                                                            controls: []
                                                        }),
                                                        userLocationButton = new ymaps.control.Button({
                                                            options: {
                                                                float: "right",
                                                                selectOnClick: false,
                                                                size: "small"
                                                            }
                                                        }),
                                                        userLocationPlacemark = new ymaps.Placemark(['+UserSettings.value("user_data/lat")+
                                                        ', '+UserSettings.value("user_data/lon")+']);

                                                    userLocationButton.events.add("click", function () {
                                                        myMap.geoObjects.add(userLocationPlacemark);
                                                    });

                                                    myMap.controls.add(userLocationButton);});</script>
                                           <style> html, body, #map {
                                                   width: 100%; height: 100%; padding: 0; margin: 0;
                                               }</style>
                                       </head><body><div id="map"></div></body></html>'
}
