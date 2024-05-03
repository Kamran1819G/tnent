class Wishlist {
  String userId;
  String username;
  String productName;
  String productId;
  double productPricing;
  List<dynamic> arrayForWishlist = [];

  Wishlist({
    required this.userId,
    this.username = '',
    this.productName = '',
    required this.productId,
    this.productPricing = 0.0,
  });
}