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

//user settings page
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Network 0.9

Page
{
    property bool hasPassChanged: false
    property string pressedFrom: 'profileSettingsPage.qml'
    //alias
    property alias loader: profileSettingsPageLoader
    property alias shp: settingsHelperPopup
    property alias fb: footerButton

    id: profileSettingsPage
    enabled: Vars.isConnected
    height: Vars.pageHeight
    width: Vars.screenWidth

    // instead of saveButton
    function saveProfileSettings(nextPageName)
    {
        // close keyboard
        Qt.inputMethod.hide();
        // pop current page, because next one will be different
        PageNameHolder.pop();

        AppSettings.beginGroup("user");
        AppSettings.setValue("sex", sexButton.labelText);
        if(firstNameField.text.length > 0)
        {
            AppSettings.setValue("name", firstNameField.text);
        }
        AppSettings.setValue("birthday", dateofbirthField.text);
        if(changePasswordField.text.length > 0)
        {
            AppSettings.setValue("password", changePasswordField.text);
            hasPassChanged = true;
        }
        AppSettings.endGroup();

        profileSettingsPageLoader.setSource("xmlHttpRequest.qml",
                                            {
                                                "api": Vars.userInfo,
                                                "functionalFlag": 'user/refresh-snbp',
                                                "hasPassChanged": hasPassChanged,
                                                "nextPageAfterSettingsSave": nextPageName
                                            });
    }

    ToastMessage { id: toastMessage }

    //checking internet connetion
    Network { id: network }

    FontLoader
    {
        id: mediumText;
        source: Vars.mediumFont
    }

    FontLoader
    {
        id: boldText;
        source: Vars.boldFont
    }

    Flickable
    {
        id: flickableArea
        clip: true
        width: parent.width
        height: parent.height
        contentHeight: middleFieldsColumns.height
        anchors.top: parent.top
        topMargin: Vars.pageHeight*0.25
        bottomMargin: Vars.footerButtonsFieldHeight*1.05
        anchors.horizontalCenter: parent.horizontalCenter
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width*0.8
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Vars.screenHeight*0.05

            /*CustomLabel
            {
                id: selectCategoryLabel
                labelText: Vars.chooseCats
                labelColor: Vars.blackColor
            }

            ControlButton
            {
                id: selectCategoryButton
                Layout.fillWidth: true
                Layout.topMargin: -Vars.pageHeight*0.02
                labelText: Vars.choose
                labelColor: Vars.blackColor
                backgroundColor: "transparent"
                borderColor: Vars.settingsPurpleBorderColor
                buttonClickableArea.onClicked:
                {
                    PageNameHolder.push(pressedFrom);
                    profileSettingsPageLoader.setSource("xmlHttpRequest.qml",
                                                        { "api": Vars.allCats,
                                                          "functionalFlag": 'categories'
                                                        });
                }
            }//selectCategoryButton*/

            CustomLabel
            {
                id: sexLabel
                labelText: Vars.sex
                labelColor: Vars.blackColor
                Layout.topMargin: -Vars.pageHeight*0.02
            }

            ControlButton
            {
                id: sexButton
                Layout.fillWidth: true
                Layout.topMargin: -Vars.pageHeight*0.02
                labelText: AppSettings.value("user/sex");
                labelColor: Vars.blackColor
                backgroundColor: "transparent"
                borderColor: Vars.settingsPurpleBorderColor
                buttonClickableArea.onClicked:
                {
                    if(labelText === "M")
                        labelText = "Ж";
                    else labelText = "M";

                    AppSettings.beginGroup("user");
                    AppSettings.setValue("sex", labelText);
                    AppSettings.endGroup();
                }
            }

            CustomLabel
            {
                id: dateofbirthLabel
                labelColor: Vars.blackColor
                labelText: Vars.birthday
                Layout.topMargin: -Vars.pageHeight*0.02
            }

            CustomTextField
            {
                id: dateofbirthField
                Layout.fillWidth: true
                setFillColor: "transparent"
                setTextColor: Vars.blackColor
                setBorderColor: Vars.settingsPurpleBorderColor
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
                labelColor: Vars.blackColor
            }

            CustomTextField
            {
                id: emailField
                readOnly: true
                Layout.fillWidth: true
                setFillColor: "transparent"
                setTextColor: Vars.blackColor
                setBorderColor: Vars.settingsPurpleBorderColor
                text: AppSettings.value("user/email");
            }

            CustomLabel
            {
                id: changePasswordLabel
                labelText: Vars.changePass
                labelColor: Vars.blackColor
            }

            CustomTextField
            {
                id: changePasswordField
                Layout.fillWidth: true
                setFillColor: "transparent"
                setTextColor: Vars.blackColor
                setBorderColor: Vars.settingsPurpleBorderColor
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                selectByMouse: false
                placeholderText: Vars.enterNewPass
            }

            CustomLabel
            {
                id: firstNameLabel
                labelText: Vars.nameNotNecessary
                labelColor: Vars.blackColor
            }

            CustomTextField
            {
                id: firstNameField
                Layout.fillWidth: true
                setFillColor: "transparent"
                setTextColor: Vars.blackColor
                setBorderColor: Vars.settingsPurpleBorderColor
                text: AppSettings.value("user/name");
                placeholderText: Vars.enterName
                onTextChanged:
                {
                    AppSettings.beginGroup("user");
                    AppSettings.setValue("name", text);
                    AppSettings.endGroup();
                }
            }

            Rectangle
            {
                id: dummy
                Layout.fillWidth: true
                height: Vars.headerButtonsHeight*0.6
                color: "transparent"
            }

            /*ControlButton
            {
                id: saveButton
                labelText: Vars.save;
                labelColor: Vars.whiteColor
                labelAlias.font.family: boldText.name
                labelAlias.font.bold: true
                fontPixelSize: Helper.applyDpr(10, Vars.dpr)
                Layout.fillWidth: true
                Layout.topMargin: Vars.pageHeight*0.03
                backgroundColor: Vars.insteadOfGradientColor
                borderColor: Vars.insteadOfGradientColor
                buttonRadius: 25
                buttonWidth: Vars.screenWidth*0.9

                buttonClickableArea.onClicked:
                {
                    AppSettings.beginGroup("user");
                    AppSettings.setValue("sex", sexButton.labelText);
                    if(firstNameField.text.length > 0)
                    {
                        AppSettings.setValue("name", firstNameField.text);
                    }
                    AppSettings.setValue("birthday", dateofbirthField.text);
                    if(changePasswordField.text.length > 0)
                    {
                        AppSettings.setValue("password", changePasswordField.text);
                        hasPassChanged = true;
                    }
                    AppSettings.endGroup();
                    profileSettingsPageLoader.setSource("xmlHttpRequest.qml",
                                                        { "api": Vars.userInfo,
                                                          "functionalFlag": 'user/refresh-snbp',
                                                          "hasPassChanged": hasPassChanged
                                                        });
                }
            }//saveButton

            ControlButton
            {
                id: logoutButton
                labelText: Vars.logout
                labelColor: Vars.whiteColor
                labelAlias.font.family: boldText.name
                labelAlias.font.bold: true
                fontPixelSize: Helper.applyDpr(10, Vars.dpr)
                Layout.topMargin: -Vars.pageHeight*0.03
                Layout.fillWidth: true
                backgroundColor: Vars.blackColor
                borderColor: Vars.blackColor
                buttonRadius: 25
                buttonClickableArea.onClicked:
                {
                    if(network.hasConnection()) {
                        toastMessage.close();
                        AppSettings.clearAllAppSettings();
                        appWindowLoader.source = "initialPage.qml";
                    } else {
                        toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
                    }
                }
            }*/
        }//middleFieldsColumns
    }//flickableArea

    Image
    {
        id: backgroundHeader
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/profile_settings_h.png"
    }

    // this thing does not allow to select/deselect subcat,
    // when it is under the header
    Rectangle
    {
        id: headerStoper
        width: parent.width
        height: logoAndPageTitle.height*1.2
        anchors.top: parent.top
        color: "transparent"

        MouseArea
        {
            anchors.fill: parent
            onClicked: headerStoper.forceActiveFocus()
        }
    }

    LogoAndPageTitle
    {
        id: logoAndPageTitle
        pageTitleText: Vars.profileSettings
        pressedFromPageName: pressedFrom
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

    Component.onCompleted: profileSettingsPage.forceActiveFocus()

    // this thing does not allow to select/deselect subcat,
    // when it is under the settingsHelperPopup
    Rectangle
    {
        id: settingsHelperPopupStopper
        enabled: settingsHelperPopup.isPopupOpened
        width: parent.width
        height: settingsHelperPopup.height
        anchors.bottom: footerButton.top
        color: "transparent"

        MouseArea
        {
            anchors.fill: parent
            onClicked: settingsHelperPopupStopper.forceActiveFocus()
        }
    }

    SettingsHelperPopup
    {
        id: settingsHelperPopup
        currentPage: pressedFrom
        parentHeight: parent.height
    }

    Image
    {
        id: backgroundFooter
        clip: true
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        anchors.bottom: parent.bottom
        source: "../backgrounds/map_f.png"
    }

    // this thing does not allow to select/deselect subcat,
    // when it is under the footer
    Rectangle
    {
        id: footerStopper
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        anchors.bottom: parent.bottom
        color: "transparent"

        MouseArea
        {
            anchors.fill: parent
            onClicked: footerStopper.forceActiveFocus()
        }
    }

    FooterButtons
    {
        id: footerButton
        pressedFromPageName: pressedFrom
        Component.onCompleted: showSubstrateForSettingsButton()
    }

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
