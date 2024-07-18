import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String name;
  String image;
  List<Map<String, dynamic>> products;

  CategoryModel({
    required this.name,
    required this.image,
    required this.products,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      products: data['products'] ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': image,
      'products': products,
    };
  }
}