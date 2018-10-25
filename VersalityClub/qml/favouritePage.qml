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

//favourites promotions in list view
import "../"
import QtQuick 2.11
import QtQuick.Controls 2.4

Page
{
    id: favouritePage
    height: Style.pageHeight
    width: Style.screenWidth
    anchors.top: parent.top

    background: Rectangle
    {
        id: pageBackground
        height: Style.pageHeight
        width: Style.screenWidth
        color: Style.mainPurple
    }

    FooterButtons { pressedFromPageName: 'favouritePage.qml' }
}
