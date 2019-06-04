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

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/init_page_bg.png"
    }

    Image
    {
        id: header_logo_full
        clip: true
        source: "../icons/logo_full.svg"
        sourceSize.width: parent.width*0.40
        sourceSize.height: parent.width*0.08
        anchors.top: parent.top
        anchors.topMargin: parent.height*0.09
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    Image
    {
        id: footer_logo
        clip: true
        source: "../icons/logo.svg"
        sourceSize.width: parent.width*0.25
        sourceSize.height: parent.width*0.25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.08
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    ColumnLayout
    {
        id: middleLayout
        width: parent.width*0.8
        anchors.centerIn: parent
        spacing: parent.height*0.05

        CustomTextField
        {
            id: emailField
            Layout.fillWidth: true
            placeholderText: Vars.emailPlaceHolder
            placeholderTextColor: Vars.purpleTextColor
            setFillColor: Vars.whiteColor
            setBorderColor: Vars.purpleBorderColor
            setTextColor: Vars.purpleTextColor
            inputMethodHints: Qt.ImhEmailCharactersOnly
            validator: RegExpValidator
            { regExp: Vars.emailRegEx }

            onPressed:
            {
                if(color === Vars.errorRed)
                {
                    text = '';
                    color = Vars.purpleTextColor;
                }
            }
        }

        ControlButton
        {
            id: enterButton
            Layout.fillWidth: true
            labelColor: Vars.whiteColor
            backgroundColor: Vars.purpleBorderColor
            labelText: Vars.login
            buttonClickableArea.onClicked:
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
    }//middleLayout

    ToastMessage { id: toastMessage }

    Loader
    {
        id: logInPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
