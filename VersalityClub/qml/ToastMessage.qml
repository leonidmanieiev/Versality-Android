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

//temaplte popup - toast message
import "../"
import QtQuick 2.11
import QtQuick.Controls 2.4
import "../js/toDp.js" as Convert

Popup
{
    property string messageText: ''
    readonly property alias tmt: toastMessageTimer

    id: toastMessage
    x: (Style.screenWidth - width) / 2
    y: (Style.screenHeight - height)
    contentItem: Text
    {
        id: popupContent
        clip: true
        text: messageText
        anchors.centerIn: popupBackground
        height: Convert.toDp(15, Style.dpi)
        width: Convert.toDp(text.length, Style.dpi)
        font.pixelSize: Convert.toDp(15, Style.dpi)
        color: Style.backgroundWhite
    }
    background: Rectangle
    {
        id: popupBackground
        width: popupContent.width*1.2
        height: popupContent.height*1.2
        radius: parent.height*0.5
        color: Style.mainPurple
    }
    enter: Transition
    {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }
    exit: Transition
    {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }

    Timer
    {
        id: toastMessageTimer
        interval: 3000
        onTriggered: toastMessage.close()
    }
}
