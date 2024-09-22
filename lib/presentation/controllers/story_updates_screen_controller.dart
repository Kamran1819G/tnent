import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/store_update_model.dart';

// UNUSED, may be deleted, but for reference of StoryUpdatesScreen, it is kept 
/*
class StoryUpdatesScreenController extends GetxController {
  final Map<String, List<StoreUpdateModel>> allGroupedUpdates;
  final BuildContext context;

  // Rx variables to track the current store, update, and progress
  var currentStoreIndex = 0.obs;
  var currentUpdateIndex = 0.obs;
  var loaderPercent = 0.0.obs; // Tracks the progress of the current update
  Timer? _timer; // Timer for updating the progress

  // Constructor to accept the grouped updates
  StoryUpdatesScreenController(this.allGroupedUpdates, this.context);

  @override
  void onInit() {
    super.onInit();
    _startLoader(); // Start the loader when the controller initializes
  }

  // Update the current store being viewed
  void updateStoreIndex(int newIndex) {
    currentStoreIndex.value = newIndex;
    currentUpdateIndex.value = 0; // Reset update index when store changes
    _resetLoader(); // Reset and start loader for new store
  }

  // Go to the next update within the current store
  void nextUpdate(List<StoreUpdateModel> updates) {
    if (currentUpdateIndex.value < updates.length - 1) {
      currentUpdateIndex.value++;
    } else {
      nextStore(); // Move to the next store if current update is the last
    }
    _resetLoader(); // Reset loader when moving to the next update
  }

  // Go to the previous update
  void previousUpdate() {
    if (currentUpdateIndex.value > 0) {
      currentUpdateIndex.value--;
    }
    _resetLoader(); // Reset loader when moving to the previous update
  }

  // Go to the next store in the list
  void nextStore() {
    if (currentStoreIndex.value < allGroupedUpdates.length - 1) {
      currentStoreIndex.value++;
      currentUpdateIndex.value = 0; // Reset the update index for new store
    } else {
      // If at the last store and last update, exit the screen
      Navigator.pop(context);
    }
    _resetLoader(); // Reset loader when moving to the next store
  }

  void previousStore() {
    if (currentStoreIndex.value > 0) {
      currentStoreIndex.value--;
      currentUpdateIndex.value = 0; // Reset the update index for previous store
    } else {
      Navigator.pop(context);
    }
    _resetLoader(); // Reset loader when moving to the previous store
  }

  // Start the loader for the progress bar
  void _startLoader() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      loaderPercent.value += 0.0167; // 0.0167 corresponds to 1/60 (3 seconds)
      if (loaderPercent.value >= 1.0) {
        nextUpdate(allGroupedUpdates.values
            .elementAt(currentStoreIndex.value)); // Move to next update
      }
    });
  }

  // Reset the loader for the next update or store
  void _resetLoader() {
    _timer?.cancel(); // Cancel the previous timer
    loaderPercent.value = 0.0; // Reset the progress
    _startLoader(); // Start the new loader
  }

  @override
  void onClose() {
    _timer?.cancel(); // Cancel the timer when the controller is closed
    super.onClose();
  }
}

*/
