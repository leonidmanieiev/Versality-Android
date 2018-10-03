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

//coverts pixels to device-independent pixels using device dpi
function toDp(px, dpi)
{
    if(dpi < 120)
        return px;
    else return Math.round(px*(dpi/160.0));
}

//encrypts user password using xor and Base64
function encryptPassword(pass, strForXor)
{
    var result = "";

    //xor each letter of pass with letter of strForXor
    for(var i = 0; i < pass.length; i++)
        result += String.fromCharCode(strForXor.charCodeAt(i % strForXor.length)
                                                           ^ pass.charCodeAt(i));
    //encrypt xored pass using Base64
    return Qt.btoa(result);
}
