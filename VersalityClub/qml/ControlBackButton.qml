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

//ios back button
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

RoundButton
{
    FontLoader
    {
        id: regularText;
        source: Vars.regularFont
    }

    id: backButton
    Layout.alignment: Qt.AlignHCenter
    opacity: pressed ? Vars.defaultOpacity : 1
    contentItem: Item
    {
        Row
        {
            id: row
            anchors.centerIn: parent
            spacing: Helper.applyDpr(5, Vars.dpr)

            Image
            {
                id: buttonIcon
                source: "../icons/left_arrow_2.svg"
                sourceSize.width: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
                sourceSize.height: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
                anchors.verticalCenter: parent.verticalCenter
            }

            Text
            {
                id: buttonText
                clip: true
                text: Vars.back
                color: Vars.purpleTextColor
                font.family: regularText.name
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
            }
        }
    }
    background: Rectangle
    {
        id: buttonBackground
        clip: true
        color: "transparent"
        implicitWidth: row.width*1.2
        implicitHeight: Vars.screenHeight*0.09
    }
}
