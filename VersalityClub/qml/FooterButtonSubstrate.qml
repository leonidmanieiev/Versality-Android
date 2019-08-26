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

//template for FooterButtons substrate
import "../"
import QtQuick 2.11

Rectangle
{
    property string substrateSource: "../icons/footer_button_substrate.svg"

    color: "transparent"

    Image
    {
        clip: true
        anchors.centerIn: parent
        source: substrateSource
        sourceSize.width: parent.width*Vars.iconHeightFactor
        sourceSize.height: parent.height*Vars.iconHeightFactor
        fillMode: Image.PreserveAspectFit
    }
}
