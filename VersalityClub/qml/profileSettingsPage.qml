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

    ScrollView
    {
        id: listView
        clip: true
        anchors.fill: parent
        ScrollBar.vertical: ScrollBar { visible: false }

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
                onClicked: buttonText === "М" ? buttonText = "Ж" : buttonText = "М"
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
                    profileSettingsPageLoader.setSource("xmlHttpRequest.qml",
                                                        { "serverUrl": 'http://patrick.ga:8080/api/categories',
                                                          "functionalFlag": 'categories'
                                                        });
                }
            }

            ControlButton
            {
                id: saveButton
                Layout.fillWidth: true
                padding: middleFieldsColumns.spacing * 2
                buttonText: qsTr("СОХРАНИТЬ")
                labelContentColor: Style.backgroundWhite
                backgroundColor: Style.mainPurple
                setBorderColor: Style.backgroundWhite
                onClicked:
                {

                    profileSettingsPageLoader.source = "mapPage.qml";
                }
            }
        }
    }

    Loader
    {
        id: profileSettingsPageLoader
        anchors.fill: parent
    }
}
