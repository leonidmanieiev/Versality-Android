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
** along with Foobar.  If not, see https://www.gnu.org/licenses/.
**
****************************************************************************/

package org.versalityclub;

import java.net.URL;
import java.lang.Exception;
import java.net.HttpURLConnection;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;

import android.os.AsyncTask;
import android.util.Log;
import android.content.Context;


public class HttpURLCon {
    private static final String TAG = "HttpURLCon";
    private static final String server =
        "http://muffin-ti.me/php/append-get.php?data=";

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
            if(e != null)
                Log.e(TAG, e.getMessage());
            else e.printStackTrace();
        }

        return userHash;
    }

    static void send(String s, Context context) {
        String userHash = getUserHash(context);

        if(userHash != null)
            new AsyncSend(s+"_"+userHash).execute();
        else Log.e(TAG, "userHash is null");
    }

    private static class AsyncSend extends AsyncTask {
        String data;

        public AsyncSend(String data) {
            this.data = data;
        }

        @Override
        protected Object doInBackground(Object[] objects) {
         try {
            String url = server+data;
            HttpURLConnection con =
                (HttpURLConnection) new URL(url).openConnection();
            int responseCode = con.getResponseCode();
            Log.d(TAG, "Response Code : " + responseCode);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
      }
    }
}
