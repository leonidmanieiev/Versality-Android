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

RowLayout
{
    property string pressedFromPageName: ''

    id: footerButtonsLayout
    width: parent.width
    height: Vars.footerButtonsFieldHeight
    anchors.bottom: parent.bottom

    function showSubstrateForSettingsButton()
    {
        settingsButtonSubstrate.visible = true;
        homeButtonSubstrate.visible = false;
        favouriteButtonSubstrate.visible = false;
    }

    function showSubstrateForHomeButton()
    {
        settingsButtonSubstrate.visible = false;
        homeButtonSubstrate.visible = true;
        favouriteButtonSubstrate.visible = false;
    }

    function showSubstrateForFavouriteButton()
    {
        settingsButtonSubstrate.visible = false;
        homeButtonSubstrate.visible = false;
        favouriteButtonSubstrate.visible = true;
    }

    function disableAllButtonsSubstrates()
    {
        settingsButtonSubstrate.visible = false;
        homeButtonSubstrate.visible = false;
        favouriteButtonSubstrate.visible = false;
    }

    IconedButton
    {
        id: settingsButton
        width: Vars.footerButtonsHeight
        height: Vars.footerButtonsHeight
        Layout.alignment: Qt.AlignHCenter
        buttonIconSource: "../icons/settings.png"
        clickArea.onClicked:
        {
            showSubstrateForSettingsButton();
            PageNameHolder.push(pressedFromPageName);
            appWindowLoader.setSource("xmlHttpRequest.qml",
                                      { "api": Vars.userInfo,
                                        "functionalFlag": 'user'
                                      });
        }

        FooterButtonSubstrate { id: settingsButtonSubstrate }
    }

    IconedButton
    {
        id: homeButton
        width: Vars.footerButtonsHeight
        height: Vars.footerButtonsHeight
        Layout.alignment: Qt.AlignHCenter
        buttonIconSource: "../icons/home.png"
        clickArea.onClicked:
        {
            showSubstrateForHomeButton();
            appWindowLoader.setSource("mapPage.qml");
        }
        //need to clear data for getting fresh one
        Component.onCompleted: Vars.allPromsData = '';

        FooterButtonSubstrate { id: homeButtonSubstrate }
    }

    IconedButton
    {
        id: favouriteButton
        width: Vars.footerButtonsHeight
        height: Vars.footerButtonsHeight
        Layout.alignment: Qt.AlignHCenter
        buttonIconSource: "../icons/favourites.png"
        clickArea.onClicked:
        {
            if(pressedFromPageName !== "favouritePage.qml")
                PageNameHolder.push(pressedFromPageName);

            appWindowLoader.setSource("xmlHttpRequest.qml",
                                       { "api": Vars.userMarkedProms,
                                         "functionalFlag": 'user/marked'
                                     });
        }

        FooterButtonSubstrate { id: favouriteButtonSubstrate }
    }
}//footerButtonsLayout
