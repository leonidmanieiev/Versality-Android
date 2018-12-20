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

//template background for buttons and field
import "../"
import QtQuick 2.11

Rectangle
{
    property real h: Vars.screenHeight*0.09
    property real w: Vars.screenWidth*0.8
    property int r: h*0.5
    property color fillColor: Vars.backgroundWhite
    property color borderColor: Vars.fontsPurple
    property int borderWidth: h*0.06

    id: controlBackground
    height: h
    width: w
    radius: r
    clip: true
    color: fillColor
    border.color: borderColor
    border.width: borderWidth
    anchors.centerIn: parent
}
