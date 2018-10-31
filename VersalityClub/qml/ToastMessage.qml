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
import "../js/helpFunc.js" as Helper

Popup
{
    property color backgroundColor: Style.toastGrey

    function setText(messageText)
    {
        popupContent.text = messageText;
        open();
    }

    function setTextAndRun(messageText)
    {
        popupContent.text = messageText;
        open();
        toastMessageTimer.running = true;
    }

    id: toastMessage
    x: Style.screenWidth*0.1
    y: Style.screenHeight - height
    contentItem: Text
    {
        id: popupContent
        clip: true
        anchors.centerIn: popupBackground
        height: Helper.toDp(15, Style.dpi)
        width: Helper.toDp(text.length, Style.dpi)
        font.pixelSize: Helper.toDp(15, Style.dpi)
        color: Style.backgroundWhite
        wrapMode: Text.WordWrap
    }
    background: Rectangle
    {
        id: popupBackground
        width: Style.screenWidth*0.8
        height: popupContent.height*2
        radius: parent.height*0.5
        color: backgroundColor
    }
    //Smoothed show up animation
    enter: Transition
    {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }
    //Smoothed hide out animation
    exit: Transition
    {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }

    //defines period of time that popup is visiable
    Timer
    {
        id: toastMessageTimer
        interval: 3000
        onTriggered: toastMessage.close()
    }
}
