const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {getMessaging} = require("firebase-admin/messaging");
const nodemailer = require("nodemailer");

// Configure the email transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: functions.config().gmail.email,
    pass: functions.config().gmail.password,
  },
});

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
    .onWrite(async (change, context) => {
      const newOrderData = change.after.data();
      const previousOrderData = change.before.data();
      const orderId = newOrderData.orderId;

      // Function to get store owner's FCM token
      const getStoreOwnerFCMToken = async (storeId) => {
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
        return userDoc.data().fcmToken;
      };

      // Function to send notification
      const sendNotification = async (fcmToken, title, body, data) => {
        if (fcmToken) {
          const message = {
            token: fcmToken,
            notification: {title, body},
            data: {...data, orderId},
          };

          try {
            await getMessaging().send(message);
            console.log(`Notification sent successfully: ${title}`);
          } catch (error) {
            console.error(`Error sending notification: ${title}`, error);
          }
        } else {
          console.log(`No FCM token for notification: ${title}`);
        }
      };

      try {
        let notificationInfo = null;

        if (!previousOrderData && newOrderData) {
        // New order created
          notificationInfo = {
            title: "New Order Received",
            body: `You have received a new order #${orderId}.`,
            channelKey: "store_new_order_channel",
          };
        } else if (previousOrderData && newOrderData) {
        // Order status changed
          if (
            newOrderData.status.cancelled &&
          !previousOrderData.status.cancelled
          ) {
            notificationInfo = {
              title: "Order Cancelled",
              body: `Order #${orderId} has been cancelled.`,
              channelKey: "store_order_channel",
            };
          }
        // Add more status change conditions here as needed
        // Example:
        // else if (newOrderData.status.shipped && !previousOrderData.status.shipped) {
        //   notificationInfo = {
        //     title: "Order Shipped",
        //     body: `Order #${orderId} has been shipped.`,
        //     channelKey: "store_ship_order_channel",
        //   };
        // }
        }
        if (notificationInfo) {
          const storeId = newOrderData.storeId;
          const fcmToken = await getStoreOwnerFCMToken(storeId);
          await sendNotification(
              fcmToken,
              notificationInfo.title,
              notificationInfo.body,
              {
                storeId,
                channelKey: notificationInfo.channelKey,
              },
          );
        }
      } catch (error) {
        console.error("Error processing order notification:", error);
      }
    });

exports.sendWelcomeEmail = functions.firestore
    .document("Middlemens/{middlemanId}")
    .onCreate((snap, context) => {
      const newValue = snap.data();
      const middlemanId = context.params.middlemanId;

      const mailOptions = {
        from: functions.config().gmail.email,
        to: newValue.email,
        subject: "Welcome to Tnent Middleman Program",
        html: `
          <h1>Welcome to Tnent!</h1>
          <p>Your registration as a middleman has been successful.</p>
          <p>Here are your login details:</p>
          <p><strong>Middleman ID:</strong> ${middlemanId}</p>
          <p><strong>Temporary Password:</strong> ${newValue.password}</p>
          <p>Thank you for joining us!</p>
        `,
      };

      return transporter
          .sendMail(mailOptions)
          .then(() => console.log("Welcome email sent to:", newValue.email))
          .catch((error) => console.error("Error sending welcome email:", error));
    });
