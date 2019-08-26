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
import QtQuick 2.11
import QtQml 2.2
import QtPositioning 5.12
import QtLocation 5.9
import Network 0.9

Item
{
    property string callFromPageName: 'mapPage'
    property string api: Vars.allPromsTilesModel
    property bool isTilesApi: true

    id: userLocationItem
    enabled: true

    StaticNotifier
    {
        id: notifier
        notifierText: Vars.smthWentWrong
    }

    ToastMessage { id: toastMessage }

    Network { id: network }

    PositionSource
    {
        property bool initialCoordSet: false
        property string secret: AppSettings.value("user/hash")
        property real lat: position.coordinate.latitude
        property real lon: position.coordinate.longitude

        id: userLocation
        active: true
        updateInterval: 1000

        //request promotion info
        function requestForPromotions()
        {
            if(network.hasConnection())
            {
                toastMessage.close();

                var request = new XMLHttpRequest();
                var params = 'secret='+secret;

                console.log(api + params);

                request.open('POST', api);
                request.onreadystatechange = function()
                {
                    if(request.readyState === XMLHttpRequest.DONE)
                    {
                        if(request.status === 200)
                        {
                            notifier.visible = false;

                            //saving response for further using
                            if(isTilesApi) Vars.allPromsData = request.responseText;
                            else Vars.allUniquePromsData = request.responseText;
                        }
                        else notifier.visible = true;
                    }
                    else console.log("readyState: " + request.readyState);
                }

                request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                request.send(params);
            }
            else
            {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }//function requestForPromotions()

        onPositionChanged:
        {
            AppSettings.beginGroup("user");
            AppSettings.setValue("lat", position.coordinate.latitude);
            AppSettings.setValue("lon", position.coordinate.longitude);
            AppSettings.endGroup();
        }

        Component.onCompleted: requestForPromotions();
    }//PositionSource

    Loader
    {
        id: userLocationLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
