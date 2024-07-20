import 'package:cloud_firestore/cloud_firestore.dart';

class ProductVariant {
  final String id;
  final Map<String, dynamic>? attributes; // e.g., {'size': 'M', 'color': 'Blue'}
  final double discount;
  final double mrp;
  final double price;
  final int stockQuantity;
  final String? sku;

  ProductVariant({
    required this.id,
    this.attributes,
    required this.discount,
    required this.mrp,
    required this.price,
    required this.stockQuantity,
    this.sku,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> data) {
    return ProductVariant(
      id: data['id'],
      attributes: Map<String, dynamic>.from(data['attributes']) ?? {},
      price: data['price'].toDouble(),
      mrp: data['mrp'].toDouble(),
      discount: data['discounted']?.toDouble(),
      stockQuantity: data['stockQuantity'],
      sku: data['sku'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attributes': attributes,
      'price': price,
      'mrp': mrp,
      'discounted': discount,
      'stockQuantity': stockQuantity,
      'sku': sku,
    };
  }
}

class ProductModel {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final String productCategory;
  final String storeCategory;
  final List<String> imageUrls;
  final bool isAvailable;
  final Timestamp createdAt;
  final int badReviews;
  final int goodReviews;
  final List<ProductVariant> variants;
  final Map<String, List<String>> variantOptions; // e.g., {'size': ['S', 'M', 'L'], 'color': ['Red', 'Blue']}

  ProductModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.productCategory,
    required this.storeCategory,
    required this.imageUrls,
    required this.isAvailable,
    required this.createdAt,
    required this.badReviews,
    required this.goodReviews,
    required this.variants,
    required this.variantOptions,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      storeId: data['storeId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      productCategory: data['productCategory'] ?? '',
      storeCategory: data['storeCategory'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isAvailable: data['isAvailable'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      badReviews: data['badReviews'] ?? 0,
      goodReviews: data['goodReviews'] ?? 0,
      variants: (data['variants'] as List<dynamic>?)
          ?.map((v) => ProductVariant.fromMap(v as Map<String, dynamic>))
          .toList() ?? [],
      variantOptions: (data['variantOptions'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>))
      ) ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'name': name,
      'description': description,
      'productCategory': productCategory,
      'storeCategory': storeCategory,
      'imageUrls': imageUrls,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'badReviews': badReviews,
      'goodReviews': goodReviews,
      'variants': variants.map((v) => v.toMap()).toList(),
      'variantOptions': variantOptions,
    };
  }
}
/*
// Creating a new product with variants
final newProduct = ProductModel(
  id: FirebaseFirestore.instance.collection('products').doc().id,
  storeId: 'store123',
  name: 'Premium Cotton T-Shirt',
  description: 'A high-quality, comfortable cotton t-shirt',
  category: 'T-Shirts',
  tags: ['cotton', 'comfortable', 'premium'],
  imageUrls: ['https://example.com/tshirt1.jpg', 'https://example.com/tshirt2.jpg'],
  isAvailable: true,
  createdAt: Timestamp.now(),
  updatedAt: Timestamp.now(),
  averageRating: 0,
  numberOfRatings: 0,
  variants: [
    ProductVariant(
      id: '1',
      attributes: {'size': 'S', 'color': 'Blue'},
      price: 24.99,
      mrp: 29.99,
      discountedPrice: 22.99,
      stockQuantity: 50,
      sku: 'TS-BLU-S',
    ),
    ProductVariant(
      id: '2',
      attributes: {'size': 'M', 'color': 'Blue'},
      price: 24.99,
      mrp: 29.99,
      discountedPrice: 22.99,
      stockQuantity: 100,
      sku: 'TS-BLU-M',
    ),
    ProductVariant(
      id: '3',
      attributes: {'size': 'L', 'color': 'Red'},
      price: 26.99,
      mrp: 31.99,
      discountedPrice: 24.99,
      stockQuantity: 75,
      sku: 'TS-RED-L',
    ),
  ],
  variantOptions: {
    'size': ['S', 'M', 'L'],
    'color': ['Blue', 'Red'],
  },
);

// Saving to Firestore
await FirebaseFirestore.instance.collection('products').doc(newProduct.id).set(newProduct.toFirestore());

// Updating a specific variant
Future<void> updateProductVariant(String productId, String variantId, {int? newStock, double? newPrice}) async {
  final docRef = FirebaseFirestore.instance.collection('products').doc(productId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(docRef);
    final currentProduct = ProductModel.fromFirestore(snapshot);

    final updatedVariants = currentProduct.variants.map((variant) {
      if (variant.id == variantId) {
      return ProductVariant(
      id: variant.id,
      attributes: variant.attributes,
      price: newPrice ?? variant.price,
      mrp: variant.mrp,
      discountedPrice: variant.discountedPrice,
      stockQuantity: newStock ?? variant.stockQuantity,
      sku: variant.sku,
      );
    }
    return variant;
  }).toList();

  final updatedProduct = currentProduct.copyWith(variants: updatedVariants);

  transaction.set(docRef, updatedProduct.toFirestore());
  });
}

// Querying products
Query query = FirebaseFirestore.instance.collection('products')
    .where('storeId', isEqualTo: 'store123')
    .where('category', isEqualTo: 'T-Shirts')
    .where('isAvailable', isEqualTo: true);

query.get().then((querySnapshot) {
  for (var doc in querySnapshot.docs) {
    final product = ProductModel.fromFirestore(doc);
    print('${product.name}: ${product.variants.length} variants');
  }
});*/

