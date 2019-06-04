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

RowLayout
{
    property string currPageName: ''
    property string compInfoButtonIcon: ''
    property string compMapButtonIcon: ''
    property string compListButtonIcon: ''

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
    width: parent.width
    height: Vars.footerButtonsFieldHeight
    anchors.top: parent.top

    IconedButton
    {
        id: backButton
        width: Vars.headerButtonsHeight
        height: Vars.headerButtonsHeight
        Layout.alignment: Qt.AlignHCenter
        buttonIconSource: "../icons/comp_back.svg"
        clickArea.onClicked:
        {
            PageNameHolder.pop();
            //to avoid not loading bug
            appWindowLoader.source = "";
            appWindowLoader.source = "promotionPage.qml";
        }
    }

    IconedButton
    {
        id: compInfoButton
        width: Vars.headerButtonsHeight
        height: Vars.headerButtonsHeight
        Layout.alignment: Qt.AlignHCenter
        buttonIconSource: compInfoButtonIcon
        clickArea.onClicked:
        {
            if(currPageName != "companyPage.qml")
            {
                currPageName = "companyPage.qml";
                parent.parent.comp_loader.setSource(currPageName);
                setButtonsStates();
            }
        }
    }

    IconedButton
    {
        id: compMapButton
        width: Vars.headerButtonsHeight
        height: Vars.headerButtonsHeight
        Layout.alignment: Qt.AlignHCenter
        buttonIconSource: compMapButtonIcon
        clickArea.onClicked:
        {
            if(currPageName != "companyMapPage.qml")
            {
                currPageName = "companyMapPage.qml";
                parent.parent.comp_loader.setSource("mapPage.qml",
                    {"allGood": true, "requestFromCompany": true});
                setButtonsStates();
            }
        }
    }

    IconedButton
    {
        id: compListButton
        width: Vars.headerButtonsHeight
        height: Vars.headerButtonsHeight
        Layout.alignment: Qt.AlignHCenter
        buttonIconSource: compListButtonIcon
        clickArea.onClicked:
        {
            if(currPageName != "companyListPage.qml")
            {
                currPageName = "companyListPage.qml";
                parent.parent.comp_loader.setSource("listViewPage.qml",
                    {"allGood": true, "requestFromCompany": true});
                setButtonsStates();
            }
        }
    }

    Component.onCompleted:
    {
        currPageName = "companyPage.qml";
        setButtonsStates();
    }

}//headerButtonsLayout
