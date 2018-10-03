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
    id: profileSettingsPage
    height: Style.screenHeight
    width: Style.screenWidth

    background: Rectangle
    {
        id: background
        anchors.fill: parent
        color: Style.mainPurple
    }

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
            color: Style.backgroundWhite
        }

        ControlButton
        {
            id: sexButton
            Layout.fillWidth: true
            buttonText: UserSettings.value("user_sex")
            labelContentColor: Style.backgroundWhite
            backgroundColor: Style.mainPurple
            borderColor: Style.backgroundWhite
            onClicked: buttonText === "М" ? buttonText = "Ж" : buttonText = "М"
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
            color: Style.backgroundWhite
        }

        TextField
        {
            id: dateofbirthField
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            background: ControlBackground
            {
                fillColor: Style.mainPurple
                borderColor: Style.backgroundWhite
            }
            font.pixelSize: Helper.toDp(15, Style.dpi)
            color: Style.backgroundWhite
            inputMask: "00.00.0000"
            inputMethodHints: Qt.ImhDigitsOnly
            placeholderText: UserSettings.value("user_birthday")
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
            color: Style.backgroundWhite
        }

        EmailTextField
        {
            id: emailField
            Layout.alignment: Qt.AlignHCenter
            color: Style.backgroundWhite
            setFillColor: Style.mainPurple
            setBorderColor: Style.backgroundWhite
            placeholderText: UserSettings.value("user_email")
        }

        /*ControlButton
        {
            id: saveButton
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
                    signLogLoader.setSource("xmlHttpRequest.qml",
                                            { "serverUrl": 'http://patrick.ga:8080/api/register?',
                                              "email": emailField.text.toLowerCase(),
                                              "sex": sexButton.buttonText,
                                              "birthday": dateofbirthField.text,
                                              "functionalFlag": 'register' });
                }
            }//onClicked
        }//ControlButton*/
    }//ColumnLayout
}
