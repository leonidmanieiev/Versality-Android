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

//page where user select categories
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Page
{
    property string strCatsJSON: ''
    property string pressedFrom: 'selectCategoryPage.qml'
    readonly property double catsItemHeight: Vars.screenHeight*0.09
    readonly property double subCatsItemHeight: Vars.screenHeight*0.07

    id: selectCategoryPage
    enabled: Vars.isConnected
    height: Vars.pageHeight
    width: Vars.screenWidth

    // instead of saveSelectedButton
    function saveSelectedCategory()
    {
        PageNameHolder.pop();
        chooseCategoryPageLoader.setSource("xmlHttpRequest.qml",
                                          { "api": Vars.userSelectCats,
                                            "functionalFlag": 'user/refresh-cats',
                                            "nextPageAfterCatsSave": 'profileSettingsPage.qml'
                                          });
    }

    //checking internet connetion
    Network { toastMessage: toastMessage }

    FontLoader
    {
        id: mediumText;
        source: Vars.mediumFont
    }

    ListModel { id: catsModel }

    ListView
    {
        id: catsListView
        clip: true
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        topMargin: Vars.pageHeight*0.25
        bottomMargin: Vars.footerButtonsFieldHeight*1.05
        anchors.horizontalCenter: parent.horizontalCenter
        model: catsModel
        delegate: Component
        {
            id: catsDelegate
            Column
            {
                id: middleFieldsColumn
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                bottomPadding: Vars.screenHeight*0.03
                Rectangle
                {
                    id: catsItem
                    height: catsItemHeight
                    width: parent.width
                    radius: height*0.5
                    color: Vars.whiteColor
                    border.width: height*0.06
                    border.color: Vars.insteadOfGradientColor

                    Image
                    {
                        id: catIcon
                        sourceSize.width: parent.radius
                        sourceSize.height: parent.radius
                        anchors.left: parent.left
                        anchors.leftMargin: parent.radius*0.6
                        anchors.verticalCenter: parent.verticalCenter
                        source: "../icons/cat_"+id+".svg"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay
                    {
                        id: catIconColorOverlay
                        visible: true
                        anchors.fill: catIcon
                        source: catIcon
                        color: Vars.insteadOfGradientColor
                        cached: true
                    }

                    Text
                    {
                        id: catsItemText
                        text: title
                        x: parent.radius*2
                        color: Vars.blackColor
                        font.family: mediumText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Image
                    {
                        id: downArrow
                        visible: false
                        sourceSize.width: parent.radius*0.8
                        sourceSize.height: parent.radius*0.8
                        anchors.right: parent.right
                        anchors.rightMargin: Vars.screenHeight*0.045
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        source: "../icons/down_arrow.svg"
                    }

                    ColorOverlay
                    {
                        id: downArrowColorOverlay
                        visible: true
                        anchors.fill: downArrow
                        source: downArrow
                        color: Vars.chosenPurpleColor
                        cached: true
                    }

                    MouseArea
                    {
                        id: catsClickableArea
                        anchors.fill: parent
                        onClicked:
                        {
                            if(collapsed)
                            {
                                //trick with visiables is workaroud.
                                //if just change color it will create a duplicate of icon
                                downArrow.visible = true;
                                downArrowColorOverlay.visible = false;
                                downArrow.rotation = 180;

                                catsItem.color = Vars.insteadOfGradientColor;
                                catIconColorOverlay.visible = false;
                                catsItemText.color = Vars.whiteColor;
                            }
                            else
                            {
                                //trick with visiables is workaroud.
                                //if just change color it will create a duplicate of icon
                                downArrow.visible = false;
                                downArrowColorOverlay.visible = true;
                                downArrow.rotation = 0;

                                catsItem.color = Vars.whiteColor;
                                catIconColorOverlay.visible = true;
                                catsItemText.color = Vars.blackColor;
                            }

                            catsModel.setProperty(index, "collapsed", !collapsed);
                        }//onClicked
                    }
                }//catsItem

                Loader
                {
                    id: catsItemLoader
                    visible: !collapsed
                    property variant subCatsModel : subcats
                    sourceComponent: collapsed ? null : subCatsDelegate
                    onStatusChanged: if (status == Loader.Ready) item.model = subCatsModel
                }
            }//middleFieldsColumn
        }//catsDelegate
    }//catsListView

    Component
    {
        id: subCatsDelegate
        Column
        {
            id: middleFieldsSubColumn
            property alias model: subCatsRepeater.model
            width: catsListView.width*0.8
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: Vars.screenHeight*0.02
            //instead of bottomPadding
            spacing: Vars.screenHeight*0.01

            Repeater
            {
                id: subCatsRepeater
                delegate: Rectangle
                {
                    id: subCatsItem
                    radius: height*0.5
                    height: subCatsItemHeight
                    width: parent.width
                    color: AppSettings.contains(subid) ? Vars.insteadOfGradientColor : Vars.whiteColor

                    Text
                    {
                        id: subCatsText
                        x: parent.radius*2
                        width: parent.width*0.7
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: mediumText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
                        color: AppSettings.contains(subid) ? Vars.whiteColor :
                                                             Vars.blackColor
                        wrapMode: Text.WordWrap
                        text: subtitle
                    }

                    Image
                    {
                        id: tickIcon
                        visible: AppSettings.contains(subid)
                        sourceSize.width: parent.radius*1.2
                        sourceSize.height: parent.radius*1.2
                        anchors.left: parent.left
                        anchors.leftMargin: parent.radius*0.45
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        source: "../icons/tick.svg"
                    }

                    MouseArea
                    {
                        id: subCatsClickableArea
                        anchors.fill: parent
                        onClicked:
                        {
                            if(AppSettings.contains(subid))
                            {
                                subCatsItem.color = Vars.whiteColor;
                                subCatsText.color = Vars.blackColor;
                                tickIcon.visible = false;
                                AppSettings.removeCat(subid);
                            }
                            else
                            {
                                subCatsItem.color = Vars.insteadOfGradientColor;
                                subCatsText.color = Vars.whiteColor;
                                tickIcon.visible = true;
                                AppSettings.insertCat(subid);
                            }
                        }
                    }
                }//subCatsItem
            }//subCatsRepeater
        }//middleFieldsSubColumn
    }//subCatsDelegate

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
        showInfoButton: true
        pageTitleText: Vars.profileSettings
        pressedFromPageName: 'selectCategoryPage.qml'
    }

    ToastMessage { id: toastMessage }

    Component.onCompleted:
    {
        //setting active focus for key capturing
        selectCategoryPage.forceActiveFocus();

        var catsJSON = JSON.parse(strCatsJSON);
        Helper.catsJsonToListModel(catsJSON);
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
        pressedFromPageName: pressedFrom
        Component.onCompleted: showSubstrateForSettingsButton()
    }

    Keys.onReleased:
    {
        //back button pressed for android and windows
        if (event.key === Qt.Key_Back || event.key === Qt.Key_B)
        {
            event.accepted = true;
            saveSelectedCategory();

            //to avoid not loading bug
            chooseCategoryPageLoader.reload();
        }
    }

    Loader
    {
        id: chooseCategoryPageLoader
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
