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

import QtQuick 2.11

Item
{
    id: httpRequestItem

    property string serverUrl: ''
    property string email: ''
    property string sex: ''
    property string birthday: ''
    property string password: ''
    property string secret: ''
    property real lat: 0.0
    property real lon: 0.0
    property int id: 0
    property string title: ''
    property bool adult: false
    property string functionalFlag: ''

    function makeParams()
    {
        switch(functionalFlag)
        {
            case 'categories': return 'id='+id+'&title='+title+'&adults='+adults;
            case 'register': return 'email='+email+'&sex='+sex+'&birthday='+birthday;
            case 'login': return 'email='+email+'&password='+password;
            case 'promotion': return 'secret='+secret+'&lat='+lat+'&lon='+lon;
            default: return -1;
        }
    }

    function xhr()
    {
        var request = new XMLHttpRequest();
        var params = makeParams();

        if(params === -1)
        {
            console.log("function xhr() faild. Params = -1");
            return;
        }

        request.open('POST', serverUrl);

        request.onreadystatechange = function()
        {
            if(request.readyState === XMLHttpRequest.DONE)
            {
                if(request.status === 200)
                {
                    console.log(request.responseText);
                    switch(functionalFlag)
                    {
                        case 'categories': console.log("categories"); return;
                        case 'register': signLogLoader.source = "passwordInputPage.qml"; break;
                        case 'login': signLogLoader.source = "almostDonePage.qml"; break;
                        case 'promotion': console.log("promotions"); return;
                        default: console.log("function xhr() faild. Params = -1"); return;
                    }
                }
                else console.log("HTTP: ", request.status, request.statusText);
            }
            else console.log("Pending...");
        }

        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.send(params);
    }

    Component.onCompleted:
    {
        console.log(makeParams());
        xhr();
    }
}
