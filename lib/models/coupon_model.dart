class Coupon {
  String couponId;
  String couponCode;
  int couponRedeemCount;
  double discountPercentage;
  double discountValue;
  double minOrdersOverValue;
  DateTime expiry;
  String storePhid;
  String deliveryLocation;
  int validity;
  bool applicable;

  Coupon({
    required this.couponId,
    required this.couponCode,
    required this.couponRedeemCount,
    required this.discountPercentage,
    required this.discountValue,
    required this.minOrdersOverValue,
    required this.expiry,
    required this.storePhid,
    required this.deliveryLocation,
    required this.validity,
    required this.applicable,
  });
}