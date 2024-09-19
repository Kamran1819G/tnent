import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpaySubscription {
  late Razorpay _razorpay;
  final Function(bool) onPaymentComplete;
  final String _subscriptionId = 'sub_OywFncMHXnzWwf';

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
      'key':'rzp_live_L3Ffu2rDxMUBRw',
      'subscription_id': _subscriptionId,
      'name': 'Tnent Store Subscription',
      'description': 'Monthly Store Access',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay checkout: $e");
    }
  }
}