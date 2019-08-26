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

//help content for almostDonePage
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item
{
    property string helpImageSource
    property string helpText

    id: helpCompItem

    Column
    {
        id: column
        spacing: Vars.screenHeight * 0.07
        anchors.horizontalCenter: parent.horizontalCenter

        Image
        {
            id: helpImage
            clip: true
            sourceSize.width: Vars.screenWidth*0.3
            sourceSize.height: Vars.screenWidth*0.3
            source: helpImageSource
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label
        {
            id: helpLabel
            text: helpText
            color: Vars.whiteColor
            font.family: regularText.name
            font.pixelSize: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }//column
}//helpCompItem
