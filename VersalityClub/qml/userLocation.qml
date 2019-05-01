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

//request for user location
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQml 2.2
import QtPositioning 5.8
import QtLocation 5.9
import GeoLocation 0.6

Item
{
    property bool isGpsOff: false
    readonly property int posTimeOut: 30*60000//minutes to milliseconds
    readonly property int posGetFar: 1000//200//in meters
    //default is proms for map api
    property string callFromPageName: 'mapPage'
    property string api: Vars.allPromsTilesModel
    property bool isTilesApi: true

    id: userLocationItem
    enabled: true

    function disableUsability()
    {
        isGpsOff = true;
        Vars.isLocated = false;
        //disable parent of userLocationItem which is mapPage or listViewPage
        userLocationItem.parent.parent.enabled = false;
    }

    function enableUsability()
    {
        isGpsOff = false;
        Vars.isLocated = true;
        userLocationItem.parent.parent.enabled = true;
    }

    // TODO REMOVE COMMENTS BEFORE BUILD FOR ANDROID
    GeoLocationInfo
    {
        onPositionUpdated:
        {
            if(isGpsOff)
            {
                enableUsability();

                AppSettings.beginGroup("user");
                AppSettings.setValue("lat", getLat());
                AppSettings.setValue("lon", getLon());
                AppSettings.endGroup();
                userLocation.requestForPromotions();
                toastMessage.close();
            }
        }
    }

    PositionSource
    {
        property bool initialCoordSet: false
        property bool posMethodSet: false
        property string secret: AppSettings.value("user/hash")
        property real lat: position.coordinate.latitude
        property real lon: position.coordinate.longitude

        id: userLocation
        active: true
        updateInterval: 1000
        //using .nmea if OS is win, because win does not have GPS module
        nmeaSource: Qt.platform.os === "windows" ? "../output_new.nmea" : ""

        //handling errors
        function sourceErrorMessage(sourceError)
        {
            var sem = '';

            switch(sourceError)
            {
                case PositionSource.AccessError:
                    sem = Vars.noLocationPrivileges; break;
                case PositionSource.ClosedError:
                    sem = Vars.turnOnLocationAndWait; break;
                case PositionSource.UnknownSourceError:
                    sem = Vars.unknownPosSrcErr; break;
                case PositionSource.SocketError:
                    sem = Vars.nmeaConnectionViaSocketErr; break;
                default: break;
            }

            return sem;
        }

        //setting positioning method or return false if no methods allow
        function isPositioningMethodSet(supportedPositioningMethods)
        {
            switch(supportedPositioningMethods)
            {
                case PositionSource.AllPositioningMethods:
                    preferredPositioningMethods=PositionSource.AllPositioningMethods; break;
                case PositionSource.SatellitePositioningMethods :
                    preferredPositioningMethods=PositionSource.SatellitePositioningMethods; break;
                case PositionSource.NonSatellitePositioningMethods:
                    preferredPositioningMethods=PositionSource.NonSatellitePositioningMethods; break;
                default: return false;
            }

            return true;
        }

        //check if user gets further than posGetFar(500) meters from initial position
        function isGetFar(curPosCoord)
        {
            var oldPos = QtPositioning.coordinate(AppSettings.value("user/lat"),
                                                  AppSettings.value("user/lon"));
            return curPosCoord.distanceTo(oldPos) > posGetFar;
        }

        //check if user set his initial position more than posTimeOut(30) minutes ago
        function isTimePassed()
        {
            var oldTime = AppSettings.value("user/timeCheckPoint");
            return Math.abs(new Date() - oldTime) > posTimeOut;
        }

        function updateUserMarker()
        {
            //if loader was mapPageLoader we calling user locariot marker setter
            if(callFromPageName === Vars.mapPageId)
                parent.parent.parent.setUserLocationMarker(lat, lon, 0, false);
        }

        //for isGetFar() check
        function saveUserPositionInfo()
        {
            AppSettings.beginGroup("user");
            AppSettings.setValue("lat", lat);
            AppSettings.setValue("lon", lon);
            AppSettings.setValue("timeCheckPoint", new Date());
            AppSettings.endGroup();
        }

        //making request for promotions when started app but user did not move
        //so onPositionChanged won't emit
        function initialPromRequest()
        {
            //saving initial position and timeCheckPoint of user
            saveUserPositionInfo();
            //making request for promotions which depend on position
            requestForPromotions();
            //initial setting of user marker
            updateUserMarker();
        }

        //request promotion info
        function requestForPromotions()
        {
            var request = new XMLHttpRequest();
            //show all promos for now, not within radius
            /*var params = 'secret='+secret+'&lat='+AppSettings.value("user/lat")+
                         '&lon='+AppSettings.value("user/lon");*/
            var params = 'secret='+secret;

            console.log(api + params);

            request.open('POST', api);
            request.onreadystatechange = function()
            {
                if(request.readyState === XMLHttpRequest.DONE)
                {
                    if(isNaN(AppSettings.value("user/lat")) || isNaN(AppSettings.value("user/lon")))
                    {
                        disableUsability();
                        console.log(Vars.userLocationIsNAN);
                    }
                    else if(request.status === 200)
                    {
                        notifier.visible = false;
                        //saving response for further using
                        if(isTilesApi)
                            Vars.allPromsData = request.responseText;
                        else Vars.allUniquePromsData = request.responseText;
                    }
                    else notifier.visible = true;
                }
                else console.log("readyState: " + request.readyState);
            }

            request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.send(params);
        }//function requestForPromotions()

        onSourceErrorChanged:
        {
            if(sourceError === PositionSource.NoError)
            {
                enableUsability();
                return;
            }

            toastMessage.setTextNoAutoClose(sourceErrorMessage(sourceError));
            disableUsability();
            stop();
        }

        onUpdateTimeout: toastMessage.setText(Vars.unableToGetLocation)

        onPositionChanged:
        {
            if(posMethodSet)
            {
                if(Qt.platform.os === "windows" && !initialCoordSet)
                {
                    initialCoordSet = true;
                    initialPromRequest();
                }
                //update user coordinates
                else
                {
                    updateUserMarker();

                    if((isGetFar(position.coordinate) || isTimePassed()))
                    {
                        console.log("onPositionChanged (isGetFar: " + isGetFar(position.coordinate) +
                                    " | isTimePassed: " + isTimePassed() + ")");
                        //out of date, saving timeCheckPoint and making request for promotions
                        saveUserPositionInfo();
                        requestForPromotions();
                    }
                }
            }
        }//onPositionChanged

        Component.onCompleted:
        {
            if(isPositioningMethodSet(supportedPositioningMethods))
            {
                if(Qt.platform.os !== "windows")
                    initialPromRequest();

                posMethodSet = true;
                //activating user location button
                Vars.isLocated = true;
            }
            else toastMessage.setText(Vars.estabLocationMethodErr)
        }
    }//PositionSource

    StaticNotifier
    {
        id: notifier
        notifierText: Vars.smthWentWrong
    }

    ToastMessage { id: toastMessage }

    Loader
    {
        id: userLocationLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
