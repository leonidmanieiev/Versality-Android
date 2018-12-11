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

//HTTP status code decoder
function httpErrorDecoder(statusCode)
{
    var decodedError;
    switch(statusCode)
    {
        case 0: decodedError = "Server not responding."; break;
        case 400: decodedError = "Bad request."; break;
        case 403: decodedError = "Forbidden."; break;
        case 404: decodedError = "Not found."; break;
        case 408: decodedError = "Request timeout."; break;
        case 500: decodedError = "Server error."; break;
        default: decodedError = "Unknown error."; break;
    }

    return decodedError + " Try again later.";
}

//get store hours depend on day
function currStoreHours(p_store_hours)
{
    if(p_store_hours !== '')
    {
        //deserialize work hours
        var hours = p_store_hours.split(' ');
        var currDate = new Date();
        //adjust for russian locale
        var currDay = currDate.getDay()-1 == -1 ? 6 : currDate.getDay()-1;

        return hours[currDay];
    }

    return 'Not set';
}

/*****************MODELS GENERATION**************/

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
                             //"lat": promsJSON[i].lat,
                             //"lon": promsJSON[i].lon,
                             "picture": promsJSON[i].picture.url,
                             //"title": promsJSON[i].title,
                             "description": promsJSON[i].description,
                             //"is_marked": promsJSON[i].is_marked,
                             //"promo_code": promsJSON[i].promo_code,
                             //"store_hours": promsJSON[i].store_hours,
                             //"company_id": promsJSON[i].company_id,
                             //"company_name": promsJSON[i].company_name,
                             //"company_logo": promsJSON[i].company_logo.url
                         });
    }
}

//puts promotions from JSON to model for mapMarkers
function promsJsonToListModelForMap(promsJSON)
{
    for(var i in promsJSON)
    {
        promMarkersModel.append({
                                    "id": promsJSON[i].id,
                                    "lat": promsJSON[i].lat,
                                    "lon": promsJSON[i].lon,
                                    "picture": promsJSON[i].picture.url,
                                    "title": promsJSON[i].title,
                                    "description": promsJSON[i].desc,
                                    "is_marked": promsJSON[i].is_marked,
                                    "promo_code": promsJSON[i].promo_code,
                                    "store_hours": promsJSON[i].store_hours,
                                    "company_id": promsJSON[i].company_id,
                                    "company_name": promsJSON[i].company_name,
                                    "company_logo": promsJSON[i].company_logo.url
                                });
    }
}

//puts promotion info from JSON to model for markers
function promsJsonToListModelForMarkers(promJSON)
{
    for(var i in promJSON)
    {
        promsMarkersModel.append({
                                    "id": promJSON[i].id,
                                    "title": promJSON[i].title,
                                    "icon": promJSON[i].icon,
                                    "lat": promJSON[i].lat,
                                    "lon": promJSON[i].lon
                                });
    }
}

//put store info from JSON to model for promotion page
function promsJsonToListModelForPromPage(promJSON)
{
    for(var i in promJSON.stores)
    {
        storeInfoModel.append({
                                  "store_hours": promJSON.stores[i].store_hours,
                                  "s_lat": promJSON.stores[i].lat,
                                  "s_lon": promJSON.stores[i].lon
                              });
    }
}
