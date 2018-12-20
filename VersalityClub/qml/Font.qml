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

//custom fonts
import QtQuick 2.11

Item
{
    readonly property alias regular_text_alias: regular_text
    readonly property alias medium_text_alias: medium_text
    readonly property alias bold_text_alias: bold_text

    FontLoader
    {
        id: regular_text
        source: "../fonts/Qanelas_Regular.ttf"
    }

    FontLoader
    {
        id: medium_text
        source: "../fonts/Qanelas_Medium.ttf"
    }

    FontLoader
    {
        id: bold_text
        source: "../fonts/Qanelas_Bold.ttf"
    }
}
