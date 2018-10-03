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
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page
{
    id: logInPage
    height: Style.screenHeight
    width: Style.screenWidth

    ColumnLayout
    {
        id: middleLayout
        width: parent.width*0.8
        anchors.centerIn: parent
        spacing: parent.height*0.05

        Label
        {
            id: emailLabel
            clip: true
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("E-mail:")
            font.pixelSize: Helper.toDp(15, Style.dpi)
            color: Style.mainPurple
        }

        EmailTextField
        {
            id: emailField
            Layout.alignment: Qt.AlignHCenter
        }

        ControlButton
        {
            id: enterButton
            padding: middleLayout.spacing
            Layout.fillWidth: true
            buttonText: "ВОЙТИ"
            labelContentColor: Style.backgroundWhite
            backgroundColor: Style.mainPurple
            onClicked:
            {
                //check for input corresponds to regex
                if(emailField.acceptableInput === false)
                {
                    emailField.color = Style.errorRed;
                    emailField.text = "Некорректный e-mail";
                }
                else
                {
                    signLogLoader.setSource("passwordInputPage.qml",
                                             { "email": emailField.text.toLowerCase()});
                }
            }
        }
    }
}
