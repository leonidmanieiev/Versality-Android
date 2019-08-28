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

//http client
import "../"
import "../js/helpFunc.js" as Helper
import OneSignal 1.0
import CppMethodCall 0.9
import QtQuick 2.11
import QtQuick.Controls 2.4
import Network 0.9

Item
{
    id: httpRequestItem
    enabled: Vars.isConnected

    //depend on request (functionalFlag)
    property string api: ''
    property string nextPageAfterCatsSave: 'profileSettingsPage.qml'
    property string nextPageAfterSettingsSave: 'mapPage.qml'
    property string nextPageAfterRetrieveUserCats: ''
    //user data
    property string sex: AppSettings.value("user/sex") === undefined ? "" : AppSettings.value("user/sex")
    property string birthday: AppSettings.value("user/birthday") === undefined ? "" : AppSettings.value("user/birthday")
    property string email: AppSettings.value("user/email") === undefined ? "" : AppSettings.value("user/email")
    property string name: AppSettings.value("user/name") === undefined ? "" : AppSettings.value("user/name")
    property string cats: AppSettings.getCatsAmount() === 0 ? '0' : AppSettings.getStrCats()
    property string password: AppSettings.value("user/password") === undefined ? "" : AppSettings.value("user/password")
    property bool hasPassChanged
    property string code: ''
    //to authenticate client on server side
    property string secret: AppSettings.value("user/hash") === undefined ? "" : AppSettings.value("user/hash")
    //flags
    property string functionalFlag: ''
    property bool allGood: false
    property bool newUser: Vars.fromSignUp
    property bool requestFromADP: false
    //beg and end possition of code of error from server
    readonly property int errorFlagBeg: 0
    readonly property int errorFlagEnd: 5
    //promotions data
    property string promo_id: AppSettings.value("promo/id") === undefined ? '' : AppSettings.value("promo/id")
    property string promo_desc: AppSettings.value("promo/desc") === undefined ? '' : AppSettings.value("promo/desc")
    //company data
    property string comp_id: AppSettings.value("company/id") === undefined ? '' : AppSettings.value("company/id")

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
            case 'user/refresh-snbp':
                var params = 'secret='+secret+'&sex='+sex+'&name='+name+'&birthday='+birthday;
                return hasPassChanged ? params+'&pass='+password : params;
            //request for adding promotion to favourite
            case 'user/mark': return 'secret='+secret+'&promo='+promo_id;
            //request for erasing promotion from favourite
            case 'user/unmark': return 'secret='+secret+'&promo='+promo_id;
            //request for getting all merked promotions
            case 'user/marked': return 'secret='+secret;
            //request for inform server about coupon was activeted
            case 'user/activate': return 'secret='+secret+'&promo='+promo_id;
            //request for data for promotion preview
            case 'user/preprom': return 'promo_id='+promo_id+'&secret='+secret;
            //request for full data for promotion
            case 'user/fullprom': return 'promo_id='+promo_id+'&secret='+secret;
            //request for password reset
            case 'user/reset-pass': return 'login='+email;
            //request for password change
            case 'user/set-pass': return 'login='+email+'&code='+code+'&new='+password;
            //request for company info
            case 'company': return 'secret='+secret+'&id='+comp_id+'&promos=true';
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
            case 'ERR-2': return 'Неизвестный id акции';
            default: return 'NO_ERROR';
        }
    }

    ToastMessage { id: toastMessage }

    Network { id: network }

    function xhr()
    {
        var request = new XMLHttpRequest();
        var params = makeParams();

        console.log(api + params);

        //if -1, there was unknown request
        if(params === -1)
        {
            console.log("Params = -1");
            return;
        }

        request.open('POST', api);

        request.onreadystatechange = function()
        {
            if(request.readyState === XMLHttpRequest.DONE)
            {
                if(request.status === 200)
                {
                    var errorStatus = responseHandler(request.responseText);
                    //console.log("server:" + request.responseText);

                    if(errorStatus === 'NO_ERROR')
                    {
                        switch(functionalFlag)
                        {
                            case 'categories':
                                xmlHttpRequestLoader.setSource("selectCategoryPage.qml",
                                                               { "strCatsJSON": request.responseText });
                                break;
                            case 'register':
                                xmlHttpRequestLoader.setSource("passwordInputPage.qml",
                                                               { "fromRegistration": true });
                                break;
                            case 'login':
                                //saving hash(secret) for further auto authentication
                                AppSettings.beginGroup("user");
                                AppSettings.setValue("hash", request.responseText);
                                AppSettings.endGroup();

                                QOneSignal.sendTag("hash", AppSettings.value("user/hash"));
                                CppMethodCall.saveHashToFile();

                                if(newUser)
                                {
                                    //if new user, show app tips
                                    xmlHttpRequestLoader.source = "almostDonePage.qml";
                                }
                                else xmlHttpRequestLoader.source = "mapPage.qml"; break;
                            case 'user':
                                try {
                                    var uInfoRespJSON = JSON.parse(request.responseText);
                                    //saving user info to fill fields
                                    AppSettings.beginGroup("user");
                                    AppSettings.setValue("email", uInfoRespJSON.email);
                                    AppSettings.setValue("sex", uInfoRespJSON.sex);
                                    AppSettings.setValue("birthday", uInfoRespJSON.birthday);
                                    AppSettings.setValue("name", uInfoRespJSON.name);
                                    AppSettings.endGroup();

                                    // if get here from almostDonePage
                                    if(requestFromADP)
                                    {
                                        // set all categories - up
                                        AppSettings.setAllCatsUp();
                                        xmlHttpRequestLoader.setSource("xmlHttpRequest.qml",
                                                                       { "api": Vars.userSelectCats,
                                                                         "functionalFlag": 'user/refresh-cats',
                                                                         "nextPageAfterCatsSave": 'profileSettingsPage.qml'
                                                                       });
                                    }
                                    else
                                    {
                                        // set only user selected categories - up
                                        for(var i in uInfoRespJSON.categories)
                                            AppSettings.insertCat(uInfoRespJSON.categories[i]);

                                        if(nextPageAfterRetrieveUserCats === 'selectCategoryPage.qml') {
                                            xmlHttpRequestLoader.setSource("xmlHttpRequest.qml",
                                                                           {
                                                                              "api": Vars.allCats,
                                                                              "functionalFlag": 'categories'
                                                                           });
                                        } else {
                                            xmlHttpRequestLoader.source = "profileSettingsPage.qml";
                                        }
                                    }
                                } catch (e1) {
                                    toastMessage.setTextAndRun(Vars.smthWentWrong, true);
                                }
                                break;
                            case 'user/refresh-cats':
                                if(nextPageAfterCatsSave === 'favouritePage.qml')
                                {
                                    xmlHttpRequestLoader.setSource("xmlHttpRequest.qml",
                                                                   { "api": Vars.userMarkedProms,
                                                                     "functionalFlag": 'user/marked'
                                                                   });
                                }
                                else if(nextPageAfterCatsSave === 'appInfoPage.qml')
                                {
                                    appWindowLoader.source = nextPageAfterCatsSave;
                                }
                                else
                                {
                                    xmlHttpRequestLoader.source = nextPageAfterCatsSave;
                                }
                                break;
                            case 'user/refresh-snbp':
                                try {
                                    var uInfoJSON = JSON.parse(request.responseText);
                                    //saving new hash
                                    AppSettings.beginGroup("user");
                                    AppSettings.setValue("hash", uInfoJSON.secret);
                                    AppSettings.endGroup();

                                    QOneSignal.sendTag("hash", AppSettings.value("user/hash"));
                                    CppMethodCall.saveHashToFile();

                                    if(nextPageAfterSettingsSave === 'selectCategoryPage.qml') {
                                        xmlHttpRequestLoader.setSource("xmlHttpRequest.qml",
                                                                       {
                                                                          "api": Vars.allCats,
                                                                          "functionalFlag": 'categories'
                                                                       });
                                    } else {
                                        xmlHttpRequestLoader.source = nextPageAfterSettingsSave;
                                    }
                                } catch (e2) {
                                    toastMessage.setTextAndRun(Vars.smthWentWrong, true);
                                }
                                break;
                            case 'user/marked':
                                Vars.markedPromsData = request.responseText;
                                xmlHttpRequestLoader.source = "favouritePage.qml";
                                break;
                            case 'user/preprom':
                                Vars.previewPromData = request.responseText;

                                //if we got correct response
                                if(Vars.previewPromData.length > 50)
                                {
                                    try {
                                        //formating data
                                        var ppdInJSON = JSON.parse(Vars.previewPromData);
                                        allGood = true;
                                        //initializing vars
                                        AppSettings.beginGroup("promo");
                                        AppSettings.setValue("id", ppdInJSON[0].id);
                                        AppSettings.setValue("title", ppdInJSON[0].title);
                                        AppSettings.setValue("desc", ppdInJSON[0].desc);
                                        AppSettings.setValue("pic", ppdInJSON[0].pic);
                                        AppSettings.setValue("icon", ppdInJSON[0].icon);
                                        AppSettings.setValue("comp_logo", ppdInJSON[0].company_logo);
                                        AppSettings.setValue("lat", ppdInJSON[0].lat);
                                        AppSettings.setValue("lon", ppdInJSON[0].lon);
                                        AppSettings.setValue("is_marked", ppdInJSON[0].is_marked);
                                        AppSettings.endGroup();
                                    } catch (e3) {
                                        allGood = false;
                                    }
                                }
                                else allGood = false;

                                xmlHttpRequestLoader.setSource("previewPromotionPage.qml",
                                                               { "allGood": allGood });
                                break;
                            case 'user/fullprom':
                                Vars.fullPromData = request.responseText;

                                //if we got correct response
                                if(Vars.fullPromData.length > 50)
                                {
                                    try {
                                        //formating data
                                        var fpdInJSON = JSON.parse(Vars.fullPromData);
                                        allGood = true;
                                        //initializing vars
                                        AppSettings.beginGroup("promo");
                                        AppSettings.setValue("id", fpdInJSON.id);
                                        AppSettings.setValue("title", fpdInJSON.title);
                                        AppSettings.setValue("desc", fpdInJSON.desc);
                                        AppSettings.setValue("pic", fpdInJSON.pic);
                                        AppSettings.setValue("icon", fpdInJSON.icon);
                                        AppSettings.setValue("comp_id", fpdInJSON.company_id);
                                        AppSettings.setValue("code", fpdInJSON.promo_code);
                                        AppSettings.setValue("is_marked", fpdInJSON.is_marked);
                                        AppSettings.endGroup();
                                    } catch (e4) {
                                        allGood = false;
                                    }
                                }
                                else allGood = false;

                                xmlHttpRequestLoader.setSource("promotionPage.qml",
                                                               { "allGood": allGood });
                                break;
                            case 'user/reset-pass':
                                xmlHttpRequestLoader.setSource("changePasswordPage.qml");
                                break;
                            case 'user/set-pass':
                                //refresh hash(secret) with new one
                                AppSettings.beginGroup("user");
                                AppSettings.setValue("hash", request.responseText);
                                AppSettings.endGroup();

                                QOneSignal.sendTag("hash", AppSettings.value("user/hash"));
                                CppMethodCall.saveHashToFile();

                                xmlHttpRequestLoader.source = "passwordInputPage.qml";
                                break;
                            case 'company':
                                Vars.fullCompanyData = request.responseText;

                                //if we got correct response
                                if(Vars.fullCompanyData.length > 50)
                                {
                                    try {
                                        //formating data
                                        var fсdInJSON = JSON.parse(Vars.fullCompanyData);
                                        allGood = true;
                                        //initializing vars
                                        AppSettings.beginGroup("company");
                                        AppSettings.setValue("id", fсdInJSON.id);
                                        AppSettings.setValue("logo", fсdInJSON.logo);
                                        AppSettings.setValue("about", fсdInJSON.about);
                                        AppSettings.setValue("phone", fсdInJSON.phone);
                                        AppSettings.setValue("name", fсdInJSON.name);
                                        AppSettings.setValue("pictures", fсdInJSON.pictures);
                                        AppSettings.setValue("website", fсdInJSON.website);
                                        AppSettings.setValue("promos", fсdInJSON.promos);
                                        AppSettings.endGroup();
                                    } catch (e5) {
                                        allGood = false;
                                    }
                                }
                                else allGood = false;

                                xmlHttpRequestLoader.setSource("companyPage.qml",
                                                               { "allGood": allGood });
                                break;
                            default: console.log("Unknown functionalFlag"); break;
                        }//switch(functionalFlag)
                    }//if(errorStatus === 'NO_ERROR')
                    else
                    {
                        console.log("errorStatus:", errorStatus);
                        toastMessage.setTextAndRun(errorStatus, false);
                    }
                }//if(request.status === 200)
                else if(request.status !== null)
                {
                    console.log("request.status:", request.status);
                    toastMessage.setTextAndRun(Helper.httpErrorDecoder(request.status), true);
                }
                else
                {
                    console.log("xhr()::request.status is null");
                    toastMessage.setTextAndRun(Vars.smthWentWrong, true);
                }
            }//if(request.readyState === XMLHttpRequest.DONE)
            else console.log("readyState: " + request.readyState);
        }//request.onreadystatechange = function()

        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.send(params);
    }//function xhr()

    function showIndicator()
    {
        // these pages show white screen while loading
        return (api === Vars.userInfo ||
                api === Vars.allCats ||
                api === Vars.userMarkedProms ||
                api === Vars.userSelectCats ||
                api === Vars.promFullViewModel);
    }

    Rectangle
    {
        id: stubBackground
        anchors.fill: parent
        visible: showIndicator()
        color: "#4d1463"
    }

    BusyIndicator {
        id: control
        visible: showIndicator()
        anchors.centerIn: parent

        contentItem: Item {
            implicitWidth: 64
            implicitHeight: 64

            Item {
                id: item
                x: parent.width / 2 - 32
                y: parent.height / 2 - 32
                width: 64
                height: 64
                opacity: control.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                    }
                }

                RotationAnimator {
                    target: item
                    running: control.visible && control.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 3

                    Rectangle {
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: 10
                        implicitHeight: 10
                        radius: 5
                        color: Vars.whiteColor
                        transform: [
                        Translate {
                            y: -Math.min(item.width, item.height) * 0.5 + 5
                        },
                        Rotation {
                            angle: index / repeater.count * 360
                            origin.x: 5
                            origin.y: 5
                        }
                        ]
                    }
                }
            }
        }
    }

    Component.onCompleted:
    {
        if(network.hasConnection()) {
            toastMessage.close();
            xhr();
        } else {
            toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            appWindowLoader.source = "mapPage.qml";
        }
    }

    Loader
    {
        id: xmlHttpRequestLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
