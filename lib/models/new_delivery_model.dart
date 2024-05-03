import 'parcel_details_model.dart';
import 'middleman_status_model.dart';

class NewDelivery {
  String orderId;
  String deliveryId;
  String pickupLocation;
  String shipmentLocation;
  List<ParcelDetails> parcelDetails;
  String middlemanAddress;
  String documentVerification;
  MiddlemanStatus middlemanStatus;

  NewDelivery({
    required this.orderId,
    required this.deliveryId,
    required this.pickupLocation,
    required this.shipmentLocation,
    required this.parcelDetails,
    required this.middlemanAddress,
    required this.documentVerification,
    required this.middlemanStatus,
  });
}