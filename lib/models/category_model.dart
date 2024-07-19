import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String id;
  String name;
  String coverImage;
  int itemCount;
  List<Map<String, dynamic>> products;

  CategoryModel({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.itemCount,
    required this.products,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      coverImage: data['image'] ?? '',
      itemCount: data['itemCount'] ?? 0,
      products: data['products'] ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'image': coverImage,
      'itemCount': itemCount,
      'products': products,
    };
  }
}