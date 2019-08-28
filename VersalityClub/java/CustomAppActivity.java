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
import android.os.Build;
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
import android.content.SharedPreferences;

public class CustomAppActivity extends org.qtproject.qt5.android.bindings.QtActivity {

    private static final String TAG = "CustomAppActivity";
    private static final String IF_YOU_WANT_PUSH =
        "Если Вы хотите получать уведомления об акциях поблизости, ";
    private static final String IN_PHONE_SETTINGS = "в настройках телефона.";
    private static final String PERMISSION_VIA_SETTINGS_MESSAGE =
        IF_YOU_WANT_PUSH + "разрешите приложению доступ к Вашей геопозиции " + IN_PHONE_SETTINGS;
    private static final String LOCATION_VIA_SETTINGS_MESSAGE =
        IF_YOU_WANT_PUSH + "включите геопозицию " + IN_PHONE_SETTINGS;
    private static final String FUNCTION_ACCESS_GRANT_PERMISSION_MESSAGE =
        "Для доступа к этой функции приложения разрешите доступ к Вашей геопозиции.";
    private static final String FUNCTION_ACCESS_GRANT_PERMISSION_NEVER_MESSAGE =
        "Для доступа к этой функции приложения разрешите доступ к Вашей геопозиции " + IN_PHONE_SETTINGS;
    private static final String FUNCTION_ACCESS_ENABLE_LOCATION_MESSAGE =
        "Для доступа к этой функции приложения включите геопозицию.";
    private static final int LOCATION_PERMISSIONS_REQUEST_CODE = 111;

    private AlertDialog locationDialog = null;
    private AlertDialog batterySavingDialog = null;
    private boolean askForPermission = true;
    private boolean dontAskAfterDenie = false;
    private boolean chinaBrand = false;
    private boolean userOpenedSettings = false;

    private static final String XIAOMI_BATTERY_SAVING_MESSAGE =
        IF_YOU_WANT_PUSH + "включите «автозапуск» приложения " + IN_PHONE_SETTINGS;
    private static final String SAMSUNG_BATTERY_SAVING_MESSAGE =
        IF_YOU_WANT_PUSH + "добавьте приложение в список «неконтролируемых приложений» " + IN_PHONE_SETTINGS;
    private static final String HUAWEI_BATTERY_SAVING_MESSAGE =
        IF_YOU_WANT_PUSH + "добавьте приложение в список «защищенных приложений» или включите «автозапуск» " + IN_PHONE_SETTINGS;

