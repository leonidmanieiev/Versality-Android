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
import QtQuick.Layouts 1.3
import "../js/toDipConverter.js" as Covert

Rectangle
{
    id: initialPage
    height: Style.screenHeight
    width: Style.screenWidth

    /*BezierCurve
    {
        id: headerCanvas
        w: parent.width
        h: parent.height
        sY: 0
        eY: 0
        cp2x: 200
        cp2y: 150
    }*/

    ColumnLayout
    {
        id: middleButtonsRow
        spacing: Covert.toDp(Style.screenWidth*0.045, Style.dpi)
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        ControlButton
        {
            id: signUpButton
            Layout.fillWidth: true
            buttonText: "ЗАРЕГИСТРИРОВАТЬСЯ"
            onClicked: console.log("singUpButton clicked")
        }

        ControlButton
        {
            id: logInButton
            Layout.fillWidth: true
            buttonText: "ВОЙТИ"
            onClicked: console.log("logInButton clicked")
        }
    }

    /*BezierCurve
    {
        id: footerCanvas
        w: parent.width
        h: parent.height
    }*/
}
