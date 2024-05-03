
class Product {
  String productName;
  String productId; // Derive from Store ID
  double productPrice;
  int productStockQuantity;
  String productImage;
  String productDescription;
  String productCategory;
  double taxRate;
  bool featured;
  String orderOwner;


  Product({
    required this.productName,
    required this.productId,
    required this.productPrice,
    required this.productStockQuantity,
    required this.productImage,
    this.productDescription = '',
    this.productCategory = '',
    this.taxRate = 0.0,
    this.featured = false,
    this.orderOwner = '',
  });
}
