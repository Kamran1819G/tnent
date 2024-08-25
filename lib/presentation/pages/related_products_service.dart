import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnent/models/product_model.dart';

class RelatedProductsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<ProductModel>> fetchRelatedProducts(ProductModel currentProduct) async {
    List<ProductModel> relatedProducts = [];

    try {
      // Query products with the same category, excluding the current product
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('productCategory', isEqualTo: currentProduct.productCategory)
          .where(FieldPath.documentId, isNotEqualTo: currentProduct.productId)
          .get();

      relatedProducts = querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      // If we don't have 10 products yet, fetch more based on the store category
      if (relatedProducts.length < 10) {
        QuerySnapshot additionalQuery = await _firestore
            .collection('products')
            .where('storeCategory', isEqualTo: currentProduct.storeCategory)
            .where(FieldPath.documentId, isNotEqualTo: currentProduct.productId)
            .get();

        relatedProducts.addAll(
            additionalQuery.docs
                .map((doc) => ProductModel.fromFirestore(doc))
                .where((product) => !relatedProducts.contains(product))
                .toList()
        );
      }

      return relatedProducts;
    } catch (e) {
      print('Error fetching related products: $e');
      return [];
    }
  }

  static Future<List<ProductModel>> fetchRandomProducts(int count) async {
    try {
      // Get total number of products
      QuerySnapshot countSnapshot = await _firestore
          .collection('products')
          .get();
      int totalProducts = countSnapshot.size;

      // Generate random start index
      int randomStart = DateTime.now().millisecondsSinceEpoch % totalProducts;

      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .orderBy(FieldPath.documentId)
          .startAfter([countSnapshot.docs[randomStart].id])
          .limit(count)
          .get();

      List<ProductModel> randomProducts = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      // If we didn't get enough products, wrap around to the beginning
      if (randomProducts.length < count) {
        QuerySnapshot additionalSnapshot = await _firestore
            .collection('products')
            .orderBy(FieldPath.documentId)
            .limit(count - randomProducts.length)
            .get();

        randomProducts.addAll(
            additionalSnapshot.docs
                .map((doc) => ProductModel.fromFirestore(doc))
                .toList()
        );
      }

      return randomProducts;
    } catch (e) {
      print('Error fetching random products: $e');
      return [];
    }
  }
}