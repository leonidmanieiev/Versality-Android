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

//user settings page
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Page
{
    id: profileSettingsPage
    enabled: Vars.isConnected
    height: Vars.screenHeight
    width: Vars.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    FontLoader
    {
        id: mediumText;
        source: "../fonts/Qanelas_Medium.ttf"
    }

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/settings_bg.png"
    }

    Flickable
    {
        id: flickableArea
        clip: true
        width: Vars.screenWidth
        height: Vars.screenHeight*0.65
        contentHeight: middleFieldsColumns.height*1.1
        anchors.centerIn: parent
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: Vars.screenWidth
            spacing: Vars.screenHeight*0.05

            CustomLabel
            {
                id: sexLabel
                labelText: Vars.sex
            }

            ControlButton
            {
                id: sexButton
                Layout.fillWidth: true
                buttonText: AppSettings.value("user/sex");
                labelContentColor: Vars.backgroundWhite
                backgroundColor: "transparent"
                setBorderColor: Vars.backgroundWhite
                onClicked:
                {
                    if(buttonText === "M")
                        buttonText = "Ж";
                    else buttonText = "M";

                    AppSettings.beginGroup("user");
                    AppSettings.setValue("sex", buttonText);
                    AppSettings.endGroup();
                }
            }

            CustomLabel
            {
                id: dateofbirthLabel
                labelText: Vars.birthday
            }

            CustomTextField
            {
                id: dateofbirthField
                setFillColor: "transparent"
                text: AppSettings.value("user/birthday");
                inputMask: Vars.birthdayMask
                inputMethodHints: Qt.ImhDigitsOnly
                onTextChanged:
                {
                    AppSettings.beginGroup("user");
                    AppSettings.setValue("birthday", text);
                    AppSettings.endGroup();
                }

                MouseArea
                {
                    id: clickableArea
                    anchors.fill: parent
                    onClicked:
                    {
                        //open picker and disable flicker
                        birthdayPicker.visible = true;
                        flickableArea.enabled = false;
                    }
                }
            }

            CustomLabel
            {
                id: emailLabel
                labelText: Vars.email
            }

            CustomTextField
            {
                id: emailField
                setFillColor: "transparent"
                text: AppSettings.value("user/email");
                inputMethodHints: Qt.ImhEmailCharactersOnly
                validator: RegExpValidator
                { regExp: Vars.emailRegEx }
            }

            CustomLabel
            {
                id: changePasswordLabel
                labelText: Vars.changePass
            }

            CustomTextField
            {
                id: changePasswordField
                setFillColor: "transparent"
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                selectByMouse: false
                placeholderText: Vars.enterNewPass
            }

            CustomLabel
            {
                id: firstNameLabel
                labelText: Vars.nameNotNecessary
            }

            CustomTextField
            {
                id: firstNameField
                setFillColor: "transparent"
                text: AppSettings.value("user/name");
                placeholderText: Vars.enterName
                onTextChanged:
                {
                    AppSettings.beginGroup("user");
                    AppSettings.setValue("name", text);
                    AppSettings.endGroup();
                }
            }

            CustomLabel
            {
                id: selectCategoryLabel
                labelText: Vars.chooseCats
            }

            ControlButton
            {
                id: selectCategoryButton
                Layout.fillWidth: true
                buttonText: Vars.choose
                labelContentColor: Vars.backgroundWhite
                backgroundColor: "transparent"
                setBorderColor: Vars.backgroundWhite
                onClicked:
                {
                    PageNameHolder.push("profileSettingsPage.qml");
                    profileSettingsPageLoader.setSource("xmlHttpRequest.qml",
                                                        { "api": Vars.allCats,
                                                          "functionalFlag": 'categories'
                                                        });
                }
            }//ControlButton
        }//ColumnLayout
    }//Flickable

    Image
    {
        id: header_footer
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/profile_settings_hf.png"
    }

    LogoAndPageTitle
    {
        pageTitleText: Vars.profileSettings
        pageTitleTopMargin: Vars.screenHeight*0.03
    }

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

            //close picker and enable flicker
            birthdayPicker.visible = false;
            flickableArea.enabled = true;
        }
    }

    RoundButton
    {
        id: saveButton
        height: Vars.screenHeight*0.09
        width: Vars.screenWidth*0.8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Vars.screenHeight*0.06
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: pressed ? Vars.defaultOpacity : 1
        onClicked:
        {
            AppSettings.beginGroup("user");
            AppSettings.setValue("sex", sexButton.buttonText);
            AppSettings.setValue("name", firstNameField.text);
            AppSettings.setValue("birthday", dateofbirthField.text);
            AppSettings.endGroup();

            profileSettingsPageLoader.setSource("xmlHttpRequest.qml",
                                                { "api": Vars.userInfo,
                                                  "functionalFlag": 'user/refresh-snb'
                                                });
        }

        contentItem: Text
        {
            text: Vars.save
            color: Vars.fontsPurple
            font.family: mediumText.name
            font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                        Vars.dpi)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle
        {
            implicitWidth: parent.width
            implicitHeight: parent.height
            border.color: Vars.fontsPurple
            border.width: height*0.06
            radius: Vars.listItemRadius
            color: "transparent"
        }
    }//RoundButton

    ToastMessage { id: toastMessage }

    Component.onCompleted: profileSettingsPage.forceActiveFocus()

    Keys.onReleased:
    {
        //back button pressed for android and windows
        if (event.key === Qt.Key_Back || event.key === Qt.Key_B)
        {
            event.accepted = true;

            if(birthdayPicker.visible === true)
            {
                birthdayPicker.visible = false;
                flickableArea.enabled = true;
            }
            else
            {
                var pageName = PageNameHolder.pop();

                //if no pages in sequence
                if(pageName === "")
                    appWindow.close();
                else profileSettingsPageLoader.source = pageName;
            }

            //to avoid not loading bug
            profileSettingsPageLoader.reload();
        }
    }

    Loader
    {
        id: profileSettingsPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready

        function reload()
        {
            var oldSource = source;
            source = "";
            source = oldSource;
        }
    }
}
