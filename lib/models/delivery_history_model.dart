class DeliveryHistory {
  int numberOfSuccessfulDeliveries;
  List<String> deliveryIdForDelivered;
  int numberOfCancelledDeliveries;
  List<String> deliveryIdForCancelled;
  int numberOfReturnedDeliveries;
  List<String> deliveryIdForReturned;

  DeliveryHistory({
    required this.numberOfSuccessfulDeliveries,
    required this.deliveryIdForDelivered,
    required this.numberOfCancelledDeliveries,
    required this.deliveryIdForCancelled,
    required this.numberOfReturnedDeliveries,
    required this.deliveryIdForReturned,
  });
}