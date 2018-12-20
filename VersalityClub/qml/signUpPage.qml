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
    enabled: Vars.isConnected
    height: Vars.screenHeight
    width: Vars.screenWidth

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/sign_up_bg.png"
    }

    LogoAndPageTitle { pageTitleText: Vars.signupNoun }

    //checking internet connetion
    Network { toastMessage: toastMessage }

    ColumnLayout
    {
        id: middleFieldsColumns
        width: parent.width*0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height*0.2
        spacing: parent.height*0.05

        FontLoader
        {
            id: mediumText;
            source: "../fonts/Qanelas_Medium.ttf"
        }

        CustomLabel
        {
            id: sexLabel
            labelText: Vars.sex
            labelColor: Vars.fontsPurple
        }

        ControlButton
        {
            id: sexButton
            Layout.fillWidth: true
            buttonText: Vars.m_f
            labelContentColor: Vars.backgroundBlack
            onClicked: buttonText === "М" ? buttonText = "Ж" : buttonText = "М"
            onFocusChanged:
            {
                //workaround to get default text color after incorrect input
                if(labelContentColor === Vars.errorRed)
                    labelContentColor = Vars.backgroundBlack;
            }
        }

        CustomLabel
        {
            id: dateofbirthLabel
            labelText: Vars.birthday
            labelColor: Vars.fontsPurple
        }

        CustomTextField
        {
            id: dateofbirthField
            setTextColor: Vars.backgroundBlack
            setFillColor: Vars.backgroundWhite
            setBorderColor: Vars.fontsPurple
            inputMask: Vars.birthdayMask
            inputMethodHints: Qt.ImhDigitsOnly

            MouseArea
            {
                id: clickableArea
                anchors.fill: parent
                onClicked: birthdayPicker.visible = true;
            }
        }

        CustomLabel
        {
            id: emailLabel
            labelText: Vars.email
            labelColor: Vars.fontsPurple
        }

        CustomTextField
        {
            id: emailField
            setFillColor: Vars.backgroundWhite
            setBorderColor: Vars.fontsPurple
            setTextColor: Vars.backgroundBlack
            placeholderText: Vars.emailPlaceHolder
            inputMethodHints: Qt.ImhEmailCharactersOnly
            validator: RegExpValidator
            { regExp: Vars.emailRegEx }
        }

        Button
        {
            id: signUpButton
            opacity: pressed ? Vars.defaultOpacity : 1
            Layout.fillWidth: true
            padding: middleFieldsColumns.spacing * 1.5
            background: Rectangle
            {
                clip: true
                radius: height*0.5
                anchors.centerIn: parent
                /*swaped geometry and rotation is a trick for
                left to right gradient*/
                height: Vars.screenWidth*0.8
                width: Vars.screenHeight*0.09
                rotation: -90
                gradient: Gradient
                {
                    GradientStop { position: 0.0; color: "#390d5e" }
                    GradientStop { position: 1.0; color: "#952e74" }
                }
            }
            contentItem: Text
            {
                id: labelContent
                text: Vars.signup
                font.family: mediumText.name
                font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                            Vars.dpi)
                color: Vars.backgroundWhite
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            onClicked:
            {
                //check for valid inputs
                if(sexButton.buttonText === Vars.m_f)
                    sexButton.labelContentColor = Vars.errorRed;
                else if(dateofbirthField.text === '..')
                    dateofbirthField.color = Vars.errorRed;
                else if(emailField.acceptableInput === false)
                {
                    emailField.color = Vars.errorRed;
                    emailField.text = Vars.incorrectEmail;
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
                                               { "api": Vars.userSignup,
                                                 "functionalFlag": 'register' });
                }
            }
        }//signUpButton
    }//ColumnLayout

    ScrollDatePicker
    {
        id: birthdayPicker
        visible: false
        anchors.centerIn: parent

        doneButton.onClicked:
        {
            //show date
            dateofbirthField.text = selectedDay+selectedMonth+selectedYear;

            //save date fo futher usage
            AppSettings.beginGroup("user");
            AppSettings.setValue("birthday", dateofbirthField.text);
            AppSettings.endGroup();

            birthdayPicker.visible = false;
        }
    }

    ToastMessage { id: toastMessage }

    Loader
    {
        id: signUpPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
