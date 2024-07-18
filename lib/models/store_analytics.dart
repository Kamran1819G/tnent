import 'package:cloud_firestore/cloud_firestore.dart';

class StoreAnalytics {
  final String id;
  final String storeId;
  final int totalVisits;
  final int uniqueVisitors;
  final int totalOrders;
  final double totalRevenue;
  final Map<String, int> visitsPerDay;
  final Map<String, double> revenuePerDay;
  final List<String> topSellingProducts;
  final Map<String, int> visitsPerHour;
  final Timestamp lastUpdated;

  StoreAnalytics({
    required this.id,
    required this.storeId,
    required this.totalVisits,
    required this.uniqueVisitors,
    required this.totalOrders,
    required this.totalRevenue,
    required this.visitsPerDay,
    required this.revenuePerDay,
    required this.topSellingProducts,
    required this.visitsPerHour,
    required this.lastUpdated,
  });

  factory StoreAnalytics.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StoreAnalytics(
      id: doc.id,
      storeId: data['storeId'],
      totalVisits: data['totalVisits'],
      uniqueVisitors: data['uniqueVisitors'],
      totalOrders: data['totalOrders'],
      totalRevenue: data['totalRevenue'],
      visitsPerDay: Map<String, int>.from(data['visitsPerDay'] ?? {}),
      revenuePerDay: Map<String, double>.from(data['revenuePerDay'] ?? {}),
      topSellingProducts: List<String>.from(data['topSellingProducts'] ?? []),
      visitsPerHour: Map<String, int>.from(data['visitsPerHour'] ?? {}),
      lastUpdated: data['lastUpdated'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'storeId': storeId,
      'totalVisits': totalVisits,
      'uniqueVisitors': uniqueVisitors,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'visitsPerDay': visitsPerDay,
      'revenuePerDay': revenuePerDay,
      'topSellingProducts': topSellingProducts,
      'visitsPerHour': visitsPerHour,
      'lastUpdated': lastUpdated,
    };
  }
}

/*
When creating a new store:
final String analyticsId = FirebaseFirestore.instance.collection('storeAnalytics').doc().id;

final store = StoreModel(
  id: 'store123',
  ownerId: 'owner456',
  name: 'My Store',
  // ... other fields ...
  analyticsId: analyticsId,
);

// Save the store
await FirebaseFirestore.instance.collection('stores').doc(store.id).set(store.toFirestore());

// Initialize analytics
final analytics = StoreAnalytics(
  id: analyticsId,
  storeId: store.id,
  totalVisits: 0,
  uniqueVisitors: 0,
  totalOrders: 0,
  totalRevenue: 0.0,
  visitsPerDay: {},
  revenuePerDay: {},
  topSellingProducts: [],
  visitsPerHour: {},
  lastUpdated: Timestamp.now(),
);

await FirebaseFirestore.instance.collection('storeAnalytics').doc(analyticsId).set(analytics.toFirestore());*/

/*
To update analytics:
Future<void> updateAnalytics(String analyticsId, {int? newVisit, double? newRevenue}) async {
  final doc = FirebaseFirestore.instance.collection('storeAnalytics').doc(analyticsId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(doc);
    final currentAnalytics = StoreAnalytics.fromFirestore(snapshot);

    final updatedAnalytics = StoreAnalytics(
      id: currentAnalytics.id,
      storeId: currentAnalytics.storeId,
      totalVisits: currentAnalytics.totalVisits + (newVisit ?? 0),
      uniqueVisitors: currentAnalytics.uniqueVisitors,  // This would need a more complex update logic
      totalOrders: currentAnalytics.totalOrders,
      totalRevenue: currentAnalytics.totalRevenue + (newRevenue ?? 0),
      visitsPerDay: currentAnalytics.visitsPerDay,  // Update this based on current date
      revenuePerDay: currentAnalytics.revenuePerDay,  // Update this based on current date
      topSellingProducts: currentAnalytics.topSellingProducts,
      visitsPerHour: currentAnalytics.visitsPerHour,  // Update this based on current hour
      lastUpdated: Timestamp.now(),
    );

    transaction.set(doc, updatedAnalytics.toFirestore());
  });
}*/
