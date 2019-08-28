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

//Rounding image
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtGraphicalEffects 1.0

// thanks goes to BaCaRoZzo from stackoverflow
Image
{
    property string imageSource: ''
    property int roundValue: 0
    property bool rounded: true
    property bool adapt: true
    property bool crop: false

    id: img
    width:  parent.width
    height: parent.height
    fillMode: crop ? Image.PreserveAspectCrop : Image.Stretch
    source: Helper.adjastPicUrl(imageSource)

    layer.enabled: rounded
    layer.effect: OpacityMask
    {
        maskSource: Item
        {
            width:  img.width
            height: img.height

            Rectangle
            {
                anchors.centerIn: parent
                width: img.adapt ? img.width : Math.min(img.width, img.height)
                height: img.adapt ? img.height : width
                radius: roundValue
            }
        }
    }
}
