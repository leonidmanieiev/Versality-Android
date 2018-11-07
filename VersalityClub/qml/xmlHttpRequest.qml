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
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4

Item
{
    id: httpRequestItem
    enabled: Style.isConnected

    //depend on request (functionalFlag)
    property string serverUrl: ''
    //user data
    property string sex: AppSettings.value("user/sex")
    property string birthday: AppSettings.value("user/birthday")
    property string email: AppSettings.value("user/email")
    property string password: AppSettings.value("user/password")
    property string name: AppSettings.value("user/name")
    property string cats: AppSettings.getCatsAmount() === 0 ? '0' : AppSettings.getStrCats()
    //to authenticate client on server side
    property string secret: AppSettings.value("user/hash")
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
            case 'user': return 'secret='+secret;
            //request for saving selected/deselected categories
            case 'user/refresh-cats': return 'secret='+secret+'&cats='+cats;
            //request for refreshing sex, name and birthday
            case 'user/refresh-snb': return 'secret='+secret+'&sex='+sex+'&name='+name+'&birthday='+birthday;
            //request for adding promotion to favourite
            case 'user/mark': return 'secret='+secret+'&promo='+AppSettings.value("promotion/id");
            //request for erasing promotion from favourite
            case 'user/unmark': return 'secret='+secret+'&promo='+AppSettings.value("promotion/id");
            //request for getting all merked promotions
            case 'user/marked': return 'secret='+secret;
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
            case 'ERR-1': return 'Неизвестный токен аутентификации';
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

        console.log("xml request url: " + serverUrl + params);

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
                                                               { "strCatsJSON": request.responseText });
                                break;
                            case 'register':
                                xmlHttpRequestLoader.source = "passwordInputPage.qml";
                                break;
                            case 'login':
                                //saving hash(secret) for further auto authentication
                                AppSettings.beginGroup("user");
                                AppSettings.setValue("hash", request.responseText);
                                AppSettings.endGroup();

                                //determine whether user seen app instructions
                                if(AppSettings.value("user/seen_almost_done_page") === undefined)
                                {
                                    //setting key to 1, so user won't get app instructions anymore
                                    AppSettings.beginGroup("user");
                                    AppSettings.setValue("seen_almost_done_page", 1);
                                    AppSettings.endGroup();
                                    xmlHttpRequestLoader.source = "almostDonePage.qml";
                                }
                                else xmlHttpRequestLoader.source = "mapPage.qml"; break;
                            case 'user':
                                var uInfoRespJSON = strJSONtoJSON(request.responseText);
                                //saving user info to fill fields
                                AppSettings.beginGroup("user");
                                AppSettings.setValue("email", uInfoRespJSON.email);
                                AppSettings.setValue("sex", uInfoRespJSON.sex);
                                AppSettings.setValue("birthday", uInfoRespJSON.birthday);
                                AppSettings.setValue("name", uInfoRespJSON.name);
                                AppSettings.endGroup();
                                for(var i in uInfoRespJSON.categories)
                                    AppSettings.insertCat(uInfoRespJSON.categories[i]);
                                xmlHttpRequestLoader.source = "profileSettingsPage.qml";
                                break;
                            case 'user/refresh-cats':
                                xmlHttpRequestLoader.source = "profileSettingsPage.qml";
                                break;
                            case 'user/refresh-snb':
                                xmlHttpRequestLoader.source = "mapPage.qml";
                                break;
                            case 'user/marked':
                                Style.promsResponse = request.responseText;
                                xmlHttpRequestLoader.source = "favouritePage.qml";
                                break;
                            default: console.log("Unknown functionalFlag"); break;
                        }//switch(functionalFlag)
                    }//if(errorStatus === 'NO_ERROR')
                    else toastMessage.setTextAndRun(errorStatus);
                }//if(request.status === 200)
                else toastMessage.setTextAndRun(Helper.httpErrorDecoder(request.status));
            }//if(request.readyState === XMLHttpRequest.DONE)
            else console.log("Pending: " + request.readyState);
        }//request.onreadystatechange = function()

        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.send(params);
    }//function xhr()

    ToastMessage { id: toastMessage }

    Component.onCompleted: xhr()

    Loader
    {
        id: xmlHttpRequestLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
