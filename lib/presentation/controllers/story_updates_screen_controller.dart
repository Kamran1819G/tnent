import 'dart:async';

import 'package:get/get.dart';
import '../../models/store_update_model.dart';

class StoryUpdatesScreenController extends GetxController {
  final Map<String, List<StoreUpdateModel>> allGroupedUpdates;

  // Rx variables to track the current store and update
  var currentStoreIndex = 0.obs;
  var currentUpdateIndex = 0.obs;

  // Constructor to accept the grouped updates
  StoryUpdatesScreenController(this.allGroupedUpdates);

  // Update the current store being viewed
  void updateStoreIndex(int newIndex) {
    currentStoreIndex.value = newIndex;
    currentUpdateIndex.value = 0; // Reset update index when store changes
  }

  // Go to the next update within the current store
  void nextUpdate(List<StoreUpdateModel> updates) {
    if (currentUpdateIndex.value < updates.length - 1) {
      currentUpdateIndex.value++;
    } else {
      nextStore(); // Move to the next store if current update is the last
    }
  }

  // Go to the previous update
  void previousUpdate() {
    if (currentUpdateIndex.value > 0) {
      currentUpdateIndex.value--;
    }
  }

  // Go to the next store in the list
  void nextStore() {
    if (currentStoreIndex.value < allGroupedUpdates.length - 1) {
      // Move to the next store and reset the update index
      currentStoreIndex.value++;
      currentUpdateIndex.value = 0;
    } else {
      // If at the last store and last update, exit the screen
      Get.back();
    }
  }

  void previousStore() {
    if (currentStoreIndex.value > 0) {
      // Move to the previous store and reset the update index
      currentStoreIndex.value--;
      currentUpdateIndex.value = 0;
    } else {
      // If at the first store, go back to the previous screen
      Get.back();
    }
  }
}
