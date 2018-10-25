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

//puts categories from JSON to model for listview
function catsJsonToListModel(catsJSON)
{
    for(var i in catsJSON)
    {
        catsModel.append({
                             "id": catsJSON[i].id,
                             "title": catsJSON[i].title,
                             "collapsed": true,
                             "subcats": []
                        });

        for(var j in catsJSON[i].subcats)
            catsModel.get(i).subcats.append({
                                                "subid": catsJSON[i].subcats[j].id,
                                                "subtitle": catsJSON[i].subcats[j].title
                                           });
    }
}

//puts promotions from JSON to model for listview
function promsJsonToListModel(promsJSON)
{
    for(var i in promsJSON)
    {
        promsModel.append({
                             "id": promsJSON[i].id,
                             "picture": promsJSON[i].picture.url,
                             "title": promsJSON[i].title,
                             "description": promsJSON[i].desc,
                             "company_logo": promsJSON[i].company_logo.url,
                             "company_name": promsJSON[i].company_name
                         });
    }
}
