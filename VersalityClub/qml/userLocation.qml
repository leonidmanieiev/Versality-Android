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

//request for user location
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQml 2.2
import QtPositioning 5.8

Item
{
    id: userLocationItem
    enabled: Style.isConnected

    PositionSource
    {
        property bool initialCoordSet: false
        property bool posMethodSet: false
        property string serverUrl: 'http://patrick.ga:8080/api/promotions?'
        property string secret: AppSettings.value("user/hash")
        property real lat: position.coordinate.latitude
        property real lon: position.coordinate.longitude

        id: userLocation
        active: true
        updateInterval: 1000
        //using .nmea if OS is win, because win does not have GPS module
        nmeaSource: Qt.platform.os === "windows" ? "../output_new.nmea" : undefined

        //handling errors
        function sourceErrorMessage(sourceError)
        {
            var sem;

            switch(sourceError)
            {
                case PositionSource.AccessError:
                    sem = qsTr("Нет привилегий на получение местоположения"); break;
                case PositionSource.ClosedError:
                    sem = qsTr("Включите определение местоположения"); break;
                case PositionSource.UnknownSourceError:
                    sem = qsTr("Неизвестная ошибка PositionSource"); break;
                case PositionSource.SocketError:
                    sem = qsTr("Ошибка подключения к источнику NMEA через socket"); break;
                default: break;
            }

            return sem;
        }

        //setting positioning method or return false if no methods allow
        function isPositioningMethodSet(supportedPositioningMethods)
        {
            switch(supportedPositioningMethods)
            {
                case PositionSource.NoPositioningMethods:
                    return false;
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

        //check if user gets further than Style.posGetFar(500) meters from initial position
        function isGetFar(curPosCoord)
        {
            var oldPos = QtPositioning.coordinate(AppSettings.value("user/lat"),
                                                  AppSettings.value("user/lon"));
            return curPosCoord.distanceTo(oldPos) > Style.posGetFar;
        }

        //check if user set his initial position more than Style.posTimeOut(30) minutes ago
        function isTimePassed()
        {
            var oldTime = AppSettings.value("user/timeCheckPoint");
            return Math.abs(new Date() - oldTime) > Style.posTimeOut;
        }

        function saveUserPositionInfo()
        {
            AppSettings.beginGroup("user");
            AppSettings.setValue("lat", lat);
            AppSettings.setValue("lon", lon);
            AppSettings.setValue("timeCheckPoint", new Date());
            AppSettings.endGroup();
        }

        //request promotion info
        function requestForPromotions()
        {
            var request = new XMLHttpRequest();
            var params = 'secret='+secret+'&lat='+AppSettings.value("user/lat")+
                         '&lon='+AppSettings.value("user/lon");

            console.log("userLocation request url: " + serverUrl + params);

            request.open('POST', serverUrl);
            request.onreadystatechange = function()
            {
                if(request.readyState === XMLHttpRequest.DONE)
                {
                    if(request.status === 200)
                    {
                        //saving response for further using
                        Style.promsResponse = request.responseText;
                    }
                    else toastMessage.setTextAndRun(Helper.httpErrorDecoder(request.status));
                }
                else console.log("Pending: " + request.readyState);
            }

            request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.send(params);
        }//function requestForPromotions()

        onSourceErrorChanged:
        {
            var sem = sourceErrorMessage(sourceError);

            if(sem === undefined)
                return;

            toastMessage.setTextAndRun(qsTr(sem));
            stop();
        }

        onUpdateTimeout: toastMessage.setTextAndRun(qsTr("Невозможно получить местоположение"));

        onPositionChanged:
        {
            if(posMethodSet)
            {
                //if android, there will be no onPositionChanged triggered
                //so initializing in Component.onComplete
                if(!initialCoordSet && Qt.platform.os === "windows")
                {
                    console.log("initial onPositionChanged")
                    initialCoordSet = true;
                    //saving initial position and timeCheckPoint of user
                    saveUserPositionInfo();
                    //making request for promotions which depend on position
                    requestForPromotions();
                }
                if(isGetFar(position.coordinate) || isTimePassed())
                {
                    console.log("onPositionChanged (isGetFar: " + isGetFar(position.coordinate) +
                                " | isTimePassed: " + isTimePassed()) + ")";
                    //out of date, saving data and making request for promotions
                    saveUserPositionInfo();
                    requestForPromotions();
                }
            }
        }//onPositionChanged

        Component.onCompleted:
        {
            if(isPositioningMethodSet(supportedPositioningMethods))
            {
                posMethodSet = true;
                //if windows, coordinates will be NaN because of .nmea file
                //so initializing in onPositionChanged
                if(!initialCoordSet && Qt.platform.os !== "windows")
                {
                    console.log("initial onPositionChanged")
                    initialCoordSet = true;
                    //saving initial position and timeCheckPoint of user
                    saveUserPositionInfo();
                    //making request for promotions which depend on position
                    requestForPromotions();
                }
            }
            else
            {
                toastMessage.setTextAndRun(qsTr("Ошибка установки метода определения местоположения"));
                return;
            }
        }//Component.onCompleted:
    }//PositionSource

    ToastMessage { id: toastMessage }

    Loader
    {
        id: userLocationLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
