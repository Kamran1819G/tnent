class PaymentHistory {
  DateTime timeStampOfPayment;
  double amountOfPayment;
  double totalEarnings;
  double todaysEarnings;

  PaymentHistory({
    required this.timeStampOfPayment,
    required this.amountOfPayment,
    required this.totalEarnings,
    required this.todaysEarnings,
  });
}