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

import org.qtproject.qt5.android.bindings.QtService;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.os.Build;
import android.os.IBinder;
import android.os.Looper;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

public class LocationService extends QtService
{
    private static final String PACKAGE_NAME     = "org.versalityclub";
    private static final String TAG              = LocationService.class.getSimpleName();
    private static final String ACTION_BROADCAST = PACKAGE_NAME + ".broadcast";
    private static final String EXTRA_LOCATION   = PACKAGE_NAME + ".location";
    private static final String CHANNEL_ID       = "LocationServiceChannel";

    private static boolean isServiceRunning = false;

    private static final long UPDATE_INTERVAL         = 300000;
    private static final long FASTEST_UPDATE_INTERVAL = UPDATE_INTERVAL / 2;
    private static final int  NOTIFICATION_ID         = 12345678;

    private LocationRequest             mLocationRequest;
    private FusedLocationProviderClient mFusedLocationClient;
    private LocationCallback            mLocationCallback;
    private Location                    mLocation;

    private Thread.UncaughtExceptionHandler defaultUEH;
    private Thread.UncaughtExceptionHandler uncaughtExceptionHandler =
        new Thread.UncaughtExceptionHandler() {
            @Override
            public void uncaughtException(Thread thread, Throwable ex)
            {
                Log.d(TAG, "Uncaught exception");
                HttpURLCon.sendLog(TAG+": Uncaught exception", getApplicationContext());
                ex.printStackTrace();

                forceRestartLocationService();
                System.exit(2);
            }
        };

    @Override
    public void onCreate() {
        Log.d(TAG, "onCreate");
        HttpURLCon.sendLog(TAG+": onCreate", getApplicationContext());

        super.onCreate();
        startServiceWithNotification();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "onStartCommand");
        HttpURLCon.sendLog(TAG+": onStartCommand", getApplicationContext());

        if (intent != null) {
            startServiceWithNotification();
        } else {
            stopServiceWithNotification();
        }

        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        Log.d(TAG, "onDestroy");
        HttpURLCon.sendLog(TAG+": onDestroy", getApplicationContext());

        isServiceRunning = false;
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onTaskRemoved(Intent rootIntent)
    {
        Log.d(TAG, "onTaskRemoved");
        HttpURLCon.sendLog(TAG+": onTaskRemoved", getApplicationContext());

        super.onTaskRemoved(rootIntent);
        isServiceRunning = false;
        forceRestartLocationService();
    }

