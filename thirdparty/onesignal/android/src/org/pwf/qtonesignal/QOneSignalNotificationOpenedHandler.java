package org.pwf.qtonesignal;

import android.content.Intent;

import com.onesignal.OneSignal;
import com.onesignal.OSNotificationOpenResult;
import com.onesignal.OSNotificationAction;
import com.onesignal.OSNotification;
import com.onesignal.OSNotificationPayload;

import org.json.JSONObject;
import java.util.List;

public class QOneSignalNotificationOpenedHandler implements OneSignal.NotificationOpenedHandler {
    @Override
    public void notificationOpened(OSNotificationOpenResult result) {
        JSONObject data = result.notification.payload.additionalData;

        if (data != null) {
            String promotionId = data.optString("id");
            if(!promotionId.isEmpty()) {
                QOneSignalBinding.m_instance.notificationOpen(promotionId);
            }
        }
    }
}
