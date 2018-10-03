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

//template textfiled for email
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4


TextField
{
    property color setFillColor: Style.backgroundWhite
    property color setBorderColor: Style.backgroundBlack

    id: emailTextField
    implicitWidth: parent.width*0.9
    horizontalAlignment: Text.AlignHCenter
    background: ControlBackground
    {
        fillColor: setFillColor
        borderColor: setBorderColor
    }
    placeholderText: qsTr("*****@****.**")
    font.pixelSize: Helper.toDp(15, Style.dpi)
    color: Style.backgroundBlack
    inputMethodHints: Qt.ImhEmailCharactersOnly
    validator: RegExpValidator { regExp: Style.emailRegEx }
    onFocusChanged:
    {
        //workaround to get default text color after incorrect input
        if(color === Style.errorRed)
        {
            color = Style.backgroundBlack;
            text = ''
        }
    }
}
