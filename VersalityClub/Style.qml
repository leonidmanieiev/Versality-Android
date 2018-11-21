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
import "."
import QtQuick 2.11
import QtQuick.Window 2.11
import "js/helpFunc.js" as Helper

QtObject
{
    //COLORS
    readonly property color backgroundWhite: "#FFFFFF"
    readonly property color backgroundBlack: "#000000"
    readonly property color toastGrey: "#76797c"
    readonly property color listViewGrey: "#e8e9ea"
    readonly property color mainPurple: "#631964"
    readonly property color errorRed: "RED"
    readonly property color activeCouponColor: "#f93738"
    readonly property color copyrightBackgroundColor: "#c4c5c6"

    //REGEX
    readonly property var emailRegEx: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

    //FOR PASS
    readonly property string xorStr: "8fdda158eeb8c0ed9d151991aff3c84c"

    //PROMOTION CONSTANTS
    readonly property int posTimeOut: 30*60000//minutes to milliseconds
    readonly property int posGetFar: 500//in meters
    readonly property int promCloseDist: 50//in meters
    readonly property int maxLineCnt: 3
    property string promsResponse: ''

    //FOOTERBUTTONS CONSTANTS
    readonly property int footerButtonsFieldHeight: screenHeight*0.125
    readonly property int footerButtonsHeight: screenWidth*0.1
    readonly property int footerButtonsSpacing: screenWidth*0.05

    //MAP CONSTANTS
    readonly property int mapButtonSize: screenWidth*0.09

    //SCREEN CONSTANTS
    readonly property int dpi: Screen.pixelDensity * 25.4
    readonly property int pageHeight: screenHeight-footerButtonsFieldHeight
    readonly property int screenHeight: Qt.platform.os === "windows" ?
                                        Helper.toDp(480, dpi) :
                                        Helper.toDp(Screen.height, dpi)
    readonly property int screenWidth: Qt.platform.os === "windows" ?
                                       Helper.toDp(320, dpi) :
                                       Helper.toDp(Screen.width, dpi)

    //LISTVIEW CONSTANTS
    readonly property int listItemRadius: 20

    //INTERTEN ACCESS FLAG          check QTBUG-40328
    property bool isConnected: Qt.platform.os === "windows" ? true : false

    //LOCATION ACCESS FLAG
    property bool isLocated: Qt.platform.os === "windows" ? true : false
}
