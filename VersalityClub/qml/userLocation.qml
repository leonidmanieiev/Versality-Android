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
import QtQuick 2.11
import QtQml 2.2
import QtPositioning 5.8

Item
{
    id: userLocationItem

    PositionSource
    {
        property bool initialCoordSet: false
        property bool posMethodSet: false

        id: userLocation
        updateInterval: 1000
        //using .nmea if OS is win, because win does not have GPS module
        nmeaSource: Qt.platform.os === "windows" ? "../output_new.nmea" : undefined
        active: true

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
            var oldPos = QtPositioning.coordinate(UserSettings.value("user_data/lat"),
                                                  UserSettings.value("user_data/lon"));
            return curPosCoord.distanceTo(oldPos) > Style.posGetFar;
        }

        //check if user set his initial position more than Style.posTimeOut(30) minutes ago
        function isTimePassed()
        {
            var oldTime = UserSettings.value("user_data/timeCheckPoint");
            return Math.abs(new Date() - oldTime) > Style.posTimeOut;
        }

        function saveUserPositionInfo()
        {
            UserSettings.beginGroup("user_data");
            UserSettings.setValue("lat", position.coordinate.latitude);
            UserSettings.setValue("lon", position.coordinate.longitude);
            UserSettings.setValue("timeCheckPoint", new Date());
            UserSettings.endGroup();
        }

        function requestForPromotions()
        {
            if(userLocationLoader.source == "qrc:/qml/mapPage.qml")
                userLocationLoader.reload();
            else userLocationLoader.source = "qrc:/qml/mapPage.qml";
        }

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
                if(!initialCoordSet)
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
                                " | isTimePassed: " + isTimePassed());
                    //out of date, saving data and making request for promotions
                    saveUserPositionInfo();
                    requestForPromotions();        
                }
            }
        }

        Component.onCompleted:
        {
            if(isPositioningMethodSet(supportedPositioningMethods))
                posMethodSet = true;
            else
            {
                toastMessage.setTextAndRun(qsTr("Ошибка установки метода определения местоположения"));
                return;
            }
        }
    }

    ToastMessage { id: toastMessage }

    Loader
    {
        id: userLocationLoader
        anchors.fill: parent

        function reload()
        {
            var oldSource = source;
            source = '';
            source = oldSource;
        }
    }
}
