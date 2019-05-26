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

//button with icon
import "../"
import QtQuick 2.11
import QtGraphicalEffects 1.0

Rectangle
{
    property string buttonIconSource
    property int rotateAngle: 0
    property alias clickArea: clickableArea
    property alias buttonIconAlias: buttonIcon

    id: buttonBackground
    color: "transparent"
    opacity: clickableArea.pressed ?
                 Vars.defaultOpacity : 1

    Image
    {
        id: buttonIcon
        clip: true
        source: buttonIconSource
        width: parent.width
        height: parent.height
        rotation: rotateAngle
        fillMode: Image.PreserveAspectFit
    }

    MouseArea
    {
        id: clickableArea
        anchors.fill: parent
    }
}
