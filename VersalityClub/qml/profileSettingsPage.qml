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

    Flickable
    {
        id: flickableArea
        clip: true
        anchors.centerIn: parent
        width: Style.screenWidth
        height: Style.screenHeight*0.6
        boundsBehavior: Flickable.DragOverBounds
        contentHeight: middleFieldsColumns.height*1.05

        ColumnLayout
        {
            id: middleFieldsColumns
            width: Style.screenWidth
            spacing: Style.screenHeight*0.05

            CustomLabel
            {
                id: sexLabel
                labelText: qsTr("Пол:")
            }

            ControlButton
            {
                id: sexButton
                Layout.fillWidth: true
                buttonText: UserSettings.value("user_data/sex");
                labelContentColor: Style.backgroundWhite
                backgroundColor: Style.mainPurple
                setBorderColor: Style.backgroundWhite
                onClicked: buttonText === "M" ? buttonText = "Ж" : buttonText = "M"
            }

            CustomLabel
            {
                id: dateofbirthLabel
                labelText: qsTr("Дата рождения:")
            }

            CustomTextField
            {
                id: dateofbirthField
                inputMask: "00.00.0000"
                inputMethodHints: Qt.ImhDigitsOnly
                text: UserSettings.value("user_data/birthday");
            }

            CustomLabel
            {
                id: emailLabel
                labelText: qsTr("E-mail:")
            }

            CustomTextField
            {
                id: emailField
                text: UserSettings.value("user_data/email");
                inputMethodHints: Qt.ImhEmailCharactersOnly
                validator: RegExpValidator
                { regExp: Style.emailRegEx }
            }

            CustomLabel
            {
                id: changePasswordLabel
                labelText: qsTr("Изменить пароль:")
            }

            CustomTextField
            {
                id: changePasswordField
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                selectByMouse: false
                placeholderText: qsTr("ВВЕДИТЕ НОВЫЙ ПАРОЛЬ")
            }

            CustomLabel
            {
                id: firstNameLabel
                labelText: qsTr("Имя (не обязательно):")
            }

            CustomTextField
            {
                id: firstNameField
                text: UserSettings.value("user_data/name");
                placeholderText: qsTr("ВВЕДИТЕ ИМЯ")
            }

            CustomLabel
            {
                id: selectCategoryLabel
                labelText: qsTr("Выберите категории:")
            }

            ControlButton
            {
                id: selectCategoryButton
                Layout.fillWidth: true
                buttonText: qsTr("ВВЫБОР")
                labelContentColor: Style.backgroundWhite
                backgroundColor: Style.mainPurple
                setBorderColor: Style.backgroundWhite
                onClicked:
                {
                    PageNameHolder.push("profileSettingsPage.qml");
                    profileSettingsPageLoader.setSource("xmlHttpRequest.qml",
                                                        { "serverUrl": 'http://patrick.ga:8080/api/categories',
                                                          "functionalFlag": 'categories'
                                                        });
                }
            }

        }
    }

    Rectangle
    {
        //temporary background
        id: backOfButton
        width: parent.width
        height: Style.screenHeight*0.2
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: Style.backgroundWhite

        RoundButton
        {
            id: mainButton
            height: Style.screenHeight*0.09
            width: Style.screenWidth*0.8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Style.screenHeight*0.08
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: pressed ? 0.8 : 1
            onClicked:
            {
                chooseCategoryPageLoader.setSource("xmlHttpRequest.qml",
                                                              { "serverUrl": 'http://patrick.ga:8080/api/user?',
                                                                "functionalFlag": 'user/refresh-snb',
                                                                "sex": sexButton.buttonText,
                                                                "name": firstNameField.text,
                                                                "birthday": dateofbirthField.text
                                                              });
            }

            contentItem: Text
            {
                text: qsTr("СОХРАНИТЬ")
                color: Style.mainPurple
                font.pixelSize: Helper.toDp(15, Style.dpi)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle
            {
                implicitWidth: parent.width
                implicitHeight: parent.height
                border.color: Style.mainPurple
                border.width: height*0.06
                radius: Style.listItemRadius
            }
        }
    }


    Loader
    {
        id: profileSettingsPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
