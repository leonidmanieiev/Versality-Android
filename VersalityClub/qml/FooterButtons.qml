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

//footer buttons
import "../"
import QtQuick 2.11
import QtQuick.Layouts 1.3
import Network 0.9

RowLayout
{
    property string pressedFromPageName: ''
    property double dummy_width: parent.width*0.3 / 2.0

    id: footerButtonsLayout
    width: parent.width
    height: Vars.footerButtonsFieldHeight
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    spacing: 0

    function showSubstrateForSettingsButton()
    {
        settingsButtonSubstrate.substrateSource  = "../icons/footer_button_substrate.svg";
        homeButtonSubstrate.substrateSource      = "../icons/dummy_footer_button_substrate.svg";
        favouriteButtonSubstrate.substrateSource = "../icons/dummy_footer_button_substrate.svg";
    }

    function showSubstrateForHomeButton()
    {
        settingsButtonSubstrate.substrateSource  = "../icons/dummy_footer_button_substrate.svg";
        homeButtonSubstrate.substrateSource      = "../icons/footer_button_substrate.svg";
        favouriteButtonSubstrate.substrateSource = "../icons/dummy_footer_button_substrate.svg";
    }

    function showSubstrateForFavouriteButton()
    {
        settingsButtonSubstrate.substrateSource  = "../icons/dummy_footer_button_substrate.svg";
        homeButtonSubstrate.substrateSource      = "../icons/dummy_footer_button_substrate.svg";
        favouriteButtonSubstrate.substrateSource = "../icons/footer_button_substrate.svg";
    }

    // instead of saveSelectedButton from selectCategoryPage
    function saveSelectedCategory(nextPageName)
    {
        PageNameHolder.pop();
        appWindowLoader.setSource("xmlHttpRequest.qml",
                                  { "api": Vars.userSelectCats,
                                    "functionalFlag": 'user/refresh-cats',
                                    "nextPageAfterCatsSave": nextPageName
                                  });
    }

    ToastMessage { id: toastMessage }

    Network { id: network }

    Rectangle
    {
        id: dummy1
        Layout.preferredWidth: Vars.screenWidth*0.1
        height: Vars.footerButtonsFieldHeight
        color: "transparent"
    }

    FooterButtonSubstrate
    {
        id: settingsButtonSubstrate
        Layout.fillWidth: true

        IconedButton
        {
            id: settingsButton
            width: parent.width*0.7
            height: parent.width*0.7
            anchors.centerIn: parent
            buttonIconSource: "../icons/settings.svg"
            clickArea.onClicked:
            {
                Qt.inputMethod.hide();
                showSubstrateForSettingsButton();

                // this points to parent of footer buttons
                if(parent.parent.parent.parent.shp.isPopupOpened){
                    parent.parent.parent.parent.shp.hide();
                } else {
                    parent.parent.parent.parent.shp.show();
                }

                /*PageNameHolder.push(pressedFromPageName);
                if(pressedFromPageName === 'selectCategoryPage.qml')
                {
                    saveSelectedCategory('profileSettingsPage.qml');
                }
                else if(pressedFromPageName === 'profileSettingsPage.qml')
                {
                    // this points to profileSettingsPage
                    parent.parent.parent.parent.saveProfileSettings('profileSettingsPage.qml');
                }
                else
                {
                    appWindowLoader.setSource("xmlHttpRequest.qml",
                                              { "api": Vars.userInfo,
                                                "functionalFlag": 'user'
                                              });
                }*/
            }
        }
    }

    Rectangle
    {
        id: dummy2
        Layout.preferredWidth: dummy_width
        height: Vars.footerButtonsFieldHeight
        color: "transparent"
    }

    FooterButtonSubstrate
    {
        id: homeButtonSubstrate
        Layout.fillWidth: true

        IconedButton
        {
            id: homeButton
            width: parent.width*0.7
            height: parent.width*0.7
            anchors.centerIn: parent
            buttonIconSource: "../icons/logo_white_fill.svg"
            //need to clear data for getting fresh one
            Component.onCompleted: Vars.allPromsData = '';
            clickArea.onClicked:
            {
                showSubstrateForHomeButton();

                if(pressedFromPageName === 'selectCategoryPage.qml')
                {
                    saveSelectedCategory('mapPage.qml');
                }
                else if(pressedFromPageName === 'profileSettingsPage.qml')
                {
                    // this points to profileSettingsPage
                    parent.parent.parent.parent.saveProfileSettings('mapPage.qml');
                }
                else
                {
                    appWindowLoader.setSource("mapPage.qml");
                }
            }
        }
    }

    Rectangle
    {
        id: dummy3
        Layout.preferredWidth: dummy_width
        height: Vars.footerButtonsFieldHeight
        color: "transparent"
    }

    FooterButtonSubstrate
    {
        id: favouriteButtonSubstrate
        Layout.fillWidth: true

        IconedButton
        {
            id: favouriteButton
            width: parent.width*0.7
            height: parent.width*0.7
            anchors.centerIn: parent
            buttonIconSource: "../icons/favourites.svg"
            clickArea.onClicked:
            {
                if(pressedFromPageName !== "favouritePage.qml")
                {
                    showSubstrateForFavouriteButton();
                    PageNameHolder.push(pressedFromPageName);
                }

                if(pressedFromPageName === 'selectCategoryPage.qml')
                {
                    saveSelectedCategory('favouritePage.qml');
                }
                else if(pressedFromPageName === 'profileSettingsPage.qml')
                {
                    // this points to profileSettingsPage
                    parent.parent.parent.parent.saveProfileSettings('favouritePage.qml');
                }
                else
                {
                    appWindowLoader.setSource("xmlHttpRequest.qml",
                                               { "api": Vars.userMarkedProms,
                                                 "functionalFlag": 'user/marked'
                                             });
                }
            }
        }
    }

    Rectangle
    {
        id: dummy4
        Layout.preferredWidth: Vars.screenWidth*0.1
        height: Vars.footerButtonsFieldHeight
        color: "transparent"
    }
}//footerButtonsLayout
