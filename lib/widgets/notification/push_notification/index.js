const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendOrderNotification = functions.firestore
    .document('Orders/{orderId}')
    .onCreate(async (snap, context) => {
        const newOrder = snap.data();

        // In a real app, you'd query for the store owner's FCM token here
        // For this example, we'll assume a static token
        const ownerToken = 'STORE_OWNER_FCM_TOKEN';

        const payload = {
            notification: {
                title: 'New Order',
                body: `Order #${newOrder.id} received`,
            },
            data: {
                type: 'new_order',
                id: newOrder.id,
                total: newOrder.total.toString(),
                status: newOrder.status,
            },
        };

        return admin.messaging().sendToDevice(ownerToken, payload);
    });