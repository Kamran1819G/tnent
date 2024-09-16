import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RazorpayService {
  late Razorpay _razorpay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double _amount = 0.0;
  Function(PaymentSuccessResponse)? _onPaymentCompleted;
  Function(PaymentFailureResponse)? _onPaymentFailed;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void setPaymentCompletedCallback(Function(PaymentSuccessResponse) callback) {
    _onPaymentCompleted = callback;
  }

  void setPaymentFailedCallback(Function(PaymentFailureResponse) callback) {
    _onPaymentFailed = callback;
  }

  Future<void> openCheckout(
      double amount,
      BuildContext context,
      String storeId,
      List<Map<String, dynamic>> items, {
        required Function(PaymentSuccessResponse) onSuccess,
        required Function(PaymentFailureResponse) onError,
      }) async {
    _amount = amount;
    _onPaymentCompleted = onSuccess;
    _onPaymentFailed = onError;

    // Fetch store details
    DocumentSnapshot storeDoc = await _firestore.collection('Stores').doc(storeId).get();
    String storeName = storeDoc['name'] ?? '';

    // Fetch customer details
    User? user = _auth.currentUser;
    DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user?.uid).get();
    String userEmail = userDoc['email'] ?? '';
    String userPhone = userDoc['phoneNumber'] ?? '';

    var options = {
      'key': 'rzp_live_L3Ffu2rDxMUBRw', // live key
      'amount': (amount * 100).toInt(),
      'name': storeName,
      'description': 'Payment for your order',
      'prefill': {'contact': userPhone, 'email': userEmail},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      onError(PaymentFailureResponse(0, 'Error opening Razorpay checkout', e.toString() as Map?));
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment successful. Payment ID: ${response.paymentId}');

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Fetch the latest order details
        QuerySnapshot orderSnapshot = await _firestore
            .collection('Orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('orderAt', descending: true)
            .limit(1)
            .get();

        if (orderSnapshot.docs.isNotEmpty) {
          DocumentSnapshot orderDoc = orderSnapshot.docs.first;
          Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;

          // Save payment details to Firestore
          await _firestore.collection('Payments').add({
            'paymentId': response.paymentId,
            'orderId': orderData['orderId'],
            'userId': user.uid,
            'storeId': orderData['storeId'],
            'amount': _amount,
            'status': 'Success',
            'timestamp': FieldValue.serverTimestamp(),
            'method': 'Razorpay',
          });

          // Update order status
          await orderDoc.reference.update({
            'payment': {
              'method': 'online',
              'status': 'Paid',
              'paymentId': response.paymentId,
            },
          });
        }

        if (_onPaymentCompleted != null) {
          _onPaymentCompleted!(response);
        }
      } catch (e) {
        print('Error saving payment details: ${e.toString()}');
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print('Payment error. Code: ${response.code}\nMessage: ${response.message}');

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Fetch the latest order details
        QuerySnapshot orderSnapshot = await _firestore
            .collection('Orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('orderAt', descending: true)
            .limit(1)
            .get();

        if (orderSnapshot.docs.isNotEmpty) {
          DocumentSnapshot orderDoc = orderSnapshot.docs.first;
          Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;

          // Save failed payment details to Firestore
          await _firestore.collection('Payments').add({
            'orderId': orderData['orderId'],
            'userId': user.uid,
            'storeId': orderData['storeId'],
            'amount': orderData['priceDetails']['price'] * orderData['quantity'],
            'status': 'Failed',
            'errorCode': response.code,
            'errorMessage': response.message,
            'timestamp': FieldValue.serverTimestamp(),
            'method': 'Razorpay',
          });
        }
        if (_onPaymentFailed != null) {
          _onPaymentFailed!(response);
        }
      } catch (e) {
        print('Error saving failed payment details: ${e.toString()}');
      }
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
  }

  void dispose() {
    _razorpay.clear();
  }
}