/****************************************************************************
**
** Copyright (C) 2018 Leonid Manieiev.
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
** along with Versality. If not, see https://www.gnu.org/licenses/.
**
****************************************************************************/

package org.versalityclub;

import java.net.URL;
import java.net.URLEncoder;
import java.lang.Exception;
import java.net.HttpURLConnection;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;
import java.io.UnsupportedEncodingException;

import android.os.AsyncTask;
import android.util.Log;
import android.content.Context;


public class HttpURLCon {
    private static final String TAG = "HttpURLCon";
    private static final String sendCoordsApi =
        "https://club.versality.ru:8080/api/check?secret=";
    private static final String sendLogsApi =
        "https://club.versality.ru/api/logs?secret=";

    static String getUserHash(Context context) {
        String userHash = null;
        String userHashPath =
            context.getFilesDir().toString()+"/hash.txt";

        try {
            BufferedReader reader = new BufferedReader(
                new FileReader(new File(userHashPath)));
            userHash = reader.readLine();
            reader.close();
        } catch (Exception e) {
            if(e != null) {
                Log.e(TAG, e.getMessage());
            }
            else e.printStackTrace();
        }

        return userHash;
    }

    static void sendCoords(String coords, Context context) {
        String userHash = getUserHash(context);
        sendLog("sendCoords request: "+sendCoordsApi+userHash+coords, context);

        if(userHash != null) {
            new AsyncSend(sendCoordsApi+userHash+coords).execute();
        } else {
            Log.d(TAG, "sendCoords: userHash is null");
        }
    }

    static void sendLog(String log, Context context) {
        String userHash = getUserHash(context);
        //String userHash = "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG";

        if(userHash != null) {
            try {
                new AsyncSend(sendLogsApi+userHash+"&log="+URLEncoder.encode(log, "UTF-8")).execute();
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        } else {
            Log.d(TAG, "sendLog: userHash is null");
        }
    }

    private static class AsyncSend extends AsyncTask {
        String api;

        public AsyncSend(String api) {
            this.api = api;
        }

        @Override
        protected Object doInBackground(Object[] objects) {
            try {
                String url = api;
                //Log.d(TAG, "doInBackground: url = "+url);
                HttpURLConnection con =
                    (HttpURLConnection) new URL(url).openConnection();
                int responseCode = con.getResponseCode();
                //Log.d(TAG, "doInBackground: responseCode = "+String.valueOf(responseCode));
            } catch (Exception e) {
                Log.d(TAG, "doInBackground: faild to request "+api);
                e.printStackTrace();
            }

            return null;
        }
    }
}
