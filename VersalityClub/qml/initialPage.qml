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

import "../"
import QtQuick 2.11
import QtQuick.Controls 2.4

Rectangle
{
    id: initialPage
    anchors.fill: parent

    Rectangle
    {
        id: headRect
        anchors.top: initialPage.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: -parent.height/8
        height: parent.width/2
        width: parent.width
        radius: 100
        color: "black"
    }

    Rectangle
    {
        id: footRect
        anchors.bottom: initialPage.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: -parent.height/8
        height: parent.width/2
        width: parent.width
        radius: 100
        color: "black"
    }
}
