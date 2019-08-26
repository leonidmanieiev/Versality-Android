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

//company card page
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

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
    readonly property var picsSources: [comp_pictures[0], comp_pictures[1],
                                        comp_pictures[2], comp_pictures[3]]
    property int picInd: 0
    property int namePhoneSiteTextSize: 6
    property string pressedFrom: 'companyPage.qml'
    //all good flag
    property bool allGood: AppSettings.value("company/id") === undefined ? false : true
    //help width
    property double width_between_buttons: (Vars.screenWidth*0.8 - Vars.headerButtonsHeight*4) / 3
    //alias
    property alias shp: settingsHelperPopup
    property alias fb: footerButton

    function setPopupPicAndShow()
    {
        settingsHelperPopup.hide();
        compPicPopup.picItem.source = Helper.adjastPicUrl(picsSources[picInd]);
        compPicPopup.visible = true;
        PageNameHolder.push('popupImage');
    }

    function logoSize()
    {
        //if(Vars.isXR || Vars.isXSMax)
        //    return 0.9;
        return 1;
    }

    header: HeaderButtons
    {
        id: headerButtons
        gallery: compPicPopup
        companyLoader: companyPageLoader
    }

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

    background: Rectangle
    {
        id: backgroundColor
        anchors.fill: parent
        color: compPicPopup.visible ? Vars.blackColor : Vars.whiteColor
    }

    Flickable
    {
        id: mainFlickableArea
        visible: allGood
        clip: true
        width: parent.width
        height: parent.height
        contentHeight: middleFieldsColumns.height
        anchors.top: parent.top
        bottomMargin: Vars.footerButtonsFieldHeight*1.05
        anchors.horizontalCenter: parent.horizontalCenter
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width*0.8
            spacing: Vars.screenHeight*0.05
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout
            {
                id: logoContactInfo
                width: parent.width
                height: Vars.footerButtonsFieldHeight
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Vars.dpr > 2 ? 3 : 0
                spacing: parent.width*0.0625

                Rectangle
                {
                    id: compLogoField
                    //Layout.preferredWidth: Vars.headerButtonsHeight
                    //Layout.alignment: Qt.AlignTop
                    //height: Vars.headerButtonsHeight
                    Layout.preferredWidth: Vars.headerButtonsHeight  * logoSize()
                    Layout.preferredHeight: Vars.headerButtonsHeight * logoSize()
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    color: Vars.whiteColor

                    ImageRounder
                    {
                        id: compLogo
                        imageSource: comp_logo
                        roundValue: parent.height*0.5
                    }
                }

                /*Rectangle
                {
                    id: dummy1
                    Layout.fillWidth: true
                    height: Vars.headerButtonsHeight
                    color: "transparent"
                }*/

                ColumnLayout
                {
                    id: namePhoneSite
                    //Layout.preferredWidth: Vars.headerButtonsHeight*3 + width_between_buttons*2
                    Layout.alignment: Qt.AlignLeft//Qt.AlignRight
                    spacing: 3

                    Label
                    {
                        id: compName
                        color: Vars.blackColor
                        text: comp_name
                        font.family: regularText.name
                        font.pixelSize: Helper.applyDpr(namePhoneSiteTextSize, Vars.dpr)
                    }

                    Label
                    {
                        id: compPhone
                        color: Vars.blackColor
                        text: comp_phone
                        font.family: regularText.name
                        font.pixelSize: Helper.applyDpr(namePhoneSiteTextSize, Vars.dpr)
                    }

                    Label
                    {
                        id: compSite
                        textFormat: Text.RichText;
                        text: '<a href="http://'+comp_website+'"'
                              +' style="color: '+Vars.purpleTextColor+'">'
                              +comp_website+'</a>'
                        font.pixelSize: Helper.applyDpr(namePhoneSiteTextSize, Vars.dpr)
                        font.family: boldText.name
                        font.bold: true
                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }//namePhoneSite
            }//compLogoField

            Item
            {
                id: flicker_image_field
                clip: true
                width: parent.width
                height: parent.width*0.5
                Layout.alignment: Qt.AlignLeft

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
                            color: Vars.whiteColor

                            ImageRounder
                            {
                                id: compPic1
                                imageSource: picsSources[0]
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea1
                                anchors.fill: parent
                                onClicked:
                                {
                                    picInd = 0;
                                    setPopupPicAndShow(picInd);
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField2
                            width: parent.height
                            height: parent.height
                            color: Vars.whiteColor

                            ImageRounder
                            {
                                id: compPic2
                                imageSource: picsSources[1]
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea2
                                anchors.fill: parent
                                onClicked:
                                {
                                    picInd = 1;
                                    setPopupPicAndShow(picInd);
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField3
                            width: parent.height
                            height: parent.height
                            color: Vars.whiteColor

                            ImageRounder
                            {
                                id: compPic3
                                imageSource: picsSources[2]
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea3
                                anchors.fill: parent
                                onClicked:
                                {
                                    picInd = 2;
                                    setPopupPicAndShow(picInd);
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField4
                            width: parent.height
                            height: parent.height
                            color: Vars.whiteColor

                            ImageRounder
                            {
                                id: compPic4
                                imageSource: picsSources[3]
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea4
                                anchors.fill: parent
                                onClicked:
                                {
                                    picInd = 3;
                                    setPopupPicAndShow(picInd);
                                }
                            }
                        }

                        Rectangle
                        {
                            id: dummy
                            width: parent.spacing*2
                            height: parent.height
                            color: "transparent"
                        }
                    }//picturesRow
                }//picFlickableArea

                Image
                {
                    id: pictures_fade_out
                    clip: true
                    visible: !compPicPopup.visible
                    width: parent.width
                    height: parent.height
                    anchors.right: parent.right
                    source: "../backgrounds/comp_pictures_fade_out.png"
                }
            }//flicker_image_field

            Rectangle
            {
                id: textAreaRect
                width: parent.width
                height: textArea.height
                color: "transparent"
                Layout.alignment: Qt.AlignLeft

                Label
                {
                    id: textArea
                    width: parent.width
                    text: comp_about+'\n\n'
                    font.pixelSize: Helper.applyDpr(7, Vars.dpr)
                    font.family: regularText.name
                    color: Vars.blackColor
                    wrapMode: Label.WordWrap
                }
            }
        }//middleFieldsColumns
    }//mainFlickableArea

    Popup
    {
        property alias picItem: pic

        id: compPicPopup
        x: 0
        y: 0
        width: parent.width
        height: parent.height
        padding: 0
        focus: true
        closePolicy: Popup.NoAutoClose
        onClosed:
        {
            headerButtons.isGalleryVisible = false;
            PageNameHolder.pop();
        }
        onOpened: headerButtons.isGalleryVisible = true
        background: Rectangle { color: Vars.blackColor }

        // because image is a little larger than popup
        // so make popup a little larger
        topInset: -1
        leftInset: -1
        rightInset: -1
        bottomInset: -1

        Image
        {
            id: pic
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
        }

        MouseArea
        {
            property int xStart: 0
            property bool canSwipe: false

            id: swiper
            enabled: parent.visible
            anchors.fill: parent

            onPressed:
            {
                canSwipe = true;
                xStart = mouse.x;
            }

            onPositionChanged:
            {
                var dist = mouse.x - xStart;
                xStart = mouse.x;

                if(picInd > 0 && dist > 15 && canSwipe)
                {
                    // swipe from left to right
                    canSwipe = false;
                    picInd = picInd-1;
                    pic.source = Helper.adjastPicUrl(picsSources[picInd]);
                }
                else if(picInd < 3 && dist < -15 && canSwipe)
                {
                    // swipe from right to left
                    canSwipe = false;
                    picInd = picInd+1;
                    pic.source = Helper.adjastPicUrl(picsSources[picInd]);
                }
            }
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
        visible: !compPicPopup.visible
        anchors.bottom: background.top
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        source: "../backgrounds/description_fade_out.png"
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
        companyFactor: headerButtons.height
        parentHeight: parent.height + companyFactor
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

    FooterButtons
    {
        id: footerButton
        pressedFromPageName: pressedFrom
        Component.onCompleted: showSubstrateForHomeButton()
    }

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
            {
                appWindow.close();
            }
            else if (pageName === 'popupImage')
            {
                compPicPopup.close();
            }
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
        anchors.fill: parent
        anchors.topMargin: -header.height
        visible: status == Loader.Ready

        function reload()
        {
            var oldSource = source;
            source = "";
            source = oldSource;
        }
    }
}
