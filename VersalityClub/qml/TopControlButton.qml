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

//top button
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4

RoundButton
{
    property string buttonText: ''
    property real buttonWidth: 0.0

    id: topControlButton
    opacity: pressed ? 0.8 : 1
    height: Style.screenHeight*0.05
    width: buttonWidth
    radius: height*0.5
    anchors.horizontalCenter: parent.horizontalCenter
    contentItem: Text
    {
        id: buttonTextContent
        text: buttonText
        font.pixelSize: Helper.toDp(13, Style.dpi)
        color: Style.backgroundWhite
        leftPadding: parent.radius*0.8
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle
    {
        id: buttonBackground
        anchors.fill: parent
        radius: height*0.5
        color: Style.mainPurple
        border.color: "transparent"
    }

    Rectangle
    {
        id: topControlButtonIcon
        color: "red"
        width: parent.radius
        height: width
        radius: height*0.5
        anchors.right: parent.right
        anchors.rightMargin: parent.radius
        anchors.verticalCenter: parent.verticalCenter
    }
}
