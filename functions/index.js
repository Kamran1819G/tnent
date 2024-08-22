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
            data: {
              ...notificationData.data,
              channelKey: "store_new_follower",
            },
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
        const storeDoc = await admin.firestore().collection("Stores").doc(storeId).get();
        const ownerId = storeDoc.data().ownerId;
        const userDoc = await admin.firestore().collection("Users").doc(ownerId).get();
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
              channelKey: "store_new_order_channel",
            },
            android: {
              notification: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                priority: "high",
                default_sound: true,
                default_vibrate_timings: true,
                notification_priority: "PRIORITY_MAX",
                buttons: [
                  {
                    title: "Accept",
                    action: "accept",
                  },
                  {
                    title: "Reject",
                    action: "reject",
                  },
                ],
              },
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

// New function to handle order status updates
exports.handleOrderStatusUpdate = functions.firestore
    .document("Orders/{orderId}")
    .onUpdate(async (change, context) => {
      const newValue = change.after.data();
      const previousValue = change.before.data();

      if (newValue.status !== previousValue.status) {
        const orderId = context.params.orderId;
        const userId = newValue.userId;

        const userDoc = await admin.firestore().collection("Users").doc(userId).get();
        const fcmToken = userDoc.data().fcmToken;

        if (fcmToken) {
          const message = {
            token: fcmToken,
            notification: {
              title: `Order #${orderId} ${newValue.status}`,
              body: `Your order has been ${newValue.status} by the store.`,
            },
            data: {
              orderId: orderId,
              status: newValue.status,
              channelKey: "user_order_channel",
            },
          };

          await getMessaging().send(message);
          console.log("Order status notification sent successfully to customer");
        } else {
          console.log("No FCM token for customer:", userId);
        }
      }
    });

exports.sendOrderCancelledNotificationToStoreOwner = functions.firestore
    .document("Orders/{orderId}")
    .onUpdate(async (change, context) => {
      const orderData = change.after.data();
      const storeId = orderData.storeId;
      const orderId = orderData.orderId;
      const status = orderData.status;

      if (status === "cancelled") {
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
                title: "Order Cancelled",
                body: `Order #${orderId} has been cancelled.`,
              },
              data: {
                orderId: orderId,
                storeId: storeId,
                channelKey: "store_order_cancelled_channel",
              },
            };

            await getMessaging().send(message);
            console.log(
                "Order cancelled notification sent successfully to store owner",
            );
          } else {
            console.log("No FCM token for store owner:", ownerId);
          }
        } catch (error) {
          console.error("Error sending order cancelled notification:", error);
        }
      }
    });
