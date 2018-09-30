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

import "." //QTBUG-34418, singletons require explicit import to load qmldir file
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Window 2.11
import org.leonman.versalityclub 1.0

ApplicationWindow
{
    id: appWindow
    visible: true
    width: Style.screenWidth
    height: Style.screenHeight
    color: Style.backgroundWhite

    UserSettings { id: userSettings }

    Loader
    {
        id: depentOnHavingTokenLoader
        anchors.fill: parent
        source: userSettings.value("userHash") === undefined ?
                                   "qml/initialPage.qml" :
                                   "qml/mapPage.qml"
    }
}
