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

//http client
import "../"
import QtQuick 2.11
import QtQuick.Controls 2.4
import "../js/toDp.js" as Convert

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
    readonly property int errorFlagBeg: 0
    readonly property int errorFlagEnd: 5

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

    function responseHandler(responseText)
    {
        var errorFlag = responseText.substring(errorFlagBeg, errorFlagEnd);

        switch(errorFlag)
        {
            case 'REG-1': return 'REG-1: Некорректная дата';
            case 'REG-2': return 'REG-2: E-mail уже занят';
            case 'LIN-1': return 'LIN-1: Неверный e-mail или пароль';
            default: return 'NO_ERROR';
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
                    console.log("Response: " + request.responseText);
                    var errorStatus = responseHandler(request.responseText);

                    if(errorStatus === 'NO_ERROR')
                    {
                        switch(functionalFlag)
                        {
                            case 'categories': console.log("categories"); return '';
                            case 'register': signLogLoader.source = "passwordInputPage.qml"; break;
                            case 'login':
                                UserSettings.setValue("userHash", request.responseText);
                                if(UserSettings.value("seenAlmostDonePage") === undefined)
                                {
                                    UserSettings.setValue("seenAlmostDonePage", 1);
                                    signLogLoader.source = "almostDonePage.qml";
                                }
                                else signLogLoader.source = "mapPage.qml"; break;
                            case 'promotion': console.log("promotions"); return '';
                            default: console.log("Unknown functionalFlag"); return '';
                        }
                    }
                    else
                    {
                        toastMessage.messageText = errorStatus;
                        toastMessage.open();
                        toastMessage.tmt.running = true;
                    }
                }
                else
                {
                    toastMessage.messageText = "HTTP error: " + request.status;
                    toastMessage.open();
                    toastMessage.tmt.running = true;
                }
            }
            else console.log("Pending...");
        }

        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.send(params);
    }

    ToastMessage { id: toastMessage }

    Component.onCompleted:
    {
        console.log("Params: " + makeParams());
        xhr();
    }
}
