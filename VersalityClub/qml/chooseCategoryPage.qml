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

//page where user chooses categories
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4

Page
{
    property string jjson: '{"index":["all"],"flux":{"all":[{"data":{"title":"boris","icon":"icon.png"}}]}}'

    id: chooseCategoryPage
    height: Style.screenHeight
    width: Style.screenWidth

    Component.onCompleted: Helper.loaded(JSON.parse(jjson))

    ListModel { id: listModel }

    ListView
    {
        id: listView
        anchors.fill: parent
        model: listModel
        delegate: Rectangle
        {
            width: parent.width
            height: 80
            Text
            {
                anchors.centerIn: parent
                text: title
            }
        }
    }

    Loader
    {
        id: chooseCategoryPageLoader
        anchors.fill: parent
    }
}
