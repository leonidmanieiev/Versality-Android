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

//general use properties
pragma Singleton
import "."
import QtQuick 2.11
import QtQuick.Window 2.11
import "js/helpFunc.js" as Helper

QtObject
{
    //COLORS
    readonly property color backgroundWhite: "#FFFFFF"
    readonly property color backgroundBlack: "#000000"
    readonly property color toastGrey: "#76797c"
    readonly property color listViewGrey: "#e8e9ea"
    readonly property color mainPurple: "#631964"
    readonly property color errorRed: "RED"
    readonly property color activeCouponColor: "#f93738"
    readonly property color copyrightBackgroundColor: "#c4c5c6"

    //OTHERS
    readonly property int defaultRadius: 20
    readonly property real defaultOpacity: 0.8
    readonly property int defaultFontPixelSize: 15
    readonly property int defaultDay: 15
    readonly property string defaultMonth: '06'
    readonly property int defaultYear: new Date().getYear()-30

    //REGEX
    readonly property var emailRegEx: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/

    //PROMOTION CONSTANTS
    property string markedPromsData: ''
    property string allPromsData: ''
    property string previewPromData: ''
    property string fullPromData: ''

    //FOOTERBUTTONS CONSTANTS
    readonly property int footerButtonsFieldHeight: screenHeight*0.125
    readonly property int footerButtonsHeight: screenWidth*0.1
    readonly property int footerButtonsSpacing: screenWidth*0.05

    //SCREEN CONSTANTS
    readonly property int dpi: Screen.pixelDensity * 25.4
    readonly property int pageHeight: screenHeight-footerButtonsFieldHeight
    readonly property int screenHeight: Qt.platform.os === "windows" ?
                                        Helper.toDp(480, dpi) :
                                        Helper.toDp(Screen.height, dpi)
    readonly property int screenWidth: Qt.platform.os === "windows" ?
                                       Helper.toDp(320, dpi) :
                                       Helper.toDp(Screen.width, dpi)

    //LISTVIEW CONSTANTS
    readonly property int listItemRadius: 20

    //INTERTEN ACCESS FLAG          check QTBUG-40328
    property bool isConnected: Qt.platform.os === "windows" ? true : false

    //LOCATION ACCESS FLAG
    property bool isLocated: Qt.platform.os === "windows" ? true : false

    //API REQUESTS
    readonly property string userInfo: "http://patrick.ga:8080/api/user?"
    readonly property string userMarkedProms: "http://patrick.ga:8080/api/user/marked?"
    readonly property string userLogin: "http://patrick.ga:8082/api/login?"
    readonly property string userMarkProm: "http://patrick.ga:8080/api/user/mark?"
    readonly property string userUnmarkProm: "http://patrick.ga:8080/api/user/unmark?"
    readonly property string allCats: "http://patrick.ga:8080/api/categories"
    readonly property string userActivateProm: "http://patrick.ga:8080/api/user/activate?"
    readonly property string userSelectCats: "http://patrick.ga:8080/api/user/categories?"
    readonly property string userSignup: "http://patrick.ga:8082/api/register?"
    //readonly property string allProms: "http://patrick.ga:8080/api/promotions?"
    readonly property string allPromsTilesModel: "http://patrick.ga:8080/api/promos1?"
    readonly property string promPreViewModel: "http://patrick.ga:8080/api/promos2?"
    readonly property string promFullViewModel: "http://patrick.ga:8080/api/promos3?"

    //POPUP TEXT CONSTS
    readonly property string smthWentWrong: "Что-то пошло не так, попробуйте позже"
    readonly property string getCloserToProm: "Подойдите ближе к акции"
    readonly property string noSuitablePromsNearby: "Рядом нет подходящих для Вас акций"
    readonly property string noFavouriteProms: "У Вас нет избранных акций"
    readonly property string noInternetConnection: "Нет соединения с интернетом"
    readonly property string noLocationPrivileges: "Нет привилегий на получение местоположения"
    readonly property string turnOnLocationAndWait: "Включите определение местоположения и ждите закрытия popup"
    readonly property string unknownPosSrcErr: "Неизвестная ошибка PositionSource"
    readonly property string nmeaConnectionViaSocketErr: "Ошибка подключения к источнику NMEA через socket"
    readonly property string unableToGetLocation: "Невозможно получить местоположение"
    readonly property string estabLocationMethodErr: "Ошибка установки метода определения местоположения"

    //TEXT CONSTS
    readonly property string everythingIsClearStart: "Все понятно, начать работу!"
    readonly property string showOnMap: "Показать на карте"
    readonly property string showListView: "Показать в виде списка"
    readonly property string signup: "ЗАРЕГИСТРИРОВАТЬСЯ"
    readonly property string login: "ВОЙТИ"
    readonly property string email: "E-mail:"
    readonly property string emailPlaceHolder: "*****@****.**"
    readonly property string incorrectEmail: "Некорректный e-mail"
    readonly property string pass: "Пароль:"
    readonly property string more: "ПОДРОБНЕЕ"
    readonly property string backToPromsPicking: "Назад к выбору акций"
    readonly property string sex: "Пол:"
    readonly property string birthday: "Дата рождения:"
    readonly property string birthdayMask: "00.00.0000"
    readonly property string changePass: "Изменить пароль:"
    readonly property string enterNewPass: "ВВЕДИТЕ НОВЫЙ ПАРОЛЬ"
    readonly property string nameNotNecessary: "Имя (не обязательно):"
    readonly property string enterName: "ВВЕДИТЕ ИМЯ"
    readonly property string chooseCats: "Выберите категории:"
    readonly property string choose: "ВВЫБОР"
    readonly property string save: "СОХРАНИТЬ"
    readonly property string activateCoupon: "АКТИВИРОВАТЬ КУПОН"
    readonly property string closestAddress: "БЛИЖАЙШИЙ КО МНЕ АДРЕС"
    readonly property string openCompanyCard: "ОТКРЫТЬ КАРТОЧКУ КОМПАНИИ"
    readonly property string saveAndBackToSetting: "СОХРАНИТЬ\nИ ВЕРНУТЬСЯ К НАСТРОЙКАМ"
    readonly property string m_f: "М/Ж"
    readonly property string proceed: "Готово"
    readonly property string mapPageId: "mapPage"
    readonly property string promotionPageId: "promotionPage"
    readonly property string userLocationIsNAN: "user location is NaN"
}
