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
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Page
{
    //company data
    readonly property string comp_id: AppSettings.value("company/id")
    readonly property string comp_logo: AppSettings.value("company/logo")
    readonly property string comp_phone: AppSettings.value("company/phone")
    readonly property string comp_about: AppSettings.value("company/about")
    readonly property string comp_name: AppSettings.value("company/name")
    readonly property var comp_pictures: AppSettings.value("company/pictures")
    readonly property string comp_website: AppSettings.value("company/website")
    readonly property string pic1Source: comp_pictures[0]
    readonly property string pic2Source: comp_pictures[1]
    readonly property string pic3Source: comp_pictures[2]
    readonly property string pic4Source: comp_pictures[3]
    property string picSource: ''
    //all good flag
    property bool allGood: AppSettings.value("company/id") === undefined ? false : true
    //alias
    property alias loader: companyPageLoader

    header: HeaderButtons { }

    id: companyPage
    enabled: Vars.isConnected
    height: Vars.companyPageHeight
    width: Vars.screenWidth

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

    //checking internet connetion
    Network { toastMessage: toastMessage }

    background: Rectangle
    {
        id: backgroundColor
        anchors.fill: parent
        color: Vars.backgroundWhite
    }

    Flickable
    {
        id: mainFlickableArea
        visible: allGood
        clip: true
        width: parent.width
        height: Vars.screenHeight
        contentHeight: middleFieldsColumns.height*1.1
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width
            spacing: Vars.screenHeight*0.05
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout
            {
                id: logoContactInfo
                width: parent.width
                height: Vars.footerButtonsFieldHeight
                Layout.alignment: Qt.AlignHCenter
                spacing: parent.width*0.0625

                Rectangle
                {
                    id: compLogoField
                    width: parent.height
                    height: parent.height
                    Layout.alignment: Qt.AlignRight
                    color: "transparent"

                    ImageRounder
                    {
                        id: compLogo
                        imageSource: comp_logo
                        roundValue: parent.height*0.5
                    }
                }

                ColumnLayout
                {
                    id: namePhoneSite
                    Layout.alignment: Qt.AlignLeft

                    Label
                    {
                        id: compName
                        text: comp_name
                        font.family: regularText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
                    }

                    Label
                    {
                        id: compPhone
                        text: comp_phone
                        font.family: regularText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
                    }

                    Label
                    {
                        id: compSite
                        text: '<a href="'+comp_website+'"'
                              +' style="color: '+Vars.mainPurple+'">'
                              +comp_website+'</a>'
                        font.bold: true
                        font.family: boldText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
                        onLinkActivated: Qt.openUrlExternally(link)
                        textFormat: Text.RichText;
                    }
                }//namePhoneSite
            }//compLogoField

            Item
            {
                id: flicker_image_field
                clip: true
                width: parent.width
                height: parent.width*0.4

                Flickable
                {
                    id: picFlickableArea
                    clip: true
                    width: parent.width
                    height: parent.height
                    contentHeight: height
                    contentWidth: height*4.5
                    boundsBehavior: Flickable.DragOverBounds

                    RowLayout
                    {
                        id: picturesRow
                        width: parent.width
                        height: parent.height

                        Rectangle
                        {
                            id: compPicField1
                            width: parent.height
                            height: parent.height
                            Layout.leftMargin: middleFieldsColumns.height*0.09
                            color: "transparent"

                            ImageRounder
                            {
                                id: compPic1
                                imageSource: pic1Source
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea1
                                anchors.fill: parent
                                onClicked:
                                {
                                    picSource = pic1Source;
                                    compPicPopup.visible = true;
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField2
                            width: parent.height
                            height: parent.height
                            color: "transparent"

                            ImageRounder
                            {
                                id: compPic2
                                imageSource: pic2Source
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea2
                                anchors.fill: parent
                                onClicked:
                                {
                                    picSource = pic2Source;
                                    compPicPopup.visible = true;
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField3
                            width: parent.height
                            height: parent.height
                            color: "transparent"

                            ImageRounder
                            {
                                id: compPic3
                                imageSource: pic3Source
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea3
                                anchors.fill: parent
                                onClicked:
                                {
                                    picSource = pic3Source;
                                    compPicPopup.visible = true;
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField4
                            width: parent.height
                            height: parent.height
                            color: "transparent"

                            ImageRounder
                            {
                                id: compPic4
                                imageSource: pic4Source
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea4
                                anchors.fill: parent
                                onClicked:
                                {
                                    picSource = pic4Source;
                                    compPicPopup.visible = true;
                                }
                            }
                        }
                    }//picturesRow
                }//picFlickableArea

                Image
                {
                    id: pictures_fade_out
                    clip: true
                    width: parent.width
                    height: parent.height
                    source: "../backgrounds/comp_pictures_fade_out.png"
                }
            }//flicker_image_field

            Rectangle
            {
                id: textArea
                width: parent.width*0.9
                color: "transparent"
                Layout.leftMargin: middleFieldsColumns.height*0.09

                Label
                {
                    id: companyDescription
                    width: parent.width
                    text: comp_about
                    font.pixelSize: Helper.toDp(13, Vars.dpi)
                    font.family: regularText.name
                    color: Vars.backgroundBlack
                    wrapMode: Label.WordWrap
                }
            }
        }//middleFieldsColumns
    }//mainFlickableArea

    Popup
    {
        id: compPicPopup
        x: 0
        y: Vars.screenHeight*0.2
        width: parent.width
        height: parent.height*0.35
        padding: 0
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        Image
        {
            id: pic
            source: picSource
            anchors.fill: parent
        }
    }

    Component.onCompleted:
    {
        //setting active focus for key capturing
        companyPage.forceActiveFocus();
    }

    Image
    {
        id: compDescFadeOut
        clip: true
        anchors.bottom: background.top
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        source: "../backgrounds/description_fade_out.png"
    }

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        anchors.bottom: parent.bottom
        source: "../backgrounds/map_f.png"
    }

    FooterButtons { pressedFromPageName: 'companyPage.qml' }

    ToastMessage { id: toastMessage }

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
            else
            {
                //to avoid not loading bug
                appWindowLoader.source = "";
                appWindowLoader.source = pageName;
            }
        }
    }

    Loader
    {
        id: companyPageLoader
        asynchronous: false
        anchors.top: parent.top
        anchors.topMargin: -Vars.footerButtonsFieldHeight
        width: parent.width
        height: Vars.screenHeight
        visible: status == Loader.Ready

        function reload()
        {
            var oldSource = source;
            source = "";
            source = oldSource;
        }
    }
}
