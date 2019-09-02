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
import Network 0.9
import EnableLocation 0.9

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
    property string pressedFrom: 'promotionPage.qml'
    property int btnLabelSize: Helper.applyDpr(7, Vars.dpr)
    //all good flag
    property bool allGood: true
    //dist (in meters) to be able to active coupon
    readonly property int promCloseDist: 250
    //other
    property bool parsed: false
    property real nearestStoreLat: 0.0
    property real nearestStoreLon: 0.0
    property real minDistToStore: 5000000 // 5000 km
    //alias
    property alias prom_loader: promotionPageLoader
    property alias shp: settingsHelperPopup
    property alias fb: footerButton

    //setting lat and lon of the nearest to user store
    function setNearestStoreCoords(promJSON)
    {
        if(!parsed)
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
            parsed = true;
            // close "ожидайте" message
            toastMessage.close();
        }
    }

    //get zoomLevel depends on distance between user and nearestStore
    function getZoomLevel()
    {
        if(minDistToStore === 5000000) return -1;

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
            case 0: return 9;
            case 1: return 9.5;
            case 2: return 10;
            case 3: return 11;
            case 4: return 12;
            case 5: return 12.5;
            case 6: return 13;
            case 7: return 14.5;
            case 8: return 15.5;
            case 9: return 17;
        }
    }

    function isUrl()
    {
        return Helper.isStringAnUrl(p_promo_code);
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

    GuestToastMessage { id: guestToastMessage }

    ToastMessage { id: toastMessage }

    ToastMessage { id: comeCloaserToastMessage }

    //checking internet connetion
    Network { id: network }

    background: Rectangle
    {
        id: pageBackground
        anchors.fill: parent
        color: Vars.whiteColor
    }

    // get user location for couponActivation and nearestStore
    PositionSource
    {
        id: positionSource
        active: Vars.locationGood
        updateInterval: 1

        onPositionChanged:
        {
            if(!isNaN(position.coordinate.latitude)) {
                AppSettings.beginGroup("user");
                AppSettings.setValue("lat", position.coordinate.latitude);
                AppSettings.setValue("lon", position.coordinate.longitude);
                AppSettings.endGroup();
            }
        }

        onSourceErrorChanged:
        {
            if(Vars.locationGood && sourceError != PositionSource.NoError && !Vars.reloaded) {
                // need reload because positionSource still think
                // that i have no permission for user location
                console.log("reload");
                Vars.reloaded = true;
                promotionPageLoader.source = "";
                promotionPageLoader.source = "promotionPage.qml";
            }
        }
    }

    // wait for user location
    Timer
    {
        id: waitForUserLocation
        interval: 1
        running: !isNaN(positionSource.position.coordinate.latitude)
        onTriggered: setNearestStoreCoords(JSON.parse(Vars.fullPromData));
    }

    function proceedCouponActivation()
    {
        Vars.locationGood = false; // to stop repeating execution
        console.log("minDistToStore:", minDistToStore);
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
        else
        {
            toastMessage.close();
            comeCloaserToastMessage.setTextAndRun(Vars.getCloserToProm, false);
        }
    }

    function proceedNearestStoreShowing()
    {
        promotionPageLoader.setSource("mapPage.qml",
                            { "defaultLat": nearestStoreLat,
                              "defaultLon": nearestStoreLon,
                              "userLat": AppSettings.value("user/lat"),
                              "userLon": AppSettings.value("user/lon"),
                              "defaultZoomLevel": getZoomLevel(),
                              "showingNearestStore": true,
                              "locButtClicked": true,
                              "nearestPromId": p_id,
                              "nearestPromIcon": c_icon
                            });
    }

    // wait for user nearest store or active coupon request
    // and parsing end
    Timer
    {
        id: waitForUserLocationAndAsk
        interval: 1
        running: Vars.locationGood && parsed
        onTriggered:
        {
            if(network.hasConnection())
            {
                toastMessage.close();
                PageNameHolder.push(pressedFrom);

                if(Vars.activeCouponRequest) {
                    proceedCouponActivation();
                } else {
                    proceedNearestStoreShowing();
                }
            }
            else
            {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }
    }

    Flickable
    {
        id: flickableArea
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
            width: Vars.screenWidth*0.8
            spacing: Vars.screenHeight*0.045
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle
            {
                id: promsImage
                Layout.alignment: Qt.AlignLeft
                height: Vars.screenHeight*0.25*Vars.footerHeightFactor
                width: parent.width
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
                font.pixelSize: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
                font.family: boldText.name
                font.weight: Font.Bold
                color: Vars.blackColor
                Layout.alignment: Qt.AlignLeft
            }

            Rectangle
            {
                id: textArea
                width: promsImage.width
                height: promotionDescription.height
                color: Vars.whiteColor
                Layout.alignment: Qt.AlignLeft

                Label
                {
                    id: promotionDescription
                    width: parent.width
                    text: p_desc
                    font.pixelSize: Helper.applyDpr(7, Vars.dpr)
                    font.family: regularText.name
                    color: Vars.blackColor
                    wrapMode: Label.WordWrap
                }
            }

            RowLayout
            {
                id: rowLayout1
                width: promsImage.width
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: -Vars.pageHeight*0.03
                spacing: parent.width*0.055

                ControlButton
                {
                    id: activeCoupon
                    buttonWidth: Vars.screenWidth*0.7
                    labelText: Vars.activateCoupon
                    labelColor: Vars.whiteColor
                    backgroundColor: Vars.activeCouponColor
                    borderColor: "transparent"
                    fontPixelSize: btnLabelSize
                    buttonClickableArea.onClicked:
                    {
                        // functionality is disable if guest loged in
                        if(Vars.isGuest || AppSettings.value("user/hash") === Vars.guestHash)
                        {
                            guestToastMessage.setGuestText(Vars.functionalityIsNotAvailable);
                        }
                        else
                        {
                            if(EnableLocation.askEnableLocation())
                            {
                                Vars.locationGood = true;
                                Vars.activeCouponRequest = true;
                                positionSource.start();
                            }
                            else
                            {
                                Vars.locationGood = false;
                                Vars.reloaded = false;
                                positionSource.stop();
                            }
                        }
                    }
                }

                IconedButton
                {
                    id: addToFavourite
                    width: Vars.screenHeight  * 0.05 * Vars.iconHeightFactor
                    height: Vars.screenHeight * 0.05 * Vars.iconHeightFactor
                    Layout.alignment: Qt.AlignRight
                    buttonIconSource: p_is_marked ?
                                      "../icons/add_to_favourites_on.svg" :
                                      "../icons/add_to_favourites_off.svg"
                    clickArea.onClicked:
                    {
                        // functionality is disable if guest loged in
                        if(Vars.isGuest || AppSettings.value("user/hash") === Vars.guestHash)
                        {
                            guestToastMessage.setGuestText(Vars.functionalityIsNotAvailable);
                        }
                        else
                        {
                            if(network.hasConnection())
                            {
                                toastMessage.close();
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
                            else
                            {
                                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
                            }
                        }
                    }
                }//addToFavourite
            }//rowLayout1

            ControlButton
            {
                id: nearestStoreButton
                Layout.topMargin: -Vars.pageHeight*0.02
                buttonWidth: promsImage.width*0.9
                Layout.alignment: Qt.AlignLeft
                labelText: Vars.closestAddress
                fontPixelSize: btnLabelSize
                backgroundColor: "transparent"
                buttonClickableArea.onClicked:
                {
                    if(EnableLocation.askEnableLocation())
                    {
                        Vars.locationGood = true;
                        Vars.activeCouponRequest = false;
                        positionSource.start();
                    }
                    else
                    {
                        Vars.locationGood = false;
                        Vars.reloaded = false;
                        positionSource.stop();
                    }
                }
            }

            ControlButton
            {
                id: companyCardButton
                Layout.topMargin: -Vars.pageHeight*0.02
                labelColor: Vars.blackColor
                borderColor: Vars.blackColor
                buttonWidth: promsImage.width
                Layout.alignment: Qt.AlignLeft
                labelText: Vars.openCompanyCard
                fontPixelSize: btnLabelSize
                backgroundColor: "transparent"
                buttonClickableArea.onClicked:
                {
                    if(network.hasConnection())
                    {
                        toastMessage.close();
                        PageNameHolder.push(pressedFrom);
                        AppSettings.beginGroup("company");
                        AppSettings.setValue("id", comp_id);
                        AppSettings.endGroup();
                        promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                      { "api": Vars.companyInfo,
                                                        "functionalFlag": 'company'
                                                      });
                    }
                    else
                    {
                        toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
                    }
                }
            }
        }//middleFieldsColumns
    }//flickableArea

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
        parentHeight: parent.height
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
            visible: !isUrl()
            color: Vars.whiteColor
            font.family: regularText.name
            text: Vars.activateCouponHelpText
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height*0.3
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
        }

        Rectangle
        {
            id: codeSubstrate
            visible: !isUrl()
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
                font.pixelSize: Helper.applyDpr(Vars.defaultFontPixelSize*1.5, Vars.dpr)
            }
        }//codeSubstrate

        Image
        {
            id: codeImage
            clip: true
            visible: isUrl()
            source: Helper.adjastPicUrl(p_promo_code);
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.1 + proceedButton.height
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.width: Vars.dpr === 2 ? parent.width*0.80 : parent.width*0.75
            sourceSize.height: Vars.dpr === 2 ? parent.width*0.80 : parent.width*0.75
            fillMode: Image.PreserveAspectFit
        }

        Rectangle
        {
            id: proceedButton
            opacity: clickableArea.pressed ? 0.8 : 1
            width: parent.width * 0.65
            height: buttonText.height*2
            radius: Vars.defaultRadius
            color: "transparent"
            border.color: Vars.whiteColor
            border.width: Helper.applyDpr(2, Vars.dpr)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.05
            anchors.horizontalCenter: parent.horizontalCenter

            Text
            {
                id: buttonText
                text: Vars.proceed
                font.family: regularText.name
                font.pixelSize: Helper.applyDpr(Vars.defaultFontPixelSize*1.1, Vars.dpr)
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

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        visible: allGood
        buttonText: Vars.backToPromsPicking
        buttonIconSource: "../icons/left_arrow.svg"
        iconAlias.sourceSize.width: height*0.5
        iconAlias.sourceSize.height: height*0.4
        onClicked:
        {
            if(network.hasConnection()) {
                toastMessage.close();
                promotionPageLoader.source = "mapPage.qml"
            } else {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }
    }

    FooterButtons
    {
        id: footerButton
        pressedFromPageName: pressedFrom
        Component.onCompleted: showSubstrateForHomeButton()
    }

    Component.onCompleted:
    {
        if(allGood) {
            if(Vars.locationGood) {
                toastMessage.setTextNoAutoClose("Ожидайте");
            }

            notifier.visible = false;
            promotionPage.forceActiveFocus();
        } else {
            notifier.visible = true;
        }
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
