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

    //those few become "not empty" depending on request (functionalFlag)
    property string serverUrl: ''
    property string email: ''
    property string sex: ''
    property string birthday: ''
    property string password: ''
    property string cats: UserSettings.getStrCats()
    //to authenticate client on server side
    property string secret: UserSettings.value("user_security/user_hash")
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
            //request for all categories
            case 'categories': return '';
            //request for user constants
            case 'constants': return '';
            //request for sign up
            case 'register': return 'email='+email+'&sex='+sex+'&birthday='+birthday;
            //request for log in
            case 'login': return 'email='+email+'&password='+password;
            //request for user info
            case 'user/info': return 'secret='+secret;
            //request for saving selected/deselected categories
            case 'user/refresh-cats': return 'secret='+secret+'&cats='+cats;
            //unknown request
            default: return -1;
        }
    }

    //dealing with response
    function responseHandler(responseText)
    {
        var errorFlag = responseText.substring(errorFlagBeg, errorFlagEnd);

        switch(errorFlag)
        {
            case 'REG-1': return 'Некорректная дата';
            case 'REG-2': return 'E-mail уже занят';
            case 'REG-3': return 'Неизвестный пол';
            case 'REG-4': return 'Некорректный e-mail';
            case 'REG-5': return 'Некорректный возраст';
            case 'LIN-1': return 'Неверный e-mail или пароль';
            case 'INF-1': return 'Неизвестный токен аутентификации';
            case 'CAT-0': return 'Неизвестная ошибка';
            case 'CAT-1': return 'Неизвестный токен аутентификации';
            case 'CAT-2': return 'Неизвестный id подкатегории';
            default: return 'NO_ERROR';
        }
    }

    //converts JSON in text form to JSON as object
    function strJSONtoJSON(responseText)
    {
        return JSON.parse(responseText);
    }

    function xhr()
    {
        var request = new XMLHttpRequest();
        var params = makeParams();

        //if -1, there was unknown request
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
                    var errorStatus = responseHandler(request.responseText);

                    if(errorStatus === 'NO_ERROR')
                    {
                        switch(functionalFlag)
                        {
                            case 'categories':
                                xmlHttpRequestLoader.setSource("selectCategoryPage.qml",
                                                               { "strCatsJSON": request.responseText }
                                                              );
                                break;
                            case 'register':
                                xmlHttpRequestLoader.setSource("passwordInputPage.qml",
                                                                { "email": email }
                                                              );
                                break;
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
                                var uInfoRespJSON = strJSONtoJSON(request.responseText);
                                //saving user info to fill fields
                                UserSettings.beginGroup("user_data");
                                UserSettings.setValue("email", uInfoRespJSON.email);
                                UserSettings.setValue("sex", uInfoRespJSON.sex);
                                UserSettings.setValue("birthday", uInfoRespJSON.birthday);
                                UserSettings.endGroup();
                                for(var i in uInfoRespJSON.categories)
                                    UserSettings.insertCat(uInfoRespJSON.categories[i]);
                                xmlHttpRequestLoader.source = "profileSettingsPage.qml";
                                break;
                            case 'user/refresh-cats':
                                xmlHttpRequestLoader.source = "profileSettingsPage.qml";
                                break;
                            default: console.log("Unknown functionalFlag"); break;
                        }
                    }
                    //showing response error
                    else toastMessage.setTextAndRun(errorStatus);
                }
                //showing connection error
                else toastMessage.setTextAndRun(qsTr("Request status: " + request.status
                                                     + ". Проверьте интернет соединение"));
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
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
