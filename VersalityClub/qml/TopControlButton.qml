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
    property string buttonIconSource
    property alias iconAlias: topControlButtonIcon

    FontLoader
    {
        id: regularText;
        source: "../fonts/Qanelas_Regular.ttf"
    }

    id: topControlButton
    radius: height*0.5
    width: buttonWidth
    height: Vars.screenHeight*0.05
    opacity: pressed ? Vars.defaultOpacity : 1
    anchors.top: parent.top
    anchors.topMargin: Helper.toDp(parent.height*0.05, Vars.dpi)
    anchors.horizontalCenter: parent.horizontalCenter
    contentItem: Text
    {
        id: buttonTextContent
        clip: true
        text: buttonText
        font.pixelSize: Helper.toDp(13, Vars.dpi)
        font.family: regularText.name
        color: Vars.backgroundWhite
        leftPadding: parent.radius*0.8
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle
    {
        id: buttonBackground
        clip: true
        radius: height*0.5
        anchors.centerIn: parent
        /*swaped geometry and rotation is a
        trick for left to right gradient*/
        height: parent.width
        width: parent.height
        rotation: -90
        gradient: Gradient
        {
            GradientStop { position: 0.0; color: "#852970" }
            GradientStop { position: 1.0; color: "#5b1a5c" }
        }
    }

    Image
    {
        id: topControlButtonIcon
        source: buttonIconSource
        width: parent.radius
        height: parent.radius
        anchors.right: parent.right
        anchors.rightMargin: parent.radius
        anchors.verticalCenter: parent.verticalCenter
    }
}
