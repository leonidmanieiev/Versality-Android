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

//Rounding image
import QtQuick 2.11
import QtGraphicalEffects 1.0

Item
{
    property string imageSource: ''
    property int roundValue: 0

    id: item
    height: parent.height
    width: parent.width

    Image
    {
        id: image
        source: imageSource
        width: parent.width
        height: parent.height
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        layer.effect: OpacityMask { maskSource: imgMask }
    }

    Rectangle
    {
        id: imgMask
        width: parent.width
        height: parent.height
        radius: roundValue
        visible: false
    }
}
