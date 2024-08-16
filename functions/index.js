const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {getMessaging} = require("firebase-admin/messaging");

admin.initializeApp();

exports.sendStoreFollowNotification = functions.firestore
    .document("Users/{userId}/notifications/{notificationId}")
    .onCreate(async (snap, context) => {
      const notificationData = snap.data();
      const userId = context.params.userId;

      if (notificationData.data.type === "store") {
        const userDoc = await admin
            .firestore()
            .collection("Users")
            .doc(userId)
            .get();
        const fcmToken = userDoc.data().fcmToken;

        if (fcmToken) {
          const message = {
            token: fcmToken,
            notification: {
              title: notificationData.title,
              body: notificationData.body,
            },
            data: notificationData.data,
          };

          try {
            await getMessaging().send(message);
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

exports.sendOrderNotificationToStoreOwner = functions.firestore
    .document("Orders/{orderId}")
    .onCreate(async (snap, context) => {
      const orderData = snap.data();
      const storeId = orderData.storeId;
      const orderId = orderData.orderId;

      try {
        const storeDoc = await admin
            .firestore()
            .collection("Stores")
            .doc(storeId)
            .get();
        const ownerId = storeDoc.data().ownerId;
        const userDoc = await admin
            .firestore()
            .collection("Users")
            .doc(ownerId)
            .get();
        const fcmToken = userDoc.data().fcmToken;

        if (fcmToken) {
          const message = {
            token: fcmToken,
            notification: {
              title: "New Order Received",
              body: `You have received a new order #${orderId}.`,
            },
            data: {
              orderId: orderId,
              storeId: storeId,
            },
          };

          await getMessaging().send(message);
          console.log("Order notification sent successfully to store owner");
        } else {
          console.log("No FCM token for store owner:", ownerId);
        }
      } catch (error) {
        console.error("Error sending order notification:", error);
      }
    });
