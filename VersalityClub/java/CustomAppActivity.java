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

import android.Manifest;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.PowerManager;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.util.Log;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.LinearLayout;

public class CustomAppActivity extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static final String TAG                = CustomAppActivity.class.getSimpleName();
    private static final String IF_YOU_WANT_PUSH   = "Если Вы хотите получать уведомления об акциях поблизости,";
    private static final String IN_PHONE_SETTINGS  = "в настройках телефона.";
    private static final String TO_ACCESS_FUNCTION = "Для доступа к этой функции приложения";

    private static final int    LOCATION_PERMISSIONS_REQUEST_CODE = 34;

    private static final String PERMISSION_VIA_SETTINGS_MESSAGE =
        IF_YOU_WANT_PUSH + " разрешите приложению доступ к Вашей геопозиции " + IN_PHONE_SETTINGS;

    private static final String LOCATION_VIA_SETTINGS_MESSAGE =
        IF_YOU_WANT_PUSH + " включите геопозицию " + IN_PHONE_SETTINGS;

    private static final String FUNCTION_ACCESS_GRANT_PERMISSION_MESSAGE =
        TO_ACCESS_FUNCTION + " разрешите доступ к Вашей геопозиции.";

    private static final String FUNCTION_ACCESS_GRANT_PERMISSION_NEVER_MESSAGE =
        TO_ACCESS_FUNCTION + " разрешите доступ к Вашей геопозиции " + IN_PHONE_SETTINGS;

    private static final String FUNCTION_ACCESS_ENABLE_LOCATION_MESSAGE =
        TO_ACCESS_FUNCTION + " включите геопозицию.";

    private AlertDialog locationDialog      = null;
    private AlertDialog batterySavingDialog = null;

    private boolean askForPermission   = true;
    private boolean dontAskAfterDenie  = false;
    private boolean chinaBrand         = false;

    private static final String BATTERY_SAVING_MESSAGE =
        IF_YOU_WANT_PUSH + " включите «автозапуск» " + IN_PHONE_SETTINGS;
    private static final String ONEPLUS_BATTERY_SAVING_MESSAGE =
        IF_YOU_WANT_PUSH + " отключите экономию заряда батареи для приложения Versality.\nНастройки -> Батарея -> Экономия заряда батареи -> Не экономить.";

    private static final Intent[] POWERMANAGER_INTENTS = {
        new Intent().setComponent(new ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.autostart.AutoStartActivity")),
        new Intent().setComponent(new ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.entry.FunctionActivity")).setData(
                                                                              Uri.parse("mobilemanager://function/entry/AutoStart")),
        new Intent().setComponent(new ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.MainActivity")),     
        new Intent().setComponent(new ComponentName("com.oppo.safe", "com.oppo.safe.permission.floatwindow.FloatWindowListActivity")),
        new Intent().setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.floatwindow.FloatWindowListActivity")),
        new Intent().setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.sysfloatwindow.FloatWindowListActivity")),
        new Intent().setComponent(new ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")),
        new Intent().setComponent(new ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")),
        new Intent().setComponent(new ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager")),
        new Intent().setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")),
        new Intent().setComponent(new ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")),
        new Intent().setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity")),
        new Intent().setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity")),
        new Intent().setComponent(new ComponentName("com.huawei.systemmanager", VERSION.SDK_INT >= VERSION_CODES.P ?
                                                                                "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity" :
                                                                                "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity")),
        new Intent().setComponent(new ComponentName("com.meizu.safe", "com.meizu.safe.security.SHOW_APPSEC")).addCategory(Intent.CATEGORY_DEFAULT).putExtra("packageName", BuildConfig.APPLICATION_ID),
        new Intent().setComponent(new ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")),
        new Intent().setComponent(new ComponentName(VERSION.SDK_INT >= VERSION_CODES.N ? "com.samsung.android.lool" : "com.samsung.android.sm",
                                                    "com.samsung.android.sm.ui.battery.BatteryActivity"))
    };

    public boolean isChinaBrand() {
        Log.d(TAG, "MANUFACTURER - " + Build.MANUFACTURER);
        HttpURLCon.sendLog(TAG+": MANUFACTURER - " + Build.MANUFACTURER, getApplicationContext());

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

    @Override
    protected void onPause() {
        super.onPause();
        Log.d(TAG, "onPause");

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
        Log.d(TAG, "onResume");

        if(chinaBrand || isChinaBrand()) {
            chinaBrand = true;

            if(Build.MANUFACTURER.equalsIgnoreCase("oneplus"))
            {
                String packageName = getPackageName();
                PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);

                if(!pm.isIgnoringBatteryOptimizations(packageName)) {
                    askToAddAppToProtectedListViaSettigns();
                }
            }
            else {
                askToAddAppToProtectedListViaSettigns();
            }
        }

        if(dontAskAfterDenie) {
            dontAskAfterDenie = false;
        } else {
            if(!isLocationEnabled()) {
                askToEnableLocationViaSettigns(LOCATION_VIA_SETTINGS_MESSAGE);
            } else if(askForPermission) {
                handleLocationThing();
            }
        }
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        Log.d(TAG, "onCreate");
        //HttpURLCon.sendLog(TAG+": onCreate", getApplicationContext());

        super.onCreate(savedInstanceState);
    }

    public void handleLocationThing()
    {
        if(VERSION.SDK_INT >= VERSION_CODES.M) {
            // request permission on runtime
            requestLocationPermission();
        } else {
            if(checkPermissions()) {
                Log.d(TAG, "user granted permission when installed app");
                HttpURLCon.sendLog(TAG+": user granted permission when installed app", getApplicationContext());

                QOneSignalBinding.onCreate(this);
                startLocationService();
            } else {
                Log.d(TAG, "user did not grant permission when installed app");
                HttpURLCon.sendLog(TAG+": user did not grant permission when installed app", getApplicationContext());

                askForPermission = false;
                askToGrantPermissionViaSettigns(PERMISSION_VIA_SETTINGS_MESSAGE);
            }
        }
    }

    public void startLocationService() {
        Log.d(TAG, "startService");
        HttpURLCon.sendLog(TAG+": startService", getApplicationContext());

        Intent serviceIntent = new Intent(this, LocationService.class);

        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            startForegroundService(serviceIntent);
        } else {
            startService(serviceIntent);
        }
    }

    private boolean checkPermissions() {
        Log.d(TAG, "checkPermissions");
        HttpURLCon.sendLog(TAG+": checkPermissions", getApplicationContext());

        return  PackageManager.PERMISSION_GRANTED ==
                ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION);
    }

    public void requestLocationPermission()
    {
        Log.d(TAG, "requestLocationPermission");
        HttpURLCon.sendLog(TAG+": requestLocationPermission", getApplicationContext());

        if(!checkPermissions()) {
            Log.d(TAG, "not granted yet");
            HttpURLCon.sendLog(TAG+": not granted yet", getApplicationContext());

            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                                              LOCATION_PERMISSIONS_REQUEST_CODE);
        } else {
            Log.d(TAG, "granted");
            HttpURLCon.sendLog(TAG+": granted", getApplicationContext());

            QOneSignalBinding.onCreate(this);
            startLocationService();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        Log.i(TAG, "onRequestPermissionResult");
        HttpURLCon.sendLog(TAG+": onRequestPermissionResult", getApplicationContext());

        if(requestCode == LOCATION_PERMISSIONS_REQUEST_CODE)
        {
            if(grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED)
            {
                // granted
                if(ActivityCompat.checkSelfPermission(this,
                                                     Manifest.permission.ACCESS_FINE_LOCATION) ==
                                                     PackageManager.PERMISSION_GRANTED)
                {
                    // granted confirmed
                    Log.d(TAG, "Permission was granted");
                    HttpURLCon.sendLog(TAG+": Permission was granted", getApplicationContext());

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

    // determine appropriate message depand on class name of intent
    private String determineAppropriateMessage(String className)
    {
        String msg = IF_YOU_WANT_PUSH;

        switch(className)
        {
          case "com.miui.permcenter.autostart.AutoStartManagementActivity":
            return msg + " включите «автозапуск» " + IN_PHONE_SETTINGS;
          //case "com.miui.permcenter.permissions.PermissionsEditorActivity":
          //case "com.miui.permcenter.permissions.AppPermissionsEditorActivity":
            //return msg + " включите «без ограничений» " + IN_PHONE_SETTINGS;
          case "com.huawei.systemmanager.optimize.process.ProtectActivity":
            return msg + " добавьте приложение в список «защищенных приложений» " + IN_PHONE_SETTINGS;
          case "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity":
          case "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity":
            return msg + " отключите «автоматическое управление» и включите все три предложенных опции:" +
                         " «автозапуск», «косвенный запуск» и «работа в фоновом режиме» " + IN_PHONE_SETTINGS;
          case "com.meizu.safe.security.SHOW_APPSEC":
            return msg + " разрешите приложению работать в фоновом режиме " + IN_PHONE_SETTINGS;
          case "com.samsung.android.sm.ui.battery.BatteryActivity":
            return msg + " уберите приложение из «спящего режима» и добавьте его в «список исключений» " + IN_PHONE_SETTINGS;
          case "com.asus.mobilemanager.autostart.AutoStartActivity":
          case "com.asus.mobilemanager.entry.FunctionActivity":
          case "com.asus.mobilemanager.MainActivity":
            return msg + " разрешите «автозапуск» " + IN_PHONE_SETTINGS;
          case "com.oppo.safe.permission.floatwindow.FloatWindowListActivity":
          case "com.coloros.safecenter.permission.floatwindow.FloatWindowListActivity":
          case "com.coloros.safecenter.sysfloatwindow.FloatWindowListActivity":
            return msg + " разрешите всплывающие окна " + IN_PHONE_SETTINGS;
          case "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity":
          case "com.vivo.permissionmanager.activity.BgStartUpManagerActivity":
          case "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager":
          case "com.coloros.safecenter.permission.startup.StartupAppListActivity":
          case "com.oppo.safe.permission.startup.StartupAppListActivity":
          case "com.coloros.safecenter.startupapp.StartupAppListActivity":
            return msg + " разрешите «автозапуск» " + IN_PHONE_SETTINGS;
          default:
            return BATTERY_SAVING_MESSAGE;
        }
    }

    // for china phones
    public void askToAddAppToProtectedListViaSettigns()
    {
        Log.d(TAG, "askToAddAppToProtectedListViaSettigns");
        HttpURLCon.sendLog(TAG+": askToAddAppToProtectedListViaSettigns", getApplicationContext());

        final SharedPreferences settings = getSharedPreferences("ProtectedApps", MODE_PRIVATE);
        final SharedPreferences.Editor editor = settings.edit();

        boolean firstShow = settings.getBoolean("firstShow", true);
        boolean skipMessage = settings.getBoolean("skipMessage", false);
        int intentIndex = settings.getInt("intentIndex", 0);

        if(Build.MANUFACTURER.equalsIgnoreCase("oneplus"))
        {
            batterySavingDialog = new AlertDialog.Builder(this)
                .setMessage(ONEPLUS_BATTERY_SAVING_MESSAGE)
                .setPositiveButton("Настройки", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        startActivity(new Intent(android.provider.Settings.ACTION_SETTINGS));
                    }
                })
                .setNegativeButton("Отменить", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                    }
                })
                .create();
            batterySavingDialog.show();
        }
        else if(intentIndex < POWERMANAGER_INTENTS.length)
        {
            if(!skipMessage) {
                Log.d(TAG, "more intents or user did not check checkbox");
                HttpURLCon.sendLog(TAG+": more intents or user did not check checkbox", getApplicationContext());

                CheckBox checkBox = new CheckBox(this);
                checkBox.setText("Я все сделал");
                checkBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                        editor.putBoolean("skipMessage", isChecked);
                        editor.apply();

                        if(isChecked) batterySavingDialog.dismiss();
                    }
                });

                LinearLayout linearLayout = new LinearLayout(this);
                linearLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT,
                                                                           LinearLayout.LayoutParams.FILL_PARENT));
                linearLayout.setOrientation(1);
                linearLayout.addView(checkBox);

                for(int i = intentIndex; i < POWERMANAGER_INTENTS.length; i++)
                {
                    if(getPackageManager().resolveActivity(POWERMANAGER_INTENTS[i],
                                                           PackageManager.MATCH_DEFAULT_ONLY) != null)
                    {
                        final Intent final_intent = new Intent(POWERMANAGER_INTENTS[i]);
                        String msg = determineAppropriateMessage(final_intent.getComponent().getClassName());

                        String si = "" + i;
                        Log.d(TAG, "intentIndex"+si);
                        HttpURLCon.sendLog(TAG+": intentIndex"+si, getApplicationContext());

                        Log.d(TAG, "POWERMANAGER_INTENT FOUND. INDEX: " + si);
                        HttpURLCon.sendLog(TAG+": POWERMANAGER_INTENT FOUND. INDEX: "+si, getApplicationContext());

                        Log.d(TAG, "msg: " + msg);
                        HttpURLCon.sendLog(TAG+": msg: "+msg, getApplicationContext());

                        if(firstShow) {
                            // show without "do not show again" checkbox
                            batterySavingDialog = new AlertDialog.Builder(this)
                                .setMessage(msg)
                                .setPositiveButton("Настройки", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialogInterface, int i) {
                                        // i+1 to skip this intent on next iteration
                                        editor.putInt("intentIndex", i+1);
                                        editor.putBoolean("firstShow", false);
                                        editor.apply();

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
                        } else {
                            // show with "do not show again" checkbox
                            batterySavingDialog = new AlertDialog.Builder(this)
                                .setMessage(msg)
                                .setView(linearLayout)
                                .setPositiveButton("Настройки", new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialogInterface, int i) {
                                        // i+1 to skip this intent on next iteration
                                        editor.putInt("intentIndex", i+1);
                                        editor.apply();

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
                        }

                        break;
                    }
                }
            } else {
                editor.putBoolean("skipMessage", true);
                editor.apply();
            }
        } else {
            Log.d(TAG, "All POWERMANAGER_INTENTs were discovered");
            HttpURLCon.sendLog(TAG+": All POWERMANAGER_INTENTs were discovered", getApplicationContext());
        }
    }
}
