class ParcelDetails {
  String pickupStoreName;
  double packagePrice;
  String deliveryCustomerName;
  String fromPickupStoreNumber;
  String isDeliveryCustomerNumber;
  bool isDelivered;
  bool isReturned;
  bool isCancelled;
  bool isUnavailable;
  String paymentMethod;
  bool isPaymentReceived;
  DateTime? timeStampOfOrderDeliveredReturnedCanceled;

  ParcelDetails({
    required this.pickupStoreName,
    required this.packagePrice,
    required this.deliveryCustomerName,
    required this.fromPickupStoreNumber,
    required this.isDeliveryCustomerNumber,
    required this.isDelivered,
    required this.isReturned,
    required this.isCancelled,
    required this.isUnavailable,
    required this.paymentMethod,
    required this.isPaymentReceived,
    this.timeStampOfOrderDeliveredReturnedCanceled,
  });
}