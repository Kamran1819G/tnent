import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpaySubscription {
  late Razorpay _razorpay;
  final Function(bool) onPaymentComplete;
  final String _subscriptionId = 'sub_Oyzmtl8PxqDSAu'; // Check this ID in your dashboard

  RazorpaySubscription({required this.onPaymentComplete}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment successful: ${response.paymentId}");
    onPaymentComplete(true);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed: ${response.message}");
    onPaymentComplete(false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void createSubscription() {
    var options = {
      'key': 'rzp_test_rnynHtgZUItQAN', // Ensure this is the correct key for the mode you're using
      'subscription_id': _subscriptionId,
      'name': 'Tnent Store Subscription',
      'description': 'Monthly Store Access',
      'prefill': {
        'contact': 'your_customer_contact', // Add contact info if available
        'email': 'your_customer_email' // Add email info if available
      },
      'external': {
        'wallets': ['paytm'] // Add/remove wallets as needed
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay checkout: $e");
    }
  }
  }