import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tnent/models/store_order.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> simulateNewOrder() async {
    StoreOrder newOrder = StoreOrder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      total: 50.0,
      status: 'pending',
    );

    await _firestore.collection('Orders').doc(newOrder.id).set(newOrder.toJson());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('Orders').doc(orderId).update({'status': status});
  }
}