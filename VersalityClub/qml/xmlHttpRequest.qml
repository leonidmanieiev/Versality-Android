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

Item
{
    id: httpRequestItem

    property string serverUrl: ''
    //those few become "not empty" depending on request (functionalFlag)
    property string email: UserSettings.value("user_data/email")
    property string sex: UserSettings.value("user_data/sex")
    property string birthday: UserSettings.value("user_data/birthday")
    property string password: ''
    property string cats: UserSettings.getStrCats()
    //to authenticate client request on server side
    property string secret: UserSettings.value("user_security/user_hash")
    //coords of user
    property real lat: 0.0
    property real lon: 0.0
    //flag to determine type of request
    property string functionalFlag: ''
    //beg and end possition of code of error from server
    readonly property int errorFlagBeg: 0
    readonly property int errorFlagEnd: 5

    //creates params for request
    function makeParams()
    {
        switch(functionalFlag)
        {
            case 'categories': return '';
            case 'register': return 'email='+email+'&sex='+sex+'&birthday='+birthday;
            case 'login': return 'email='+email+'&password='+password;
            case 'user/info': return 'secret='+secret;
            case 'user/refresh-cats': return 'secret='+secret+'&cats='+cats;
            case 'promotion': return 'secret='+secret+'&lat='+lat+'&lon='+lon;
            default: return -1;
        }
    }

    //dealing with response
    function responseHandler(responseText)
    {
        var errorFlag = responseText.substring(errorFlagBeg, errorFlagEnd);

        switch(errorFlag)
        {
            case 'REG-1': return 'REG-1: Некорректная дата';
            case 'REG-2': return 'REG-2: E-mail уже занят';
            case 'REG-3': return 'REG-3: Неизвестный пол';
            case 'REG-4': return 'REG-4: Некорректный e-mail';
            case 'LIN-1': return 'LIN-1: Неверный e-mail или пароль';
            case 'INF-1': return 'INF-1: Неизвестный токен аутентификации';
            case 'CAT-0': return 'CAT-0: Неизвестная ошибка';
            case 'CAT-1': return 'CAT-1: Неизвестный токен аутентификации';
            case 'CAT-2': return 'CAT-2: Неизвестный id подкатегории';
            case 'PROM-0': return 'PROM-0: Неизвестная ошибка';
            default: return 'NO_ERROR';
        }
    }

    function responseToJSON(responseText)
    {
        return JSON.parse(responseText);
    }

    function xhr()
    {
        var request = new XMLHttpRequest();
        var params = makeParams();

        //if -1, there was unknown type of request
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
                    //console.log("Response: " + request.responseText);
                    var errorStatus = responseHandler(request.responseText);

                    if(errorStatus === 'NO_ERROR')
                    {
                        switch(functionalFlag)
                        {
                            case 'categories':;
                                xmlHttpRequestLoader.setSource("selectCategoryPage.qml",
                                                               { "strCatsJSON": request.responseText }
                                                              ); break;
                            case 'register': xmlHttpRequestLoader.source = "passwordInputPage.qml"; break;
                            case 'login':
                                //saving hash(secret) for further auto authentication
                                UserSettings.beginGroup("user_security");
                                UserSettings.setValue("user_hash", request.responseText);
                                UserSettings.endGroup();
                                //determine whether user seen app instructions
                                if(UserSettings.value("user_data/seen_almost_done_page") === undefined)
                                {
                                    //setting key to 1, so user won't get app instructions anymore
                                    UserSettings.beginGroup("user_data");
                                    UserSettings.setValue("seen_almost_done_page", 1);
                                    UserSettings.endGroup();
                                    xmlHttpRequestLoader.source = "almostDonePage.qml";
                                }
                                else xmlHttpRequestLoader.source = "mapPage.qml"; break;
                            case 'user/info':
                                var uInfoRespJSON = responseToJSON(request.responseText);
                                UserSettings.beginGroup("user_data");
                                UserSettings.setValue("email", uInfoRespJSON.email);
                                UserSettings.setValue("sex", uInfoRespJSON.sex);
                                UserSettings.setValue("birthday", uInfoRespJSON.birthday);
                                UserSettings.endGroup();
                                for(var i in uInfoRespJSON.categories)
                                    console.log("selected cat: " +
                                                UserSettings.insertCat(uInfoRespJSON.categories[i]));
                                xmlHttpRequestLoader.source = "profileSettingsPage.qml";
                                break;
                            case 'user/refresh-cats':
                                console.log("Cats have been saved");
                                xmlHttpRequestLoader.source = "profileSettingsPage.qml";
                                break;
                            case 'promotion': console.log("promotions"); break;
                            default: console.log("Unknown functionalFlag"); break;
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
                    toastMessage.messageText = "HTTP error: " + request.status +
                                               ". Проверьте интернет соединение";
                    toastMessage.open();
                    toastMessage.tmt.running = true;
                }
            }
            else console.log("Pending: " + request.readyState);
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

    Loader
    {
        id: xmlHttpRequestLoader
        anchors.fill: parent
    }
}
