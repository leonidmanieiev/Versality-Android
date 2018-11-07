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
import QtQuick.Controls.Styles 1.4

Page
{
    id: signUpPage
    enabled: Style.isConnected
    height: Style.screenHeight
    width: Style.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    ColumnLayout
    {
        id: middleFieldsColumns
        width: parent.width*0.8
        anchors.centerIn: parent
        spacing: parent.height*0.05

        CustomLabel
        {
            id: sexLabel
            labelText: qsTr("Пол:")
            labelColor: Style.mainPurple
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

        CustomLabel
        {
            id: dateofbirthLabel
            labelText: qsTr("Дата рождения:")
            labelColor: Style.mainPurple
        }

        CustomTextField
        {
            id: dateofbirthField
            setTextColor: Style.backgroundBlack
            setFillColor: Style.backgroundWhite
            setBorderColor: Style.mainPurple
            inputMask: "00.00.0000"
            inputMethodHints: Qt.ImhDigitsOnly
        }

        CustomLabel
        {
            id: emailLabel
            labelText: qsTr("E-mail:")
            labelColor: Style.mainPurple
        }

        CustomTextField
        {
            id: emailField
            setFillColor: Style.backgroundWhite
            setBorderColor: Style.mainPurple
            setTextColor: Style.backgroundBlack
            placeholderText: "*****@****.**"
            inputMethodHints: Qt.ImhEmailCharactersOnly
            validator: RegExpValidator
            { regExp: Style.emailRegEx }
        }

        ControlButton
        {
            id: signUpButton
            Layout.fillWidth: true
            padding: middleFieldsColumns.spacing * 2
            buttonText: "ЗАРЕГИСТРИРОВАТЬСЯ"
            labelContentColor: Style.backgroundWhite
            backgroundColor: Style.mainPurple
            onClicked:
            {
                //check for valid inputs
                if(sexButton.buttonText === 'М/Ж')
                    sexButton.labelContentColor = Style.errorRed;
                else if(dateofbirthField.text === '..')
                    dateofbirthField.color = Style.errorRed;
                else if(emailField.acceptableInput === false)
                {
                    emailField.color = Style.errorRed;
                    emailField.text = "Некорректный E-mail";
                }
                else
                {
                    //saving user info for further using
                    AppSettings.beginGroup("user");
                    AppSettings.setValue("email", emailField.text.toLowerCase());
                    AppSettings.setValue("sex", sexButton.buttonText);
                    AppSettings.setValue("birthday", dateofbirthField.text);
                    AppSettings.endGroup();

                    signUpPageLoader.setSource("xmlHttpRequest.qml",
                                               { "serverUrl": 'http://patrick.ga:8082/api/register?',
                                                 "functionalFlag": 'register' });
                }
            }
        }//ControlButton
    }//ColumnLayout

    ToastMessage { id: toastMessage }

    Loader
    {
        id: signUpPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
