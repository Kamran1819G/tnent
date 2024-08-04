const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendStoreFollowNotification = functions.firestore
    .document("Users/{userId}/notifications/{notificationId}")
    .onCreate(async (snap, context) => {
      const notificationData = snap.data();
      const userId = context.params.userId;

      // Check if the notification type is 'store'
      if (notificationData.data.type === "store") {
      // Fetch the user's FCM token
        const userDoc = await admin
            .firestore()
            .collection("Users")
            .doc(userId)
            .get();
        const fcmToken = userDoc.data().fcmToken;

        if (fcmToken) {
          const payload = {
            notification: {
              title: notificationData.title,
              body: notificationData.body,
            },
            data: notificationData.data,
          };

          try {
            await admin.messaging().sendToDevice(fcmToken, payload);
            console.log("Push notification sent successfully");
          } catch (error) {
            console.error("Error sending push notification:", error);
          }
        } else {
          console.log("No FCM token for user:", userId);
        }
      } else {
        console.log("Notification type is not store");
      }
    });
