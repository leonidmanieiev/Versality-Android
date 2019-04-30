/****************************************************************************
**
** Copyright (C) 2019 Leonid Manieiev.
** Contact: leonid.manieiev@gmail.com
**
** This file is part of Versality.
**
** Versality is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** Versality is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Versality. If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/

//Static notifier
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11

Rectangle
{
    property string notifierText: ''

    id: notifier
    visible: false
    width: textContent.width*1.2
    height: textContent.height*2
    anchors.top: parent.top
    anchors.topMargin: parent.height*0.3
    anchors.horizontalCenter: parent.horizontalCenter
    color: Vars.popupWindowColor
    radius: height*0.5
    opacity: 0.9

    Text
    {
        id: textContent
        text: notifierText
        anchors.centerIn: parent
        color: Vars.backgroundWhite
        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                    Vars.dpi)
    }
}
