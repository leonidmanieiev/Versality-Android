//thanks to Arslan Sohail on stackoverflow for this example

package org.versalityclub;

import org.versalityclub.HttpURLCon;
import org.qtproject.qt5.android.bindings.QtService;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.app.Service;

public class LocationService extends QtService
{
    private LocationManager _locationManager = null;
    private static final String TAG = "LocationService";
    private static final int LOCATION_INTERVAL = 1800000; //30 minutes
    private static final float LOCATION_DISTANCE = 100.0f; //100 meters

    public static String LocationToString(final Location location) {
        return "&lat="+Location.convert(location.getLatitude(), Location.FORMAT_DEGREES) +
               "&lon="+Location.convert(location.getLongitude(), Location.FORMAT_DEGREES);
    }

    public static void startLocationService(Context ctx) {
        ctx.startService(new Intent(ctx, LocationService.class));
    }

    private class LocationListener implements android.location.LocationListener
    {
        Location _lastLocation;

        public LocationListener(String provider)
        {
            Log.d(TAG, "LocationListener " + provider);
            _lastLocation = new Location(provider);
        }

        @Override
        public void onLocationChanged(Location location)
        {
            Log.d(TAG, "onLocationChanged: " + location);
            _lastLocation.set(location);
            HttpURLCon.send(LocationToString(location), getApplicationContext());
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
        } catch (java.lang.SecurityException ex) {
            Log.e(TAG, "fail to request location update, ignore", ex);
        } catch (IllegalArgumentException ex) {
            Log.e(TAG, "network provider does not exist, " + ex.getMessage());
        }

        try {
            _locationManager.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER, LOCATION_INTERVAL,
                    LOCATION_DISTANCE, _locationListeners[0]);
        } catch (java.lang.SecurityException ex) {
            Log.e(TAG, "fail to request location update, ignore", ex);
        } catch (IllegalArgumentException ex) {
            Log.e(TAG, "gps provider does not exist " + ex.getMessage());
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
