import 'package:cloud_firestore/cloud_firestore.dart';

class ProductVariant {
  final double discount;
  final double mrp;
  final double price;
  final int stockQuantity;
  final String? sku;

  ProductVariant({
    required this.discount,
    required this.mrp,
    required this.price,
    required this.stockQuantity,
    this.sku,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> data) {
    return ProductVariant(
      price: data['price'].toDouble(),
      mrp: data['mrp'].toDouble(),
      discount: data['discount']?.toDouble() ?? 0,
      stockQuantity: data['stockQuantity'],
      sku: data['sku'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'mrp': mrp,
      'discount': discount,
      'stockQuantity': stockQuantity,
      'sku': sku,
    };
  }
}

class ProductModel {
  final String productId;
  final String storeId;
  final String name;
  final String description;
  final String productCategory;
  final String storeCategory;
  final List<String> imageUrls;
  final bool isAvailable;
  final Timestamp createdAt;
  final int greenFlags;
  final int redFlags;
  final Map<String, Map<String, ProductVariant>> variations;
  final List<String> reviewsIds;

  ProductModel({
    required this.productId,
    required this.storeId,
    required this.name,
    required this.description,
    required this.productCategory,
    required this.storeCategory,
    required this.imageUrls,
    required this.isAvailable,
    required this.createdAt,
    required this.greenFlags,
    required this.redFlags,
    required this.variations,
    this.reviewsIds = const [],
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Map<String, Map<String, ProductVariant>> variations = {};

    (data['variations'] as Map<String, dynamic>).forEach((variationType, variantData) {
      variations[variationType] = (variantData as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, ProductVariant.fromMap(value as Map<String, dynamic>))
      );
    });

    return ProductModel(
      productId: doc.id,
      storeId: data['storeId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      productCategory: data['productCategory'] ?? '',
      storeCategory: data['storeCategory'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isAvailable: data['isAvailable'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      greenFlags: data['greenFlags'] ?? 0,
      redFlags: data['redFlags'] ?? 0,
      variations: variations,
      reviewsIds: List<String>.from(data['reviewsIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> variationsMap = {};
    variations.forEach((variationType, variantMap) {
      variationsMap[variationType] = variantMap.map((key, value) => MapEntry(key, value.toMap()));
    });

    return {
      'storeId': storeId,
      'name': name,
      'description': description,
      'productCategory': productCategory,
      'storeCategory': storeCategory,
      'imageUrls': imageUrls,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'greenFlags': greenFlags,
      'redFlags': redFlags,
      'variations': variationsMap,
      'reviewsIds': reviewsIds,
    };
  }
}

/*
ProductModel(
  id: FirebaseFirestore.instance.collection('products').doc().id,
  storeId: 'store123',
  name: 'Premium Cotton T-Shirt',
  description: 'A high-quality, comfortable cotton t-shirt',
  productCategory: 'T-Shirts',
  storeCategory: 'Apparel',
  imageUrls: ['https://example.com/tshirt1.jpg', 'https://example.com/tshirt2.jpg'],
  isAvailable: true,
  createdAt: Timestamp.now(),
  badReviews: 0,
  goodReviews: 0,
  variations: {
      'size': {
         'S': ProductVariant(
          id: 'S',
          price: 24.99,
          mrp: 29.99,
          discount: 16.67,
          stockQuantity: 50,
          sku: 'TS-S',
        ),
        'M': ProductVariant(
          id: 'M',
          price: 24.99,
          mrp: 29.99,
          discount: 16.67,
          stockQuantity: 100,
          sku: 'TS-M',
      ),
      'L': ProductVariant(
        id: 'L',
        price: 26.99,
        mrp: 31.99,
        discount: 15.63,
        stockQuantity: 75,
        sku: 'TS-L',
      ),
    },
    'color': {
        'Blue': ProductVariant(
          id: 'Blue',
          price: 24.99,
          mrp: 29.99,
          discount: 16.67,
          stockQuantity: 100,
          sku: 'TS-BLU',
        ),
      'Red': ProductVariant(
        id: 'Red',
        price: 26.99,
        mrp: 31.99,
        discount: 15.63,
        stockQuantity: 75,
        sku: 'TS-RED',
      ),
   },
  },
 )'
*/
