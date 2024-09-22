import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tnent/core/helpers/snackbar_utils.dart';

import '../../models/store_update_model.dart';

class StoryUpdatesController extends GetxController {
  RxBool isUpdatesLoading = false.obs;
  RxList<StoreUpdateModel> updates = <StoreUpdateModel>[].obs;
  RxMap<String, List<StoreUpdateModel>> groupedUpdates =
      <String, List<StoreUpdateModel>>{}.obs;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> onInit() async {
    super.onInit();

    // List<StoreUpdateModel> fetchedUpdates = await fetchAndPopulateUpdates();
    // updates.value = fetchedUpdates;
    // sortInGroupedupdates();
  }

  void clearVars() {
    isUpdatesLoading.value = false;
    updates.clear();
    groupedUpdates.clear();
  }

  Future<List<StoreUpdateModel>> fetchAndPopulateUpdates() async {
    isUpdatesLoading.value = true;

    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(const Duration(hours: 24));
      final currentUserId = firebaseAuth.currentUser!.uid;

      QuerySnapshot snapshot = await firestore
          .collection('storeUpdates')
          .where('createdAt', isGreaterThanOrEqualTo: oneDayAgo)
          .get();

      List<StoreUpdateModel> updatesLocal = [];

      for (var doc in snapshot.docs) {
        final createdAt = (doc['createdAt'] as Timestamp).toDate();
        final expiresAt = (doc['expiresAt'] as Timestamp).toDate();
        final storeId = doc['storeId'];

        if (now.isBefore(expiresAt) && createdAt.isAfter(oneDayAgo)) {
          DocumentSnapshot storeDoc =
              await firestore.collection('Stores').doc(storeId).get();

          List<String> followerIds = List<String>.from(storeDoc['followerIds']);
          if (followerIds.contains(currentUserId)) {
            final storeUpdateModel = StoreUpdateModel.fromFirestore(doc);
            // Handling the logic that 2/more updates from same store dont show individually in home page

            updatesLocal.add(storeUpdateModel);
          }
        }
      }
      return updatesLocal;
    } catch (e) {
      showSnackBar(Get.context!, "Unable to load updates");
      return [];
    } finally {
      isUpdatesLoading.value = false;
    }
  }

  void sortInGroupedupdates() {
    for (var update in updates) {
      if (groupedUpdates.containsKey(update.storeName)) {
        groupedUpdates[update.storeName]!.add(update);
      } else {
        groupedUpdates[update.storeName] = [update];
      }
    }
    sortUpdatesFromGroupedupdates();
  }

  void sortUpdatesFromGroupedupdates() {
    updates.value = groupedUpdates.values.expand((e) => e).toList();
  }
}
