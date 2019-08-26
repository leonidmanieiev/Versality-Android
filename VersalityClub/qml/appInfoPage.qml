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

//app information page
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page
{
    property var appInfoText
    property string pressedFrom: 'appInfoPage.qml'
    //alias
    property alias shp: settingsHelperPopup
    property alias fb: footerButton

    function getAppInfoText()
    {
        var request = new XMLHttpRequest()
        request.open('GET', '../text/appInfoText.txt')
        request.onreadystatechange = function(event) {
            if (request.readyState === XMLHttpRequest.DONE)
                appInfoText = request.responseText;
        }
        request.send()
    }

    id: profileSettingsPage
    enabled: Vars.isConnected
    height: Vars.pageHeight
    width: Vars.screenWidth

    ToastMessage { id: toastMessage }

    FontLoader
    {
        id: regularText;
        source: Vars.regularFont
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
        width: parent.width*0.9
        height: parent.height
        anchors.top: parent.top
        topMargin: Vars.pageHeight*0.25
        bottomMargin: Vars.footerButtonsFieldHeight*1.05
        anchors.horizontalCenter: parent.horizontalCenter
        boundsBehavior: Flickable.DragOverBounds
        flickableDirection: Flickable.VerticalFlick

        TextArea.flickable: TextArea {
            readOnly: true
            text: 'Узнайте больше о Versality:<br><br>'+
                  '<a href="'+Vars.appSiteLink+'"'
                  +' style="color: #631964">'
                  +Vars.appSiteName+'</a><br><br>' + appInfoText
                  +'<br><br><a href="'+Vars.privacyPolicyLink+'"'
                  +' style="color: #631964">'
                  +'Политика конфиденциальности</a>'
            font.pixelSize: Helper.applyDpr(7, Vars.dpr)
            font.family: regularText.name
            color: Vars.blackColor
            wrapMode: Label.WordWrap
            onLinkActivated: Qt.openUrlExternally(link)
            textFormat: Text.RichText;
        }
    }//flickableArea

    Image
    {
        id: header
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/profile_settings_h.png"
    }

    LogoAndPageTitle
    {
        //showInfoButton: true
        //infoClicked: true
        pageTitleText: Vars.profileSettings
    }

    Component.onCompleted:
    {
        getAppInfoText();
        profileSettingsPage.forceActiveFocus();
    }

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

            var pageName = PageNameHolder.pop();

            //if no pages in sequence
            if(pageName === "")
                appWindow.close();
            else appWindowLoader.source = pageName;
        }
    }
}
