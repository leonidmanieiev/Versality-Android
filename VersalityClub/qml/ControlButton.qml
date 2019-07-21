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

//standard button
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

ControlBackground
{
    property string labelText: ''
    property color labelColor: Vars.purpleTextColor
    property color backgroundColor: Vars.whiteColor
    property color borderColor: Vars.purpleBorderColor
    property real buttonHeight: Vars.screenHeight*0.09
    property real buttonWidth: Vars.screenWidth*0.8
    property real buttonRadius: buttonHeight*0.5
    property int fontPixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
    property alias buttonClickableArea: clickableArea
    property alias labelAlias: label

    id: controlButton
    opacity: clickableArea.pressed ? Vars.defaultOpacity : 1
    rectFillColor: backgroundColor
    rectBorderColor: borderColor
    rectHeight: buttonHeight
    rectWidth: buttonWidth
    rectRadius: buttonRadius

    Text
    {
        id: label
        text: labelText
        font.family: mediumText.name
        font.pixelSize: fontPixelSize
        color: labelColor
        anchors.centerIn: parent
    }

    FontLoader
    {
        id: mediumText;
        source: Vars.mediumFont
    }

    MouseArea
    {
        id: clickableArea
        width: parent.width
        height: parent.height
        onPressed:
        {
            if(label.color === Vars.errorRed)
                label.color = labelColor;
        }
    }
}
