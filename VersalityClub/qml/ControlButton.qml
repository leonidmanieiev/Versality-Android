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

//standard button
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Button
{
    property string buttonText: ''
    property color labelContentColor: Vars.fontsPurple
    property color backgroundColor: Vars.backgroundWhite
    property color setBorderColor: Vars.fontsPurple
    property real setHeight: Vars.screenHeight*0.09
    property real setWidth: Vars.screenWidth*0.8
    property int fontPixelSize: Vars.defaultFontPixelSize

    FontLoader
    {
        id: mediumText;
        source: "../fonts/Qanelas_Medium.ttf"
    }

    id: controlButton
    opacity: pressed ? Vars.defaultOpacity : 1
    background: ControlBackground
    {
        id: background
        color: backgroundColor
        borderColor: setBorderColor
        /*swaped geometry and rotation is a trick for
        left to right gradient*/
        h: setHeight
        w: setWidth
        /*gradient: Gradient
        {
            GradientStop { position: 0.0; color: "#390d5e" }
            GradientStop { position: 1.0; color: "#952e74" }
        }*/
    }
    contentItem: Text
    {
        id: labelContent
        text: buttonText
        font.family: mediumText.name
        font.pixelSize: Helper.toDp(fontPixelSize, Vars.dpi)
        color: labelContentColor
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
