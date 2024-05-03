import 'review_model.dart';

class Purchase {
  String orderId;
  String image;
  List<Review> reviews = [];

  Purchase({
    required this.orderId,
    required this.image,
    this.reviews = const [],
  });
}