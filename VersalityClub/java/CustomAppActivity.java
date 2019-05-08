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
** along with Versality. If not, see https://www.gnu.org/licenses/.
**
****************************************************************************/

package org.versalityclub;

import android.os.Bundle;
import android.content.Intent;
import org.pwf.qtonesignal.QOneSignalBinding;

// for permission handling
import android.widget.Toast;
import android.os.Handler;
import android.app.AlertDialog;
import android.Manifest;
import android.util.Log;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.content.pm.PackageManager;
import android.content.DialogInterface;
import android.support.v4.content.ContextCompat;
import android.support.v4.app.ActivityCompat;

public class CustomAppActivity extends org.qtproject.qt5.android.bindings.QtActivity {

    private static final String TAG = "CustomAppActivity";
    private static final String ENABLE_PERMISSION_TEXT = "Что бы пользоваться Versality, включите доступ "+
                                                         "к Вашему местоположению в настройках.";
    private static final String ALERT_TITLE = "Почему Versality запрашивает Ваше местоположение";
    private static final String ALERT_MESSAGE = "Без Ваше местоположения Versality не сможет отображать "+
                                                "релевантные именно для Вас акции и функционировать корректно. "+
                                                "\nВы уверены, что хотите запретить доступ к Вашему местоположению?";
    public static final int LOCATION_PERMISSIONS_REQUEST_CODE = 111;
    public static boolean reTry = false;

    public void showEnablePermissionToastAndExit() {

        Toast.makeText(CustomAppActivity.this, ENABLE_PERMISSION_TEXT, Toast.LENGTH_LONG).show();
        // close app, then toast disappears
        new Handler().postDelayed(new Runnable() {
          @Override
          public void run() {
              System.exit(1);
          }
        }, 3500);
    }

    public void requestLocationPermission() {
        // if user denied once"
        if (shouldShowRequestPermissionRationale(Manifest.permission.ACCESS_FINE_LOCATION)) {
            showEnablePermissionToastAndExit();
        } else {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) !=
                    PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                                                  LOCATION_PERMISSIONS_REQUEST_CODE);
            }
        }
    }

    @Override
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        // request runtime permission if API LEVEL >= 23
        if (VERSION.SDK_INT >= VERSION_CODES.M) {
            requestLocationPermission();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == LOCATION_PERMISSIONS_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // user allowed
                if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) ==
                    PackageManager.PERMISSION_GRANTED) {
                    // user allowed confirmed
                    this.startService(new Intent(this, LocationService.class));
                    QOneSignalBinding.onCreate(this);
                } else {
                    Log.d(TAG, "location permission granted NOT confirmed");
                }
            } else {
              if(reTry) {
                  // user denied, then press ask permission again, then denied
                  showEnablePermissionToastAndExit();
              } else {
                  // user denied
                  if (!shouldShowRequestPermissionRationale(Manifest.permission.ACCESS_FINE_LOCATION)) {
                      // user denied with "Never ask again"
                      showEnablePermissionToastAndExit();
                  } else {
                      // user denied without "Never ask again"
                      new AlertDialog.Builder(this)
                              .setTitle(ALERT_TITLE)
                              .setMessage(ALERT_MESSAGE)
                              .setPositiveButton("Повторить", new DialogInterface.OnClickListener() {
                                  @Override
                                  public void onClick(DialogInterface dialogInterface, int i) {
                                      reTry = true;
                                      ActivityCompat.requestPermissions(CustomAppActivity.this,
                                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                                        LOCATION_PERMISSIONS_REQUEST_CODE);
                                  }
                              })
                              .setNegativeButton("Да", new DialogInterface.OnClickListener() {
                                  @Override
                                  public void onClick(DialogInterface dialogInterface, int i) {
                                      showEnablePermissionToastAndExit();
                                 }
                              })
                              .create()
                              .show();
                    }
                }
            }
        } else {
            Log.d(TAG, "Does not received response for location permission request");
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
}
