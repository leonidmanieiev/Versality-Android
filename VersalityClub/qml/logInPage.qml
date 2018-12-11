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

Page
{
    id: logInPage
    enabled: Vars.isConnected
    height: Vars.screenHeight
    width: Vars.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    ColumnLayout
    {
        id: middleLayout
        width: parent.width*0.8
        anchors.centerIn: parent
        spacing: parent.height*0.05

        CustomLabel
        {
            id: emailLabel
            labelText: Vars.email
            labelColor: Vars.mainPurple
        }

        CustomTextField
        {
            id: emailField
            placeholderText: Vars.emailPlaceHolder
            setFillColor: Vars.backgroundWhite
            setBorderColor: Vars.mainPurple
            setTextColor: Vars.backgroundBlack
            inputMethodHints: Qt.ImhEmailCharactersOnly
            validator: RegExpValidator
            { regExp: Vars.emailRegEx }
        }

        ControlButton
        {
            id: enterButton
            Layout.fillWidth: true
            padding: middleLayout.spacing*2
            labelContentColor: Vars.backgroundWhite
            backgroundColor: Vars.mainPurple
            buttonText: Vars.login
            onClicked:
            {
                //check for input corresponds to regex
                if(emailField.acceptableInput === false)
                {
                    emailField.color = Vars.errorRed;
                    emailField.text = Vars.incorrectEmail;
                }
                else
                {
                    AppSettings.beginGroup("user");
                    AppSettings.setValue("email", emailField.text.toLowerCase());
                    AppSettings.endGroup();

                    PageNameHolder.push("logInPage.qml");
                    logInPageLoader.source = "passwordInputPage.qml";
                }
            }
        }
    }//ColumnLayout

    ToastMessage { id: toastMessage }

    Loader
    {
        id: logInPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
