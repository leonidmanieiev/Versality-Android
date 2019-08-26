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

//Marker for promotion point on map
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4

Image
{
    property int iconId

    id: promMarker
    clip: true
    source: "../icons/promotion_marker.svg"

    Image
    {
        id: promMarkerIcon
        sourceSize.width: parent.width*0.5
        sourceSize.height: parent.width*0.5
        smooth: true
        anchors.top: parent.top
        anchors.topMargin: parent.width*0.15
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../icons/cat_"+iconId+".svg"
    }
}
