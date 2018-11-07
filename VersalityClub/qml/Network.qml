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

//Network information component
import "../"
import Network 1.0
import QtQuick 2.11

NetworkInfo
{
    property var toastMessage

    onNetworkStatusChanged:
    {
        //check QTBUG-40328
        if(Qt.platform.os !== "windows")
        {
            if(accessible === 1)
            {
                Style.isConnected = true;
                parent.enabled = true;
                toastMessage.close();
            }
            else
            {
                Style.isConnected = false;
                parent.enabled = false;
                toastMessage.setTextNoAutoClose(qsTr("No Internet connection"));
            }
        }
    }
}
