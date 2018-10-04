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
    //those few become "not empty" after request
    property string email: ''
    property string sex: ''
    property string birthday: ''
    property string cats: ''

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
                buttonText: sex
                labelContentColor: Style.backgroundWhite
                backgroundColor: Style.mainPurple
                setBorderColor: Style.backgroundWhite
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
                text: birthday
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
                text: email
            }

            Label
            {
                id: changePasswordLabel
                clip: true
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Изменить пароль:")
                font.pixelSize: Helper.toDp(15, Style.dpi)
                color: Style.backgroundWhite
            }

            TextField
            {
                id: changePasswordField
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                background: ControlBackground
                {
                    fillColor: Style.mainPurple
                    borderColor: Style.backgroundWhite
                }
                font.pixelSize: Helper.toDp(15, Style.dpi)
                color: Style.backgroundWhite
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                selectByMouse: false
                placeholderText: qsTr("ВВЕДИТЕ НОВЫЙ ПАРОЛЬ")
            }

            Label
            {
                id: firstNameLabel
                clip: true
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Имя (не обязательно):")
                font.pixelSize: Helper.toDp(15, Style.dpi)
                color: Style.backgroundWhite
            }

            TextField
            {
                id: firstNameField
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                background: ControlBackground
                {
                    fillColor: Style.mainPurple
                    borderColor: Style.backgroundWhite
                }
                font.pixelSize: Helper.toDp(15, Style.dpi)
                color: Style.backgroundWhite
                placeholderText: qsTr("ВВЕДИТЕ ИМЯ")
            }

            Label
            {
                id: chooseCategoryLabel
                clip: true
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Выберите категории:")
                font.pixelSize: Helper.toDp(15, Style.dpi)
                color: Style.backgroundWhite
            }

            ControlButton
            {
                id: chooseCategoryButton
                Layout.fillWidth: true
                buttonText: qsTr("ВВЫБОР")
                labelContentColor: Style.backgroundWhite
                backgroundColor: Style.mainPurple
                setBorderColor: Style.backgroundWhite
                //onClicked: buttonText === "М" ? buttonText = "Ж" : buttonText = "М"
            }
        }
    }

    Loader
    {
        id: profileSettingsPageLoader
        anchors.fill: parent
    }
}
