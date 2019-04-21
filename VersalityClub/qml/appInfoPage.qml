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

//app information page
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
//import QtQuick.Controls.Styles 1.4

Page
{
    id: profileSettingsPage
    enabled: Vars.isConnected
    height: Vars.screenHeight
    width: Vars.screenWidth

    ToastMessage { id: toastMessage }

    //checking internet connetion
    Network { toastMessage: toastMessage }

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
        width: parent.width
        height: parent.height
        contentHeight: middleFieldsColumns.height*1.1
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.topMargin: Vars.screenHeight*0.30
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Vars.screenHeight*0.05

            Rectangle
            {
                id: textArea
                width: parent.width*0.9
                color: "transparent"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Vars.screenHeight*0.25

                Label
                {
                    id: appInfoMain
                    width: parent.width
                    text: 'Узнайте больше о Versality Club:<br><br>'+
                          '<a href="'+Vars.appSiteName+'"'
                          +' style="color: '+Vars.mainPurple+'">'
                          +Vars.appSiteName+'</a><br><br>' + Vars.appInfoText
                    font.pixelSize: Helper.toDp(13, Vars.dpi)
                    font.family: regularText.name
                    color: Vars.backgroundBlack
                    wrapMode: Label.WordWrap
                    onLinkActivated: Qt.openUrlExternally(link)
                    textFormat: Text.RichText;
                }
            }
        }//ColumnLayout
    }//Flickable

    Image
    {
        id: header
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/app_info_h.png"
    }

    LogoAndPageTitle
    {
        showInfoButton: true
        infoClicked: true
        pageTitleText: Vars.profileSettings
    }

    Component.onCompleted: profileSettingsPage.forceActiveFocus()

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
