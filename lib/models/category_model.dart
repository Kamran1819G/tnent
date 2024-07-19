import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  final String id;
  final String name;
  final String coverImage;
  final int totalProduct;
  List<dynamic> products;

  CategoryModel({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.totalProduct,
    required this.products,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      coverImage: data['coverImage'] ?? '',
      totalProduct: data['products'].length ?? 0,
      products: data['products'] ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'image': coverImage,
      'itemCount': totalProduct,
      'products': products,
    };
  }
}