    private static final Intent[] POWERMANAGER_INTENTS = {
        new Intent().setComponent(new ComponentName("com.asus.mobilemanager","com.asus.mobilemanager.autostart.AutoStartActivity")),
        new Intent().setComponent(new ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.entry.FunctionActivity")),
        new Intent().setComponent(new ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.MainActivity")),
        new Intent().setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")),
        new Intent().setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity")),
        new Intent().setComponent(new ComponentName("com.coloros.oppoguardelf", "com.coloros.powermanager.fuelgaue.PowerSaverModeActivity")),
        new Intent().setComponent(new ComponentName("com.coloros.oppoguardelf", "com.coloros.powermanager.fuelgaue.PowerConsumptionActivity")),
        new Intent().setComponent(new ComponentName("com.coloros.oppoguardelf", "com.coloros.powermanager.fuelgaue.PowerUsageModelActivity")),
        new Intent().setComponent(new ComponentName("com.htc.pitroad", "com.htc.pitroad.landingpage.activity.LandingPageActivity")),
        new Intent().setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity")),
        new Intent().setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")),
        new Intent().setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity")),
        new Intent().setComponent(new ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager")),
        new Intent().setComponent(new ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")),
        new Intent().setComponent(new ComponentName("com.letv.android.letvsafe", "com.letv.android.letvsafe.AutobootManageActivity")),
        new Intent().setComponent(new ComponentName("com.meizu.safe", "com.meizu.safe.security.SHOW_APPSEC")),
        new Intent().setComponent(new ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")),
        new Intent().setComponent(new ComponentName("com.miui.securitycenter", "com.miui.powercenter.PowerSettings")),
        new Intent().setComponent(new ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")),
        new Intent().setComponent(new ComponentName("com.samsung.android.lool", "com.samsung.android.sm.ui.battery.BatteryActivity")),
        new Intent().setComponent(new ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"))
    };

    public boolean isChinaBrand() {
        return Build.MANUFACTURER.equalsIgnoreCase("xiaomi")  ||
               Build.MANUFACTURER.equalsIgnoreCase("honor")   ||
               Build.MANUFACTURER.equalsIgnoreCase("huawei")  ||
               Build.MANUFACTURER.equalsIgnoreCase("oppo")    ||
               Build.MANUFACTURER.equalsIgnoreCase("vivo")    ||
               Build.MANUFACTURER.equalsIgnoreCase("lenovo")  ||
               Build.MANUFACTURER.equalsIgnoreCase("oneplus") ||
               Build.MANUFACTURER.equalsIgnoreCase("coolpad") ||
               Build.MANUFACTURER.equalsIgnoreCase("zte")     ||
               Build.MANUFACTURER.equalsIgnoreCase("meizu")   ||
               Build.MANUFACTURER.equalsIgnoreCase("asus")    ||
               Build.MANUFACTURER.equalsIgnoreCase("coloros") ||
               Build.MANUFACTURER.equalsIgnoreCase("htc")     ||
               Build.MANUFACTURER.equalsIgnoreCase("iqoo")    ||
               Build.MANUFACTURER.equalsIgnoreCase("letv")    ||
               Build.MANUFACTURER.equalsIgnoreCase("miui")    ||
               Build.MANUFACTURER.equalsIgnoreCase("samsung") ||
               Build.MANUFACTURER.equalsIgnoreCase("tecno");
    }

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

        if(batterySavingDialog != null) {
            batterySavingDialog.dismiss();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        if(dontAskAfterDenie) {
            dontAskAfterDenie = false;
        } else {
            if(!isLocationEnabled()) {
                askToEnableLocationViaSettigns(LOCATION_VIA_SETTINGS_MESSAGE);
            } else if (chinaBrand || isChinaBrand()) {
                chinaBrand = true;
                Log.d(TAG, "china brand");
                askToAddAppToProtectedListViaSettigns();
            } else if(askForPermission) {
                handleLocationThing();
            }
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
                QOneSignalBinding.onCreate(this);
                startLocationService();
            }
            else
            {
                // user did not grant permission when installed app
                askForPermission = false;
                askToGrantPermissionViaSettigns(PERMISSION_VIA_SETTINGS_MESSAGE);
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
            QOneSignalBinding.onCreate(this);
            startLocationService();
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
                    QOneSignalBinding.onCreate(this);
                    startLocationService();
                }
            } else {
                // denied
                if(!dontAskAfterDenie) {
                    askForPermission = false;
                    askToGrantPermissionViaSettigns(PERMISSION_VIA_SETTINGS_MESSAGE);
                } else if (!shouldShowRequestPermissionRationale(Manifest.permission.ACCESS_FINE_LOCATION)) {
                    // denied with never ask again
                    askToGrantPermissionViaSettigns(FUNCTION_ACCESS_GRANT_PERMISSION_NEVER_MESSAGE);
                }
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

    public void askToEnableLocationViaSettigns(String message)
    {
        locationDialog = new AlertDialog.Builder(this)
                .setMessage(message)
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

    // calls from cpp to avoid crash
    public void askToEnableLocationWithLooper()
    {
        final Context context = getApplicationContext();
        Handler handler = new Handler(context.getMainLooper());
        handler.post(new Runnable() {
            @Override
            public void run() {
                askToEnableLocationViaSettigns(FUNCTION_ACCESS_ENABLE_LOCATION_MESSAGE);
            }
        });
    }

    public void askToAddAppToProtectedListViaSettigns()
    {
        SharedPreferences settings = getSharedPreferences("ProtectedApps", MODE_PRIVATE);
        boolean skipMessage = settings.getBoolean("skipProtectedAppCheck", false);

        if(!skipMessage)
        {
            Log.d(TAG, "!skipMessage");
            final SharedPreferences.Editor editor = settings.edit();

            for(Intent intent : POWERMANAGER_INTENTS)
            {
                if(getPackageManager().resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null)
                {
                    Log.d(TAG, "POWERMANAGER_INTENT FOUND");
                    String msg = HUAWEI_BATTERY_SAVING_MESSAGE;
                    final Intent final_intent = new Intent(intent);

                    if(Build.MANUFACTURER.equalsIgnoreCase("xiaomi")) {
                        msg = XIAOMI_BATTERY_SAVING_MESSAGE;
                    } else if(Build.MANUFACTURER.equalsIgnoreCase("samsung")) {
                        msg = SAMSUNG_BATTERY_SAVING_MESSAGE;
                    }

                    batterySavingDialog = new AlertDialog.Builder(this)
                        .setMessage(msg)
                        .setPositiveButton("Настройки", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                userOpenedSettings = true;
                                startActivity(final_intent);
                            }
                        })
                        .setNegativeButton("Отменить", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {

                            }
                        })
                        .create();
                    batterySavingDialog.show();

                    break;
                }
            }

            if(userOpenedSettings) {
                Log.d(TAG, "WILL NOT SHOW AGAIN");
                editor.putBoolean("skipProtectedAppCheck", true);
                editor.apply();
            }
        }
    }

    public void askToGrantPermissionViaSettigns(String message)
    {
        new AlertDialog.Builder(this)
                .setMessage(message)
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

    // calls from cpp to avoid crash
    public void askToGrantPermissionWithLooper()
    {
        final Context context = getApplicationContext();
        Handler handler = new Handler(context.getMainLooper());
        handler.post(new Runnable() {
            @Override
            public void run() {
                askToGrantPermission();
            }
        });
    }

    // calls when need permission for specific fuctionality in app
    public void askToGrantPermission()
    {
        new AlertDialog.Builder(this)
                .setMessage(FUNCTION_ACCESS_GRANT_PERMISSION_MESSAGE)
                .setPositiveButton("Продолжить", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i)
                    {
                        if(VERSION.SDK_INT >= VERSION_CODES.M) {
                            dontAskAfterDenie = true;
                            ActivityCompat.requestPermissions(CustomAppActivity.this,
                                                              new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                                                              LOCATION_PERMISSIONS_REQUEST_CODE);
                        } else {
                            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                            Uri uri = Uri.fromParts("package", getPackageName(), null);
                            intent.setData(uri);
                            startActivityForResult(intent, 0);
                        }
                    }
                })
                .setNegativeButton("Отменить", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) { }
                })
                .create()
                .show();
    }
}
