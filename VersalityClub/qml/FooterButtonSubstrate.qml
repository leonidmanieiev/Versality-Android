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

//template for FooterButtons substrate
import "../"
import QtQuick 2.11

Image
{
    z: -1
    clip: true
    visible: false
    anchors.centerIn: parent
    width: Vars.footerButtonsHeight*1.3
    height: Vars.footerButtonsHeight*1.3
    fillMode: Image.PreserveAspectFit
    source: "../icons/footer_button_substrate.png"
}
