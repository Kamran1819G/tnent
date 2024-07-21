import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final int totalProducts;
  List<String> productIds; // Change to List<String>

  CategoryModel({
    required this.id,
    required this.name,
    required this.totalProducts,
    required this.productIds,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> productIdsDynamic = data['productIds'] ?? [];
    List<String> productIds = productIdsDynamic.map((id) {
      if (id is String) {
        return id;
      } else {
        print('Warning: Product ID is not a String: ${id.runtimeType}');
        return ''; // Return an empty string for non-string types
      }
    }).toList();
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      totalProducts: data['totalProducts'] ?? 0,
      productIds: productIds,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'totalProducts': totalProducts,
      'productIds': productIds,
    };
  }
}
