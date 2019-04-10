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

//logo and page title footer
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

RowLayout
{
    property string pageTitleText
    property real pageTitleLeftMargin: Vars.screenWidth*0.07

    id: logoAndPageTitle
    height: parent.height*0.15
    Layout.alignment: Qt.AlignCenter
    spacing: Vars.screenWidth*0.07

    Image
    {
        id: logo
        clip: true
        source: "../icons/logo_white_fill.png"
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: Vars.screenHeight*0.1
        Layout.leftMargin: Vars.screenWidth*0.09
        fillMode: Image.PreserveAspectFit
    }

    FontLoader
    {
        id: boldText;
        source: Vars.boldFont
    }

    Label
    {
        id: pageTitle
        text: pageTitleText
        color: Vars.backgroundWhite
        width: parent.width*0.3
        height: Vars.screenHeight*0.1
        Layout.leftMargin: -pageTitleLeftMargin
        font.family: boldText.name
        font.pixelSize: Helper.toDp(14, Vars.dpi)
    }
}
