//thanks to Arslan Sohail on stackoverflow for this example

package org.versalityclub;

import org.versalityclub.HttpURLCon;
import org.qtproject.qt5.android.bindings.QtService;

import android.app.Service;
import android.app.Notification;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.app.Service;
import android.content.SharedPreferences;

public class LocationService extends QtService
{
    private LocationManager _locationManager = null;
    private static final String TAG = "LocationService";
    private static final long LOCATION_INTERVAL = 3600000L; //60 minutes
    private static final long TIME_UPPER_BOUND = 2592000000L; //1 month
    private static final float LOCATION_DISTANCE = 300.0f; //300 meters
    private static final float DIST_UPPER_BOUND = 1000000.0f; //1000 kilometers

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

        public LocationListener(String provider)
        {
            Log.d(TAG, "LocationListener: " + provider);
            _lastLocation = new Location(provider);
        }

        @Override
        public void onLocationChanged(Location location)
        {
            Log.d(TAG, "onLocationChanged: " + location);

            float dist = _lastLocation.distanceTo(location);
            long time = location.getTime()-_lastLocation.getTime();

            if((dist < DIST_UPPER_BOUND && dist >= LOCATION_DISTANCE) ||
               (time < TIME_UPPER_BOUND && time >= LOCATION_INTERVAL)) {
                HttpURLCon.sendCoords(LocationToString(location), getApplicationContext());
            }

            HttpURLCon.sendLog("dist. delta: "+Float.toString(dist), getApplicationContext());
            HttpURLCon.sendLog("time delta: "+Long.toString(time), getApplicationContext());

            _lastLocation.set(location);
            _lastLocation.setTime(location.getTime());
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

    LocationListener[] _locationListeners = new LocationListener[] {
        new LocationListener(LocationManager.GPS_PROVIDER),
        new LocationListener(LocationManager.NETWORK_PROVIDER)
    };

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
            _locationManager.requestLocationUpdates(
                    LocationManager.NETWORK_PROVIDER, LOCATION_INTERVAL,
                    LOCATION_DISTANCE, _locationListeners[1]);
            Log.d(TAG, "onCreate: requestLocationUpdates NETWORK_PROVIDER");
        } catch (java.lang.SecurityException ex) {
            Log.e(TAG, "onCreate: fail to request location update, ignore", ex);
            HttpURLCon.sendLog(TAG+"::onCreate: fail to request location update from NETWORK_PROVIDER", getApplicationContext());
        } catch (IllegalArgumentException ex) {
            Log.e(TAG, "onCreate: network provider does not exist, " + ex.getMessage());
            HttpURLCon.sendLog(TAG+"::onCreate: NETWORK_PROVIDER does not exist", getApplicationContext());
        }

        try {
            _locationManager.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER, LOCATION_INTERVAL,
                    LOCATION_DISTANCE, _locationListeners[0]);
            Log.d(TAG, "onCreate: requestLocationUpdates GPS_PROVIDER");
        } catch (java.lang.SecurityException ex) {
            Log.e(TAG, "onCreate: fail to request location update, ignore", ex);
            HttpURLCon.sendLog(TAG+"::onCreate: fail to request location update from GPS_PROVIDER", getApplicationContext());
        } catch (IllegalArgumentException ex) {
            Log.e(TAG, "onCreate: gps provider does not exist " + ex.getMessage());
            HttpURLCon.sendLog(TAG+"::onCreate: GPS_PROVIDER does not exist", getApplicationContext());
        }
    }

    @Override
    public void onDestroy() {
        Log.d(TAG, "onDestroy");
        super.onDestroy();

        if (_locationManager != null) {
            for (int i = 0; i < _locationListeners.length; i++) {
                try {
                    _locationManager.removeUpdates(_locationListeners[i]);
                } catch (Exception ex) {
                    Log.e(TAG, "fail to remove location listners, ignore", ex);
                }
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
