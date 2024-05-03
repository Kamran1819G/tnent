import 'parcel_details_model.dart';

class MiddlemanStatus {
  String orderId;
  String deliveryId;
  String pickupLocation;
  String shipmentLocation;
  List<ParcelDetails> parcelDetails;
  double deliveryCharge;
  String pickupStoreName;
  bool isAccepted;
  DateTime? timeStampOfOrderPlaced;

  MiddlemanStatus({
    required this.orderId,
    required this.deliveryId,
    required this.pickupLocation,
    required this.shipmentLocation,
    required this.parcelDetails,
    required this.deliveryCharge,
    required this.pickupStoreName,
    required this.isAccepted,
    this.timeStampOfOrderPlaced,
  });
}