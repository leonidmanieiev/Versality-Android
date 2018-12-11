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

Button
{
    property string buttonText: ''
    property color labelContentColor: Vars.mainPurple
    property color backgroundColor: Vars.backgroundWhite
    property color setBorderColor: Vars.mainPurple
    property real setHeight: Vars.screenHeight*0.09
    property real setWidth: Vars.screenWidth*0.8
    property int fontPixelSize: Vars.defaultFontPixelSize

    id: controlButton
    opacity: pressed ? Vars.defaultOpacity : 1
    background: ControlBackground
    {
        id: background
        color: backgroundColor
        borderColor: setBorderColor
        h: setHeight
        w: setWidth
    }
    contentItem: Text
    {
        id: labelContent
        text: buttonText
        font.pixelSize: Helper.toDp(fontPixelSize, Vars.dpi)
        color: labelContentColor
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