    private void forceRestartLocationService() {
        PendingIntent service = PendingIntent.getService(getApplicationContext(), 1001,
                                                         new Intent(getApplicationContext(), LocationService.class),
                                                         PendingIntent.FLAG_ONE_SHOT);
        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        alarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, 1000, service);
    }

    private void startServiceWithNotification() {
        Log.d(TAG, "startServiceWithNotification");
        HttpURLCon.sendLog(TAG+": startServiceWithNotification", getApplicationContext());

        if (isServiceRunning) {
            Log.d(TAG, "service already started");
            HttpURLCon.sendLog(TAG+": service already started", getApplicationContext());

            return;
        } else {
            Log.d(TAG, "service not started yet");
            HttpURLCon.sendLog(TAG+": service not started yet", getApplicationContext());

            isServiceRunning = true;
        }

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        mLocationCallback = new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                super.onLocationResult(locationResult);
                onNewLocation(locationResult.getLastLocation());
            }
        };

        createLocationRequest();
        getLastLocation();

        try {
            Log.d(TAG, "try requestLocationUpdates");
            HttpURLCon.sendLog(TAG+": try requestLocationUpdates", getApplicationContext());

            mFusedLocationClient.requestLocationUpdates(mLocationRequest, mLocationCallback, Looper.myLooper());
        } catch (SecurityException unlikely) {
            Log.e(TAG, "Lost location permission. Could not request updates. " + unlikely);
            HttpURLCon.sendLog(TAG+": Lost location permission. Could not request updates", getApplicationContext());
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel();
        }

        // opens app when tap notification
        Intent notificationIntent = new Intent(this, CustomAppActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this)
                .setContentTitle("Сервис геолокации")
                .setContentText("Для уведомлений об акциях поблизости.")
                .setSmallIcon(R.drawable.ic_stat_onesignal_default)
                .setContentIntent(pendingIntent)
                .setPriority(Notification.PRIORITY_HIGH)
                .setOngoing(true);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder.setChannelId(CHANNEL_ID);
        }

        startForeground(NOTIFICATION_ID, builder.build());
    }

    private void stopServiceWithNotification() {
        Log.d(TAG, "stopServiceWithNotification");
        HttpURLCon.sendLog(TAG+": stopServiceWithNotification", getApplicationContext());

        try {
            Log.d(TAG, "try removeLocationUpdates");
            HttpURLCon.sendLog(TAG+": try removeLocationUpdates", getApplicationContext());

            mFusedLocationClient.removeLocationUpdates(mLocationCallback);
        } catch (SecurityException unlikely) {
            Log.e(TAG, "Lost location permission. Could not remove updates. " + unlikely);
            HttpURLCon.sendLog(TAG+": Lost location permission. Could not remove updates", getApplicationContext());
        }

        stopSelf();
        isServiceRunning = false;
    }

    private void createNotificationChannel() {
        Log.d(TAG, "createNotificationChannel");
        HttpURLCon.sendLog(TAG+": createNotificationChannel", getApplicationContext());

        CharSequence name = "Location Updates ForegroundService";
        NotificationChannel serviceChannel =
            new NotificationChannel(CHANNEL_ID, name, NotificationManager.IMPORTANCE_DEFAULT);

        NotificationManager manager = getSystemService(NotificationManager.class);
        manager.createNotificationChannel(serviceChannel);
    }

    public static String LocationToString(final Location location)
    {
        String lat = Location.convert(location.getLatitude(), Location.FORMAT_DEGREES);
        String lon = Location.convert(location.getLongitude(), Location.FORMAT_DEGREES);

        // if smartphone has RU locale, coords has ',' not '.'
        // as separator of integer and fractional parts
        lat = lat.replace(",", ".");
        lon = lon.replace(",", ".");

        return "&lat="+lat + "&lon="+lon;
    }

    private void onNewLocation(Location location) {
        Log.d(TAG, "New location: " + location);
        HttpURLCon.sendCoords(LocationToString(location), getApplicationContext());

        mLocation = location;

        // Notify anyone listening for broadcasts about the new location.
        Intent intent = new Intent(ACTION_BROADCAST);
        intent.putExtra(EXTRA_LOCATION, location);
        LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(intent);
    }

    private void createLocationRequest() {
        Log.d(TAG, "createLocationRequest");
        HttpURLCon.sendLog(TAG+": createLocationRequest", getApplicationContext());

        mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(UPDATE_INTERVAL);
        mLocationRequest.setFastestInterval(FASTEST_UPDATE_INTERVAL);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    }

    private void getLastLocation() {
        try {
            Log.d(TAG, "try getLastLocation");
            HttpURLCon.sendLog(TAG+": try getLastLocation", getApplicationContext());

            mFusedLocationClient.getLastLocation()
                    .addOnCompleteListener(new OnCompleteListener<Location>() {
                        @Override
                        public void onComplete(Task<Location> task) {
                            if (task.isSuccessful() && task.getResult() != null) {
                                mLocation = task.getResult();
                            } else {
                                Log.w(TAG, "Failed to get location.");
                                HttpURLCon.sendLog(TAG+": Failed to get location", getApplicationContext());
                            }
                        }
                    });
        } catch (SecurityException unlikely) {
            Log.e(TAG, "Lost location permission." + unlikely);
            HttpURLCon.sendLog(TAG+": Lost location permission", getApplicationContext());
        }
    }

    /*private static final String TAG = "LocationService";
    private static final long  LOCATION_INTERVAL = 60000L; //300000L; // 5 minutes
    private static final float LOCATION_DISTANCE = 1000.0f; //200.0f;  // 200 meters

    private LocationManager  mLocationManager = null;
    private LocationListener mLocationListenerGpsTime;
    private LocationListener mLocationListenerGpsDist;
    private LocationListener mLocationListenerNetworkTime;
    private LocationListener mLocationListenerNetworkDist;

    public static String LocationToString(final Location location)
    {
        String lat = Location.convert(location.getLatitude(), Location.FORMAT_DEGREES);
        String lon = Location.convert(location.getLongitude(), Location.FORMAT_DEGREES);

        // if smartphone has RU locale, coords has ',' not '.'
        // as separator of integer and fractional parts
        lat = lat.replace(",", ".");
        lon = lon.replace(",", ".");

        return "&lat="+lat + "&lon="+lon;
    }

    private class LocationListener implements android.location.LocationListener
    {
        private final String TAG = "LocationListener";
        private Location mLastLocation;

        public LocationListener(String provider)
        {
            mLastLocation = new Location(provider);
        }

        @Override
        public void onLocationChanged(Location location)
        {
            float dist = mLastLocation.distanceTo(location);
            long  time = location.getTime() - mLastLocation.getTime();

            HttpURLCon.sendCoords(LocationToString(location), getApplicationContext());
            HttpURLCon.sendLog("dist. delta: "+Float.toString(dist)+" | time delta: "+Long.toString(time),
                               getApplicationContext());

            mLastLocation = location;
            Log.i(TAG, "LocationChanged: "+location);
        }

        @Override
        public void onProviderDisabled(String provider)
        {
            Log.e(TAG, "onProviderDisabled: " + provider);
        }

        @Override
        public void onProviderEnabled(String provider)
        {
            Log.e(TAG, "onProviderEnabled: " + provider);
        }

        @Override
        public void onStatusChanged(String provider, int status, Bundle extras)
        {
            Log.e(TAG, "onStatusChanged: " + status);
        }
    }

    @Override
    public IBinder onBind(Intent intent)
    {
        return null;
    }

    private void initLocationManager()
    {
        Log.d(TAG, "initLocationManager");
        if (mLocationManager == null) {
            mLocationManager = (LocationManager) getApplicationContext().getSystemService(Context.LOCATION_SERVICE);
            mLocationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
        }
    }

    private void initLocationListener()
    {
        Log.d(TAG, "initLocationListener");
        mLocationListenerGpsTime     = new LocationListener(LocationManager.GPS_PROVIDER);
        mLocationListenerGpsDist     = new LocationListener(LocationManager.GPS_PROVIDER);
        mLocationListenerNetworkTime = new LocationListener(LocationManager.NETWORK_PROVIDER);
        mLocationListenerNetworkDist = new LocationListener(LocationManager.NETWORK_PROVIDER);
    }

    private void startListening()
    {
        Log.d(TAG, "startListening");
        try {
            mLocationManager.requestLocationUpdates( LocationManager.GPS_PROVIDER, LOCATION_INTERVAL, 0.0f, mLocationListenerGpsTime );
            mLocationManager.requestLocationUpdates( LocationManager.GPS_PROVIDER, 0, LOCATION_DISTANCE, mLocationListenerGpsDist    );
        } catch (java.lang.SecurityException ex) {
            Log.e(TAG, "gps - fail to request location update, ignore", ex);
        } catch (IllegalArgumentException ex) {
            Log.e(TAG, "gps - provider does not exist " + ex.getMessage());
        }

        try {
            mLocationManager.requestLocationUpdates( LocationManager.NETWORK_PROVIDER, LOCATION_INTERVAL, 0.0f, mLocationListenerNetworkTime );
            mLocationManager.requestLocationUpdates( LocationManager.NETWORK_PROVIDER, 0, LOCATION_DISTANCE, mLocationListenerNetworkDist    );
        } catch (java.lang.SecurityException ex) {
            Log.e(TAG, "network - fail to request location update, ignore", ex);
        } catch (IllegalArgumentException ex) {
            Log.e(TAG, "network - provider does not exist " + ex.getMessage());
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId)
    {
        Log.d(TAG, "onStartCommand");
        super.onStartCommand(intent, flags, startId);
        return START_STICKY;
    }

    @Override
    public void onCreate()
    {
        Log.d(TAG, "onCreate");
        initLocationManager();
        initLocationListener();
        startListening();
    }

    @Override
    public void onDestroy()
    {
        super.onDestroy();
        if (mLocationManager != null) {
            try {
                //mLocationManager.removeUpdates(mLocationListenerGpsTime);
                //mLocationManager.removeUpdates(mLocationListenerGpsDist);
                //mLocationManager.removeUpdates(mLocationListenerNetworkTime);
                //mLocationManager.removeUpdates(mLocationListenerNetworkDist);
            } catch (Exception ex) {
                Log.i(TAG, "fail to remove location listners, ignore", ex);
            }
        }
    }*/
}
