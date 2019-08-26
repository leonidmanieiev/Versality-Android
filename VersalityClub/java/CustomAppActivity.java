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

import org.pwf.qtonesignal.QOneSignalBinding;

import android.os.Bundle;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Handler;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.app.AlertDialog;
import android.Manifest;
import android.util.Log;
import android.widget.Toast;
import android.content.ComponentName;
import android.net.Uri;
import android.content.Context;
import android.provider.Settings;

public class CustomAppActivity extends org.qtproject.qt5.android.bindings.QtActivity {

    private static final String TAG = "CustomAppActivity";
    private static final String PERMISSION_VIA_MESSINGS =
        "Если Вы хотите получать уведомления об акциях поблизости, разрешите приложению доступ к Вашей геопозиции в настройках телефона.";
    private static final String LOCATION_VIA_MESSINGS =
        "Если Вы хотите получать уведомления об акциях поблизости, включите геопозицию в настройках телефона.";
    private static final int LOCATION_PERMISSIONS_REQUEST_CODE = 111;

    private AlertDialog locationDialog = null;
    private boolean askForPermission = true;

    public void startLocationService()
    {
        Log.d(TAG, "startLocationService");
        Intent serviceIntent = new Intent(this, LocationService.class);
        startService(serviceIntent);
    }

    @Override
    protected void onPause() {
        super.onPause();

        if(locationDialog != null) {
            locationDialog.dismiss();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        if(!isLocationEnabled()) {
            askToEnableLocationViaSettigns();
        } else if(askForPermission) {
            handleLocationThing();
        }
    }

    @Override
    public void onCreate(Bundle bundle)
    {
        super.onCreate(bundle);
    }

    public void handleLocationThing()
    {
        if(VERSION.SDK_INT >= VERSION_CODES.M)
        {
            // request permission on runtime
            requestLocationPermission();
        }
        else
        {
            if(ContextCompat.checkSelfPermission(this,
                                                 Manifest.permission.ACCESS_FINE_LOCATION) ==
                                                 PackageManager.PERMISSION_GRANTED)
            {
                // user granted permission when installed app
                //QOneSignalBinding.onCreate(this);
                //startLocationService();
            }
            else
            {
                // user did not grant permission when installed app
                askForPermission = false;
                askToGrantPermissionViaSettigns();
            }
        }
    }

    public void requestLocationPermission()
    {
        if(ContextCompat.checkSelfPermission(this,
                                             Manifest.permission.ACCESS_FINE_LOCATION) !=
                                             PackageManager.PERMISSION_GRANTED)
        {
            // not granted yet
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                                              LOCATION_PERMISSIONS_REQUEST_CODE);
        }
        else
        {
            // granted
            //QOneSignalBinding.onCreate(this);
            //startLocationService();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults)
    {
        if(requestCode == LOCATION_PERMISSIONS_REQUEST_CODE)
        {
            if(grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED)
            {
                // granted
                if(ContextCompat.checkSelfPermission(this,
                                                     Manifest.permission.ACCESS_FINE_LOCATION) ==
                                                     PackageManager.PERMISSION_GRANTED)
                {
                    // granted confirmed
                    //QOneSignalBinding.onCreate(this);
                    //startLocationService();
                }
            } else {
                // denied
                askForPermission = false;
                askToGrantPermissionViaSettigns();
            }
        }
    }

    public boolean isLocationEnabled() {
        int locationMode = 0;

        try {
            locationMode = Settings.Secure.getInt(this.getContentResolver(), Settings.Secure.LOCATION_MODE);
        } catch (Settings.SettingNotFoundException e) {
            Log.d(TAG, "isLocationEnabled::exception");
            e.printStackTrace();
        }

        return locationMode != Settings.Secure.LOCATION_MODE_OFF;
    }

    public void askToEnableLocationViaSettigns()
    {
        locationDialog = new AlertDialog.Builder(this)
                .setMessage(LOCATION_VIA_MESSINGS)
                .setPositiveButton("Настройки", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        startActivity(new Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS));
                    }
                })
                .setNegativeButton("Отменить", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {

                    }
                })
                .create();

        locationDialog.show();
    }

    public void askToGrantPermissionViaSettigns()
    {
        new AlertDialog.Builder(this)
                .setMessage(PERMISSION_VIA_MESSINGS)
                .setPositiveButton("Настройки", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                        Uri uri = Uri.fromParts("package", getPackageName(), null);
                        intent.setData(uri);
                        startActivityForResult(intent, 0);
                        askForPermission = true;
                    }
                })
                .setNegativeButton("Отменить", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        askForPermission = true;
                    }
                })
                .create()
                .show();
    }
}
