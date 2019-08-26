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

//shows guest info about impossibility to use this functionality
import "../"
import QtQuick 2.11
import QtQuick.Controls 2.4
import "../js/helpFunc.js" as Helper

Popup
{
    function setGuestText(message)
    {
        popupContent.text = message;
        open();
        guestToastMessageTimer.running = true;
    }

    FontLoader
    {
        id: regularText;
        source: Vars.regularFont
    }

    id: guestToastMessage
    x: (Vars.screenWidth - popupBackground.width) * 0.5
    y: Vars.pageHeight*0.2
    contentItem: Text
    {
        id: popupContent
        clip: true
        anchors.centerIn: popupBackground
        height: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
        width: Vars.screenWidth*0.7
        font.pixelSize: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
        font.family: regularText.name
        color: Vars.whiteColor
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }
    background: Rectangle
    {
        id: popupBackground
        width: Vars.screenWidth*0.9
        height: popupContent.height*1.4
        radius: Vars.defaultRadius
        color: Vars.toastGrey
    }

    //Smoothed show up animation
    enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 } }
    //Smoothed hide out animation
    exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 } }

    onClosed: popupContent.text = '';

    //defines period of time that popup is visiable
    Timer
    {
        id: guestToastMessageTimer
        interval: 5000 // 5 sec
        onTriggered: guestToastMessage.close()
    }
}