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
    readonly property color mainPurple: "#631964"
    readonly property color errorRed: "RED"

    readonly property var emailRegEx: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

    readonly property int dpi: Screen.pixelDensity * 25.4
    readonly property int screenHeight: Qt.platform.os === "windows" ?
                                        Helper.toDp(480, dpi) :
                                        Helper.toDp(Screen.height, dpi)
    readonly property int screenWidth: Qt.platform.os === "windows" ?
                                       Helper.toDp(320, dpi) :
                                       Helper.toDp(Screen.width, dpi)
}
