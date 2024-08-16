import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnent/models/product_model.dart';

class RelatedProductsService {
  static Future<List<ProductModel>> fetchRelatedProducts(ProductModel currentProduct) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<ProductModel> relatedProducts = [];

    try {
      // Query products with the same category, excluding the current product
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('productCategory', isEqualTo: currentProduct.productCategory)
          .where(FieldPath.documentId, isNotEqualTo: currentProduct.productId)
          .limit(5)
          .get();

      relatedProducts = querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      // If we don't have 5 products yet, fetch more based on the store category
      if (relatedProducts.length < 10) {
        QuerySnapshot additionalQuery = await _firestore
            .collection('products')
            .where('storeCategory', isEqualTo: currentProduct.storeCategory)
            .where(FieldPath.documentId, isNotEqualTo: currentProduct.productId)
            .limit(5 - relatedProducts.length)
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
}