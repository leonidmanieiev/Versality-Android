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

//custom fonts
import QtQuick 2.11
import "../"

Item
{
    readonly property alias regular_text_alias: regular_text
    readonly property alias medium_text_alias: medium_text
    readonly property alias bold_text_alias: bold_text

    FontLoader
    {
        id: regular_text
        source: Vars.regularFont
    }

    FontLoader
    {
        id: medium_text
        source: Vars.mediumFont
    }

    FontLoader
    {
        id: bold_text
        source: Vars.boldFont
    }
}
