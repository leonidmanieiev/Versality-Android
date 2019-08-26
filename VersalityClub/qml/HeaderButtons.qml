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

//company page header buttons
import "../"
import QtQuick 2.11
import QtQuick.Layouts 1.3
import Network 0.9
import QtQuick.Controls 2.5

RowLayout
{
    property string currPageName: ''
    property string compInfoButtonIcon: ''
    property string compMapButtonIcon: ''
    property string compListButtonIcon: ''
    property double dummy_width: (parent.width*0.8 - Vars.headerButtonsHeight*4) / 3
    property Loader companyLoader: undefined
    property Popup gallery: undefined
    property bool isGalleryVisible: gallery.visible

    //set buttons states depand on currPageName
    function setButtonsStates()
    {
        switch(currPageName)
        {
            case "companyPage.qml":
                compInfoButtonIcon = "../icons/comp_info_on.svg";
                compMapButtonIcon = "../icons/comp_proms_map_off.svg";
                compListButtonIcon = "../icons/comp_proms_list_off.svg";
                break;
            case "companyMapPage.qml":
                compInfoButtonIcon = "../icons/comp_info_off.svg";
                compMapButtonIcon = "../icons/comp_proms_map_on.svg";
                compListButtonIcon = "../icons/comp_proms_list_off.svg";
                break;
            case "companyListPage.qml":
                compInfoButtonIcon = "../icons/comp_info_off.svg";
                compMapButtonIcon = "../icons/comp_proms_map_off.svg";
                compListButtonIcon = "../icons/comp_proms_list_on.svg";
                break;
        }
    }

    id: headerButtonsLayout
    width: parent.width*0.8
    height: Vars.footerButtonsFieldHeight*1.2
    anchors.top: parent.top
    anchors.left: parent.left
    spacing: 0

    ToastMessage { id: toastMessage }

    Network { id: network }

    Rectangle
    {
        id: dummy1
        Layout.preferredWidth: Vars.screenWidth*0.1
        height: Vars.headerButtonsHeight
        color: "transparent"
    }

    IconedButton
    {
        id: backButton
        Layout.fillWidth: true
        height: Vars.headerButtonsHeight
        buttonIconSource: "../icons/comp_back.svg"
        clickArea.onClicked:
        {
            if(isGalleryVisible)
            {
                gallery.close();
            }
            else if(network.hasConnection())
            {
                toastMessage.close();
                PageNameHolder.pop();
                //to avoid not loading bug
                appWindowLoader.source = "";
                appWindowLoader.source = "promotionPage.qml";
            }
            else
            {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }
    }

    Rectangle
    {
        id: dummy2
        Layout.preferredWidth: dummy_width
        height: Vars.headerButtonsHeight
        color: "transparent"
    }

    IconedButton
    {
        id: compInfoButton
        Layout.fillWidth: true
        height: Vars.headerButtonsHeight
        buttonIconSource: compInfoButtonIcon
        clickArea.onClicked:
        {
            if(network.hasConnection())
            {
                toastMessage.close();
                currPageName = "companyPage.qml";
                setButtonsStates();
                gallery.close();
                companyLoader.setSource(currPageName);
            }
            else
            {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }
    }

    Rectangle
    {
        id: dummy3
        Layout.preferredWidth: dummy_width
        height: Vars.headerButtonsHeight
        color: "transparent"
    }

    IconedButton
    {
        id: compMapButton
        Layout.fillWidth: true
        height: Vars.headerButtonsHeight
        buttonIconSource: compMapButtonIcon
        clickArea.onClicked:
        {
            if(network.hasConnection())
            {
                toastMessage.close();
                currPageName = "companyMapPage.qml";
                setButtonsStates();
                gallery.close();
                companyLoader.setSource("mapPage.qml",
                    {"allGood": true, "requestFromCompany": true});
            }
            else
            {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }
    }

    Rectangle
    {
        id: dummy4
        Layout.preferredWidth: dummy_width
        height: Vars.headerButtonsHeight
        color: "transparent"
    }

    IconedButton
    {
        id: compListButton
        Layout.fillWidth: true
        height: Vars.headerButtonsHeight
        buttonIconSource: compListButtonIcon
        clickArea.onClicked:
        {
            if(network.hasConnection())
            {
                toastMessage.close();
                currPageName = "companyListPage.qml";
                setButtonsStates();
                gallery.close();
                companyLoader.setSource("listViewPage.qml",
                    {"allGood": true, "requestFromCompany": true});
            }
            else
            {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }
    }

    Rectangle
    {
        id: dummy5
        Layout.preferredWidth: Vars.screenWidth*0.1
        height: Vars.headerButtonsHeight
        color: "transparent"
    }

    Component.onCompleted:
    {
        currPageName = "companyPage.qml";
        setButtonsStates();
    }

}//headerButtonsLayout
