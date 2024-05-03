enum PaymentMethod {
  COD,
  Card,
  NetBanking,
  UPI,
  Wallet,
}

class Payment {
  String transactionId;
  double transactionAmt;
  PaymentMethod paymentMethod;
  bool isPaymentComplete;
  String gateway;

  Payment({
    required this.transactionId,
    required this.transactionAmt,
    required this.paymentMethod,
    required this.isPaymentComplete,
    this.gateway= '',
  });

  static Payment defaultPayment() {
    return Payment(
      transactionId: '',
      transactionAmt: 0.0,
      paymentMethod: PaymentMethod.COD,
      isPaymentComplete: false,
      gateway: '',
    );
  }
}
