import 'package:cloud_firestore/cloud_firestore.dart';

class ProductVariant {
  final String id;
  final Map<String, dynamic> attributes; // e.g., {'size': 'M', 'color': 'Blue'}
  final double price;
  final double mrp;
  final double? discountedPrice;
  final int stockQuantity;
  final String? sku;

  ProductVariant({
    required this.id,
    required this.attributes,
    required this.price,
    required this.mrp,
    this.discountedPrice,
    required this.stockQuantity,
    this.sku,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> data) {
    return ProductVariant(
      id: data['id'],
      attributes: Map<String, dynamic>.from(data['attributes']),
      price: data['price'].toDouble(),
      mrp: data['mrp'].toDouble(),
      discountedPrice: data['discountedPrice']?.toDouble(),
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
      'discountedPrice': discountedPrice,
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
  final String category;
  final List<String> tags;
  final List<String> imageUrls;
  final bool isAvailable;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final double averageRating;
  final int numberOfRatings;
  final List<ProductVariant> variants;
  final Map<String, List<String>> variantOptions; // e.g., {'size': ['S', 'M', 'L'], 'color': ['Red', 'Blue']}

  ProductModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.category,
    required this.tags,
    required this.imageUrls,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
    required this.averageRating,
    required this.numberOfRatings,
    required this.variants,
    required this.variantOptions,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      storeId: data['storeId'],
      name: data['name'],
      description: data['description'],
      category: data['category'],
      tags: List<String>.from(data['tags'] ?? []),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isAvailable: data['isAvailable'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      averageRating: data['averageRating'].toDouble(),
      numberOfRatings: data['numberOfRatings'],
      variants: (data['variants'] as List).map((v) => ProductVariant.fromMap(v)).toList(),
      variantOptions: Map<String, List<String>>.from(data['variantOptions'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'name': name,
      'description': description,
      'category': category,
      'tags': tags,
      'imageUrls': imageUrls,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'averageRating': averageRating,
      'numberOfRatings': numberOfRatings,
      'variants': variants.map((v) => v.toMap()).toList(),
      'variantOptions': variantOptions,
    };
  }

  ProductModel copyWith({
    String? name,
    String? description,
    String? category,
    List<String>? tags,
    List<String>? imageUrls,
    bool? isAvailable,
    double? averageRating,
    int? numberOfRatings,
    List<ProductVariant>? variants,
    Map<String, List<String>>? variantOptions,
  }) {
    return ProductModel(
      id: this.id,
      storeId: this.storeId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      imageUrls: imageUrls ?? this.imageUrls,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: this.createdAt,
      updatedAt: Timestamp.now(),
      averageRating: averageRating ?? this.averageRating,
      numberOfRatings: numberOfRatings ?? this.numberOfRatings,
      variants: variants ?? this.variants,
      variantOptions: variantOptions ?? this.variantOptions,
    );
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
