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

//template for text field
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

TextField
{
    property color setFillColor: Vars.purpleBorderColor
    property color setBorderColor: Vars.whiteColor
    property color setTextColor: Vars.whiteColor


    id: customTextFiled
    cursorVisible: false
    horizontalAlignment: Text.AlignHCenter
    color: setTextColor
    font.family: mediumText.name
    font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
    background: ControlBackground
    {
        anchors.centerIn: parent
        rectWidth: parent.width
        rectFillColor: setFillColor
        rectBorderColor: setBorderColor
    }

    FontLoader
    {
        id: mediumText;
        source: Vars.mediumFont
    }
}
