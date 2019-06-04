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

//full info about promotion
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtPositioning 5.8
import QtGraphicalEffects 1.0

Page
{
    //promotion vars
    property string p_id: AppSettings.value("promo/id")
    property string p_title: AppSettings.value("promo/title")
    property string p_desc: AppSettings.value("promo/desc")
    property string p_pic: AppSettings.value("promo/pic")
    property string p_promo_code: AppSettings.value("promo/code")
    property string c_icon: AppSettings.value("promo/icon")
    property string comp_id: AppSettings.value("promo/comp_id")
    property bool p_is_marked: AppSettings.value("promo/is_marked")
    //all good flag
    property bool allGood: true
    //dist (in meters) to be able to active coupon
    readonly property int promCloseDist: 250
    //other
    property real nearestStoreLat
    property real nearestStoreLon
    property real minDistToStore: 5000000
    //readonly property int storeInfoItemHeight: Vars.screenHeight*0.06
    //alias
    property alias prom_loader: promotionPageLoader

    //setting lat and lon of the nearest to user store
    function setNearestStoreCoords(promJSON)
    {
        var userPos = QtPositioning.coordinate(AppSettings.value("user/lat"),
                                               AppSettings.value("user/lon"));
        for(var i in promJSON.stores)
        {
            var storePos = QtPositioning.coordinate(promJSON.stores[i].lat,
                                                    promJSON.stores[i].lon);
            var distToStore = Math.round(storePos.distanceTo(userPos));

            if(minDistToStore > distToStore)
            {
                minDistToStore = distToStore;
                nearestStoreLat = promJSON.stores[i].lat;
                nearestStoreLon = promJSON.stores[i].lon;
            }
        }
    }

    //get zoomLevel depends on distance between user and nearestStore
    function getZoomLevel()
    {
        var zoomLevelToDist = [25600, 12800, 6400, 3200, 1600, 800, 400, 200, 100, 50];
        var diff = Math.abs(zoomLevelToDist[0] - minDistToStore), closestDistIndex = 0;

        for(var i = 1; i < zoomLevelToDist.length; i++)
        {
            var currDiff = Math.abs(zoomLevelToDist[i] - minDistToStore);
            if(currDiff < diff)
            {
                diff = currDiff;
                closestDistIndex = i;
            }
        }

        switch(closestDistIndex)
        {
            case 0: return 9.5;
            case 1: return 10;
            case 2: return 10.5;
            case 3: return 12;
            case 4: return 13;
            case 5: return 13.5;
            case 6: return 14;
            case 7: return 15.5;
            case 8: return 16.5;
            case 9: return 18;
        }
    }

    id: promotionPage
    enabled: Vars.isConnected
    height: Vars.pageHeight
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
        id: pageBackground
        anchors.fill: parent
        color: Vars.whiteColor
    }

    Flickable
    {
        id: flickableArea
        visible: allGood
        clip: true
        width: parent.width
        height: Vars.screenHeight
        contentHeight: middleFieldsColumns.height*1.1
        anchors.horizontalCenter: parent.horizontalCenter
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width
            spacing: Vars.screenHeight*0.05
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle
            {
                id: promsImage
                Layout.alignment: Qt.AlignHCenter
                height: Vars.screenHeight*0.25
                width: parent.width*0.9
                radius: Vars.listItemRadius
                color: "transparent"

                RectangularGlow
                {
                    id: effect
                    z: -1
                    anchors.fill: promsImage
                    color: Vars.glowColor
                    glowRadius: 40
                    cornerRadius: promsImage.radius
                }

                //rounding promotion image
                ImageRounder
                {
                    imageSource: p_pic
                    roundValue: Vars.listItemRadius
                }
            }

            Label
            {
                id: promotionTitle
                text: p_title
                font.pixelSize: Helper.toDp(16, Vars.dpi)
                font.family: boldText.name
                font.weight: Font.Bold
                color: Vars.blackColor
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: parent.width*0.1
            }

            Rectangle
            {
                id: textArea
                width: parent.width*0.9
                height: promotionDescription.height
                color: Vars.whiteColor
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: parent.width*0.1

                Label
                {
                    id: promotionDescription
                    width: parent.width
                    text: p_desc
                    font.pixelSize: Helper.toDp(13, Vars.dpi)
                    font.family: regularText.name
                    color: Vars.blackColor
                    wrapMode: Label.WordWrap
                }
            }

            RowLayout
            {
                id: rowLayout1
                width: parent.width*0.9
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: parent.width*0.1
                spacing: parent.width*0.055

                ControlButton
                {
                    id: activeCoupon
                    buttonWidth: Vars.screenWidth*0.7
                    labelText: Vars.activateCoupon
                    labelColor: Vars.whiteColor
                    backgroundColor: Vars.activeCouponColor
                    borderColor: "transparent"
                    buttonClickableArea.onClicked:
                    {
                        if(minDistToStore < promCloseDist)
                        {
                            promoCodePopup.visible = true;
                            flickableArea.enabled = false;
                            //inform server about coupon was activated
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"api": Vars.userActivateProm,
                                                           "functionalFlag": "user/activate",
                                                           "promo_id": p_id});
                        }
                        else toastMessage.setTextAndRun(Vars.getCloserToProm, false);
                    }
                }

                IconedButton
                {
                    id: addToFavourite
                    width: Vars.screenHeight*0.08
                    height: Vars.screenHeight*0.08
                    Layout.alignment: Qt.AlignRight
                    buttonIconSource: p_is_marked ?
                                      "../icons/add_to_favourites_on.svg" :
                                      "../icons/add_to_favourites_off.svg"
                    clickArea.onClicked:
                    {
                        if(!p_is_marked)
                        {
                            p_is_marked = true;
                            buttonIconSource = "../icons/add_to_favourites_on.svg";
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"api": Vars.userMarkProm,
                                                           "functionalFlag": "user/mark",
                                                           "promo_id": p_id});
                        }
                        else
                        {
                            p_is_marked = false;
                            buttonIconSource = "../icons/add_to_favourites_off.svg";
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"api": Vars.userUnmarkProm,
                                                           "functionalFlag": "user/unmark",
                                                           "promo_id": p_id});
                        }
                    }
                }//addToFavourite
            }//rowLayout1

            ControlButton
            {
                id: nearestStoreButton
                buttonWidth: parent.width*0.9
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: parent.width*0.1
                labelText: Vars.closestAddress
                backgroundColor: "transparent"
                buttonClickableArea.onClicked:
                {
                    PageNameHolder.push("promotionPage.qml");
                    promotionPageLoader.setSource("mapPage.qml",
                                        { "defaultLat": nearestStoreLat,
                                          "defaultLon": nearestStoreLon,
                                          "defaultZoomLevel": getZoomLevel(),
                                          "showingNearestStore": true,
                                          "locButtClicked": true,
                                          "nearestPromId": p_id,
                                          "nearestPromIcon": c_icon
                                        });
                }
            }

            ControlButton
            {
                id: companyCardButton
                buttonWidth: parent.width*0.9
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: parent.width*0.1
                labelText: Vars.openCompanyCard
                backgroundColor: "transparent"
                buttonClickableArea.onClicked:
                {
                    PageNameHolder.push("promotionPage.qml");
                    AppSettings.beginGroup("company");
                    AppSettings.setValue("id", comp_id);
                    AppSettings.endGroup();
                    promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                  { "api": Vars.companyInfo,
                                                    "functionalFlag": 'company'
                                                  });
                }
            }
        }//middleFieldsColumns
    }//flickableArea

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        anchors.bottom: parent.bottom
        source: "../backgrounds/map_f.png"
    }

    Image
    {
        id: background2
        clip: true
        anchors.fill: parent
        source: "../backgrounds/fade_out_h.png"
    }

    Rectangle
    {
        id: promoCodePopup
        visible: false
        width: parent.width*0.8
        height: parent.height*0.5
        radius: 30
        color: Vars.birthdayPickerColor
        anchors.centerIn: parent

        Label
        {
            id: helpText
            clip: true
            color: Vars.whiteColor
            font.family: regularText.name
            text: Vars.activateCouponHelpText
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.3
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                        Vars.dpi)
        }

        Rectangle
        {
            id: codeSubstrate
            width: parent.width
            height: parent.height*0.2
            color: Vars.chosenPurpleColor
            anchors.top: helpText.bottom
            anchors.topMargin: parent.height*0.05
            anchors.horizontalCenter: parent.horizontalCenter

            Label
            {
                id: code
                clip: true
                text: p_promo_code
                color: Vars.whiteColor
                font.family: boldText.name
                font.weight: Font.Bold
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize*2,
                                            Vars.dpi)
            }
        }//codeSubstrate

        Rectangle
        {
            id: proceedButton
            opacity: clickableArea.pressed ? 0.8 : 1
            width: parent.width * 0.65
            height: buttonText.height*2
            radius: Vars.defaultRadius
            color: "transparent"
            border.color: Vars.whiteColor
            border.width: Vars.defaultFontPixelSize*0.2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.05
            anchors.horizontalCenter: parent.horizontalCenter

            Text
            {
                id: buttonText
                text: Vars.proceed
                font.family: regularText.name
                font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize*1.1,
                                            Vars.dpi)
                color: Vars.whiteColor
                anchors.centerIn: parent
            }

            MouseArea
            {
                id: clickableArea
                anchors.fill: parent
                onClicked:
                {
                    promoCodePopup.visible = false;
                    flickableArea.enabled = true;
                }
            }
        }//proceedButton
    }

    ToastMessage { id: toastMessage }

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        visible: allGood
        buttonText: Vars.backToPromsPicking
        buttonIconSource: "../icons/left_arrow.svg"
        iconAlias.width: height*0.5
        iconAlias.height: height*0.4
        onClicked: promotionPageLoader.source = "mapPage.qml"
    }

    FooterButtons
    {
        pressedFromPageName: 'promotionPage.qml'
        Component.onCompleted: disableAllButtonsSubstrates()
    }

    Component.onCompleted:
    {
        if(allGood)
        {
            var fpdInJSON = JSON.parse(Vars.fullPromData);

            setNearestStoreCoords(fpdInJSON);
            notifier.visible = false;
            promotionPage.forceActiveFocus();
        }
        else notifier.visible = true;
    }

    StaticNotifier
    {
        id: notifier
        notifierText: Vars.smthWentWrong
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
            else promotionPageLoader.source = pageName;

            //to avoid not loading bug
            promotionPageLoader.reload();
        }
    }

    Loader
    {
        id: promotionPageLoader
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
