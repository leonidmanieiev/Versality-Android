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
    width: Vars.screenWidth*0.54
    height: Vars.screenHeight*0.5

    Image
    {
        id: helpImage
        clip: true
        width: parent.width*0.5
        height: parent.width*0.5
        source: helpImageSource
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.topMargin: parent.height*0.1
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label
    {
        id: helpLabel
        anchors.top: helpImage.bottom
        anchors.topMargin: parent.height*0.1
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Label.AlignHCenter
        text: helpText
        font.family: regularText.name
        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                    Vars.dpi)
        color: Vars.backgroundWhite
    }
}//helpCompItem
