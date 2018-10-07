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
        property bool compCompleted: false

        id: userLocation
        updateInterval: 1000
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

        //check if user gets further than posGetFar(500) meters from initial position
        function isGetFar(curPos)
        {
            var oldPos = QtPositioning.coordinate(UserSettings.value("user_data/lat"),
                                                  UserSettings.value("user_data/lon"));
            return curPos.distanceTo(oldPos) > Style.posGetFar;
        }

        //check if user set his initial position more than posTimeOut(30) minutes ago
        function isTimePassed(curTime)
        {
            var oldTime = UserSettings.value("user_data/timeCheckPoint");
            return Math.abs(curTime - oldTime) > Style.posTimeOut;
        }

        onSourceErrorChanged:
        {
            var sem = sourceErrorMessage(sourceError);

            if(sem === undefined)
                return;

            toastMessage.messageText = sem;
            toastMessage.open();
            toastMessage.tmt.running = true;
            //stop(); uncomment after deal with gps on PC
        }

        onUpdateTimeout:
        {
            toastMessage.messageText = qsTr("Невозможно получить местоположение");
            toastMessage.open();
            toastMessage.tmt.running = true;
        }

        onPositionChanged:
        {
            //check if initial position and timeCheckPoint of user was set
            if(compCompleted)
            {
                console.log("userLocation onPisitionChanged");

                if(isGetFar(position) || isTimePassed(new Date()))
                {

                }
                else
                {

                }
            }
        }

        Component.onCompleted:
        {
            if(isPositioningMethodSet(supportedPositioningMethods))
                console.log("Positioning method is set");
            else
            {
                toastMessage.messageText = qsTr("Ошибка установки метода определения местоположения");
                toastMessage.open();
                toastMessage.tmt.running = true;
                return;
            }

            //saving initial position and timeCheckPoint of user
            UserSettings.beginGroup("user_data");
            UserSettings.setValue("lat", position.coordinate.latitude);
            UserSettings.setValue("lon", position.coordinate.longitude);
            UserSettings.setValue("timeCheckPoint", new Date());
            UserSettings.endGroup();

            compCompleted = true;

            //making request for promotions which depend on position
            userLocationLoader.setSource("xmlHttpRequest.qml",
                                         { "serverUrl": 'http://patrick.ga:8080/api/promotions?',
                                           "functionalFlag": 'promotions'
                                         }
                                        );
        }
    }

    ToastMessage { id: toastMessage }

    Loader
    {
        id: userLocationLoader
        anchors.fill: parent
    }
}
