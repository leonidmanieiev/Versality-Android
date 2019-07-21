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

//template background for buttons and field
import "../"
import QtQuick 2.11
import QtGraphicalEffects 1.0

Rectangle
{
    property real rectHeight: Vars.screenHeight*0.09
    property real rectWidth: Vars.screenWidth*0.8
    property int rectRadius: rectHeight*0.5
    property color rectFillColor: Vars.whiteColor
    property color rectBorderColor: Vars.purpleBorderColor
    property int rectBorderWidth: rectHeight*0.06

    id: controlBackground
    clip: true
    height: rectHeight
    width: rectWidth
    radius: rectRadius
    color: rectFillColor
    border.color: rectBorderColor
    border.width: rectBorderWidth
}
