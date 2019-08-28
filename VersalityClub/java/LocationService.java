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

import org.versalityclub.HttpURLCon;
import org.qtproject.qt5.android.bindings.QtService;

import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.location.Location;
import android.location.LocationManager;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;

public class LocationService extends QtService
{
    private static final String TAG = "LocationService";
    private static final long  LOCATION_INTERVAL = 60000L; // 5 minutes
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
        boolean mInitialLocationSet;

        public LocationListener(String provider)
        {
            mLastLocation = new Location(provider);
            mInitialLocationSet = true;
        }

        @Override
        public void onLocationChanged(Location location)
        {
            float dist = mLastLocation.distanceTo(location);
            long  time = location.getTime() - mLastLocation.getTime();

            if(mInitialLocationSet)
            {
                HttpURLCon.sendLog("Init location service", getApplicationContext());
                mInitialLocationSet = false;
            }
            else
            {
                HttpURLCon.sendCoords(LocationToString(location), getApplicationContext());
                HttpURLCon.sendLog("dist. delta: "+Float.toString(dist)+" | time delta: "+Long.toString(time),
                                   getApplicationContext());
            }

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
    }
}
