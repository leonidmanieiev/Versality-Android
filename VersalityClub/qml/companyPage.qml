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

//company card page
import "../"
import Network 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4

Page
{
    id: companyPage
    enabled: Style.isConnected
    height: Style.pageHeight
    width: Style.screenWidth

    //checking internet connetion
    NetworkInfo
    {
        onNetworkStatusChanged:
        {
            if(accessible === 1)
            {
                Style.isConnected = true;
                companyPage.enabled = true;
                toastMessage.setTextAndRun(qsTr("Internet re-established"));
            }
            else
            {
                Style.isConnected = false;
                companyPage.enabled = false;
                toastMessage.setTextAndRun(qsTr("No Internet connection"));
            }
        }
    }

    background: Rectangle
    {
        id: pageBackground
        anchors.fill: parent
        color: Style.backgroundBlack
    }

    FooterButtons { pressedFromPageName: 'companyPage.qml' }

    ToastMessage { id: toastMessage }

    Component.onCompleted:
    {
        //setting active focus for key capturing
        companyPage.forceActiveFocus();

        console.log(AppSettings.value("promotion/company_id") + " | "
                    + AppSettings.value("promotion/company_name") + " | "
                    + AppSettings.value("promotion/company_logo"));
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
            else companyPageLoader.source = pageName;

            //to avoid not loading bug
            companyPageLoader.reload();
        }
    }

    Loader
    {
        id: companyPageLoader
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
