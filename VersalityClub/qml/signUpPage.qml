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
import QtQuick.Controls.Styles 1.4

Page
{
    id: signUpPage
    height: Style.screenHeight
    width: Style.screenWidth

    ColumnLayout
    {
        id: middleFieldsColumns
        width: parent.width*0.8
        anchors.centerIn: parent
        spacing: parent.height*0.05

        Label
        {
            id: sexLabel
            clip: true
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Пол:")
            font.pixelSize: Helper.toDp(15, Style.dpi)
            color: Style.mainPurple
        }

        ControlButton
        {
            id: sexButton
            Layout.fillWidth: true
            buttonText: qsTr("М/Ж")
            labelContentColor: Style.backgroundBlack
            onClicked: buttonText === "М" ? buttonText = "Ж" : buttonText = "М"
            onFocusChanged:
            {
                //workaround to get default text color after incorrect input
                if(labelContentColor === Style.errorRed)
                    labelContentColor = Style.backgroundBlack;
            }
        }

        Label
        {
            id: dateofbirthLabel
            clip: true
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Дата рождения:")
            font.pixelSize: Helper.toDp(15, Style.dpi)
            color: Style.mainPurple
        }

        TextField
        {
            id: dateofbirthField
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            background: ControlBackground { }
            font.pixelSize: Helper.toDp(15, Style.dpi)
            color: Style.backgroundBlack
            inputMask: "00.00.0000"
            inputMethodHints: Qt.ImhDigitsOnly
            onFocusChanged:
            {
                //workaround to get default text color after incorrect input
                if(color === Style.errorRed)
                {
                    color = Style.backgroundBlack;
                    text = ''
                }
            }
        }

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
            id: signUpButton
            Layout.fillWidth: true
            padding: Style.screenHeight * 0.08
            buttonText: "ЗАРЕГИСТРИРОВАТЬСЯ"
            labelContentColor: Style.backgroundWhite
            backgroundColor: Style.mainPurple
            onClicked:
            {
                if(sexButton.text === 'М/Ж')
                {
                    sexButton.labelContentColor = Style.errorRed;
                }
                else if(dateofbirthField.text === '..')
                {
                    dateofbirthField.color = Style.errorRed;
                    dateofbirthField.text = "Некорректная дата";
                }
                //check for input corresponds to regex
                else if(emailField.acceptableInput === false)
                {
                    emailField.color = Style.errorRed;
                    emailField.text = "Некорректный E-mail";
                }
                else
                {
                    signUpPageLoader.setSource("xmlHttpRequest.qml",
                                               { "serverUrl": 'http://patrick.ga:8080/api/register?',
                                                 "email": emailField.text.toLowerCase(),
                                                 "sex": sexButton.buttonText,
                                                 "birthday": dateofbirthField.text,
                                                 "functionalFlag": 'register' });
                }
            }//onClicked
        }//ControlButton
    }//ColumnLayout

    Loader
    {
        id: signUpPageLoader
        anchors.fill: parent
    }
}//Page
