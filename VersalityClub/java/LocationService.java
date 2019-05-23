//thanks to Arslan Sohail on stackoverflow for this example

package org.versalityclub;

import org.versalityclub.HttpURLCon;
import org.qtproject.qt5.android.bindings.QtService;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;

import android.app.PendingIntent;
import android.app.AlarmManager;
import android.os.SystemClock;

public class LocationService extends QtService
{
    private LocationManager _locationManager = null;
    private static final String TAG = "LocationService";
    private static final long LOCATION_INTERVAL = 3600000L; //60 minutes
    private static final float LOCATION_DISTANCE = 200.0f; //200 meters

    public static String LocationToString(final Location location) {
        String lat = Location.convert(location.getLatitude(), Location.FORMAT_DEGREES);
        String lon = Location.convert(location.getLongitude(), Location.FORMAT_DEGREES);

        // if smartphone has RU locale, coords has ',' not '.'
        // as separator of integer and fractional parts
        lat = lat.replace(",", ".");
        lon = lon.replace(",", ".");

        return "&lat="+lat + "&lon="+lon;
    }

    public static void startLocationService(Context ctx) {
        Log.d(TAG, "from onClosing event: startLocationService");
        ctx.startService(new Intent(ctx, LocationService.class));
    }

    private class LocationListener implements android.location.LocationListener
    {
        Location _lastLocation;
        boolean _initialLocationSet;

        public LocationListener(String provider)
        {
            Log.d(TAG, "LocationListener: " + provider);
            _lastLocation = new Location(provider);
            _initialLocationSet = true;
        }

        @Override
        public void onLocationChanged(Location location)
        {
            Log.d(TAG, "onLocationChanged: " + location);

            float dist = location.distanceTo(_lastLocation);
            long time = location.getTime()-_lastLocation.getTime();

            if(_initialLocationSet == false) {
                HttpURLCon.sendCoords(LocationToString(location), getApplicationContext());
                _lastLocation.set(location);
                _lastLocation.setTime(location.getTime());
            } else {
                _initialLocationSet = false;
                HttpURLCon.sendLog("_initialLocationSet == true", getApplicationContext());
            }

            HttpURLCon.sendLog("dist. delta: "+Float.toString(dist)+" | time delta: "+Long.toString(time),
                               getApplicationContext());
        }

        @Override
        public void onProviderDisabled(String provider)
        {
            Log.d(TAG, "onProviderDisabled: " + provider);
        }

        @Override
        public void onProviderEnabled(String provider)
        {
            Log.d(TAG, "onProviderEnabled: " + provider);
        }

        @Override
        public void onStatusChanged(String provider, int status, Bundle extras)
        {
            Log.d(TAG, "onStatusChanged: " + provider);
        }
    }

    LocationListener _timeLocationListener = new LocationListener(LocationManager.NETWORK_PROVIDER);
    LocationListener _distanceLocationListener = new LocationListener(LocationManager.NETWORK_PROVIDER);

    @Override
    public IBinder onBind(Intent arg0)
    {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "onStartCommand");
        super.onStartCommand(intent, flags, startId);
        return START_STICKY;
    }

    @Override
    public void onCreate() {
        initializeLocationManager();

        try {
            // for distance > LOCATION_DISTANCE
            _locationManager.requestLocationUpdates(
                    LocationManager.NETWORK_PROVIDER, 0,
                    LOCATION_DISTANCE, _distanceLocationListener);
            // for time > LOCATION_INTERVAL
            _locationManager.requestLocationUpdates(
                    LocationManager.NETWORK_PROVIDER, LOCATION_INTERVAL,
                    0, _timeLocationListener);
            Log.d(TAG, "onCreate: requestLocationUpdates NETWORK_PROVIDER");
        } catch (java.lang.SecurityException ex) {
            Log.e(TAG, "onCreate: fail to request location update, ignore", ex);
            HttpURLCon.sendLog(TAG+"::onCreate: fail to request location update from NETWORK_PROVIDER", getApplicationContext());
        } catch (IllegalArgumentException ex) {
            Log.e(TAG, "onCreate: network provider does not exist, " + ex.getMessage());
            HttpURLCon.sendLog(TAG+"::onCreate: NETWORK_PROVIDER does not exist", getApplicationContext());
        }
    }

    @Override
    public void onDestroy() {
        Log.d(TAG, "onDestroy");
        super.onDestroy();

        if (_locationManager != null) {
            try {
                _locationManager.removeUpdates(_timeLocationListener);
                _locationManager.removeUpdates(_distanceLocationListener);
            } catch (Exception ex) {
                Log.e(TAG, "fail to remove time location listners, ignore", ex);
            }
        }
    }

    private void initializeLocationManager() {
        Log.d(TAG, "initializeLocationManager");
        if (_locationManager == null) {
            _locationManager = (LocationManager) getApplicationContext().getSystemService(Context.LOCATION_SERVICE);
        }
    }
}
