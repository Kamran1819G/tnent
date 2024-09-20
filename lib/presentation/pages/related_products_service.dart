import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnent/models/product_model.dart';

class RelatedProductsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<ProductModel>> fetchRelatedProducts(ProductModel currentProduct) async {
    List<ProductModel> relatedProducts = [];

    try {
      // Fetch active store IDs in a single query
      QuerySnapshot activeStoresSnapshot = await _firestore
          .collection('Stores')
          .where('isActive', isEqualTo: true)
          .get();

      Set<String> activeStoreIds = activeStoresSnapshot.docs.map((doc) => doc.id).toSet();

      // Query products with the same category, excluding the current product
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('productCategory', isEqualTo: currentProduct.productCategory)
          .where(FieldPath.documentId, isNotEqualTo: currentProduct.productId)
          .limit(20) // Limit to 20 to reduce data transfer
          .get();

      for (var doc in querySnapshot.docs) {
        if (activeStoreIds.contains(doc['storeId'])) {
          relatedProducts.add(ProductModel.fromFirestore(doc));
        }
        if (relatedProducts.length >= 10) break;
      }

      // If we don't have 10 products yet, fetch more based on the store category
      if (relatedProducts.length < 10) {
        QuerySnapshot additionalQuery = await _firestore
            .collection('products')
            .where('storeCategory', isEqualTo: currentProduct.storeCategory)
            .where(FieldPath.documentId, isNotEqualTo: currentProduct.productId)
            .limit(20) // Limit to 20 to reduce data transfer
            .get();

        for (var doc in additionalQuery.docs) {
          if (activeStoreIds.contains(doc['storeId'])) {
            ProductModel product = ProductModel.fromFirestore(doc);
            if (!relatedProducts.contains(product)) {
              relatedProducts.add(product);
              if (relatedProducts.length >= 10) break;
            }
          }
        }
      }

      return relatedProducts;
    } catch (e) {
      print('Error fetching related products: $e');
      return [];
    }
  }

  static Future<List<ProductModel>> fetchRandomProducts(int count) async {
    try {
      // Fetch active store IDs in a single query
      QuerySnapshot activeStoresSnapshot = await _firestore
          .collection('Stores')
          .where('isActive', isEqualTo: true)
          .get();

      Set<String> activeStoreIds = activeStoresSnapshot.docs.map((doc) => doc.id).toSet();

      // Get total number of products (consider caching this value)
      QuerySnapshot countSnapshot = await _firestore
          .collection('products')
          .limit(1)
          .get();
      int totalProducts = countSnapshot.size;

      // Generate random start index
      int randomStart = DateTime.now().millisecondsSinceEpoch % totalProducts;

      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .orderBy(FieldPath.documentId)
          .startAfter([countSnapshot.docs[randomStart].id])
          .limit(count * 2)  // Fetch more to account for inactive stores
          .get();

      List<ProductModel> randomProducts = [];

      for (var doc in snapshot.docs) {
        if (activeStoreIds.contains(doc['storeId'])) {
          randomProducts.add(ProductModel.fromFirestore(doc));
          if (randomProducts.length == count) break;
        }
      }

      // If we didn't get enough products, wrap around to the beginning
      if (randomProducts.length < count) {
        QuerySnapshot additionalSnapshot = await _firestore
            .collection('products')
            .orderBy(FieldPath.documentId)
            .limit(count * 2)  // Fetch more to account for inactive stores
            .get();

        for (var doc in additionalSnapshot.docs) {
          if (activeStoreIds.contains(doc['storeId'])) {
            ProductModel product = ProductModel.fromFirestore(doc);
            if (!randomProducts.contains(product)) {
              randomProducts.add(product);
              if (randomProducts.length == count) break;
            }
          }
        }
      }
      return randomProducts;
    } catch (e) {
      print('Error fetching random products: $e');
      return [];
    }
  }
}