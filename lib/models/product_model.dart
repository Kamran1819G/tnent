import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  factory ProductVariant.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw FormatException('Null data provided for ProductVariant');
    }
    return ProductVariant(
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      mrp: (data['mrp'] as num?)?.toDouble() ?? 0.0,
      discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (data['stockQuantity'] as int?) ?? 0,
      sku: data['sku'] as String?,
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
  final Map<String, ProductVariant> variations;

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
  });

  factory ProductModel.fromFirestore(DocumentSnapshot? doc) {
    if (doc == null || !doc.exists) {
      throw FormatException('Null or non-existent document provided');
    }

    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw FormatException('Null data in document');
    }

    Map<String, ProductVariant> variations = {};

    if (data['variations'] != null && data['variations'] is Map) {
      (data['variations'] as Map<String, dynamic>)
          .forEach((variantKey, variantData) {
        if (variantData is Map<String, dynamic>) {
          try {
            variations[variantKey] = ProductVariant.fromMap(variantData);
          } catch (e) {
            print('Error parsing variant $variantKey: $e');
          }
        }
      });
    }

    return ProductModel(
      productId: doc.id,
      storeId: data['storeId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      productCategory: data['productCategory'] as String? ?? '',
      storeCategory: data['storeCategory'] as String? ?? '',
      imageUrls: (data['imageUrls'] as List<dynamic>?)?.cast<String>() ?? [],
      isAvailable: data['isAvailable'] as bool? ?? false,
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      greenFlags: (data['greenFlags'] as int?) ?? 0,
      redFlags: (data['redFlags'] as int?) ?? 0,
      variations: variations,
    );
  }


  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> variationsMap = variations
        .map((variantKey, variant) => MapEntry(variantKey, variant.toMap()));

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
    };
  }

  ProductModel copyWith({
    String? productId,
    String? storeId,
    String? name,
    String? description,
    String? productCategory,
    String? storeCategory,
    List<String>? imageUrls,
    bool? isAvailable,
    Timestamp? createdAt,
    int? greenFlags,
    int? redFlags,
    Map<String, ProductVariant>? variations,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      description: description ?? this.description,
      productCategory: productCategory ?? this.productCategory,
      storeCategory: storeCategory ?? this.storeCategory,
      imageUrls: imageUrls ?? this.imageUrls,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      greenFlags: greenFlags ?? this.greenFlags,
      redFlags: redFlags ?? this.redFlags,
      variations: variations ?? this.variations,
    );
  }

  static Future<void> reportProduct(
      String productId, String storeId, String reason, String reportedBy) async {
    try {
      final reportedItemsRef = FirebaseFirestore.instance
          .collection('ReportedItems')
          .doc(reportedBy); // Use the reportedBy field as the document ID

      final reportedItemDoc = await reportedItemsRef.get();
      if (!reportedItemDoc.exists) {
        // Create a new reported item document
        await reportedItemsRef.set({});
      }

      final reportedProductRef = reportedItemsRef
          .collection('reportedProducts')
          .doc(); // Create a new reported product document

      await reportedProductRef.set({
        'productId': productId,
        'storeId': storeId,
        'reason': reason,
        'reportedBy': reportedBy,
        'reportedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error reporting product: $e');
      throw e;
    }
  }
}
