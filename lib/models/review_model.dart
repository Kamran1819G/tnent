import 'payment_model.dart';

class Review {
  String storeId;
  double purchaseAmount;
  int purchaseQuantity;
  Payment payment;
  double discount;
  bool couponUsed;
  String image;

  Review({
    required this.storeId,
    this.purchaseAmount = 0.0,
    this.purchaseQuantity = 0,
    required Payment payment,
    this.discount = 0.0,
    this.couponUsed = false,
    required this.image,
  }) : payment = payment ?? Payment.defaultPayment();
}
