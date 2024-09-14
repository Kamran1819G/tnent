import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(double amount, BuildContext context) {
    var options = {
      'key': 'rzp_test_rnynHtgZUItQAN', // replace it with the live key from your Razorpay dashboard
      'amount': (amount * 100).toInt(),
      'name': 'Tnent Store',
      'description': 'Payment for your order',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment successful. Payment ID: ${response.paymentId}');
    // Handle successful payment (e.g., update order status, show confirmation)
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment error. Code: ${response.code}\nMessage: ${response.message}');
    // Handle payment failure (e.g., show error message to user)
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
  }

  void dispose() {
    _razorpay.clear();
  }
}