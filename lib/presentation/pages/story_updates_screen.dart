import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/store_update_model.dart';
import '../controllers/story_updates_screen_controller.dart';

class StoryUpdatesScreen extends StatefulWidget {
  final int currentStoreIndex;
  final Map<String, List<StoreUpdateModel>> allGroupedUpdates;

  const StoryUpdatesScreen({
    super.key,
    required this.currentStoreIndex,
    required this.allGroupedUpdates,
  });

  @override
  State<StoryUpdatesScreen> createState() => _StoryUpdatesScreenState();
}

class _StoryUpdatesScreenState extends State<StoryUpdatesScreen> {
  late final StoryUpdatesScreenController _storyController;

  @override
  void initState() {
    super.initState();
    // Initialize the StoryController with the passed allGroupedUpdates map
    _storyController =
        Get.put(StoryUpdatesScreenController(widget.allGroupedUpdates));
    _storyController.updateStoreIndex(widget.currentStoreIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        // Get the current store's name
        String currentStoreName = widget.allGroupedUpdates.keys
            .elementAt(_storyController.currentStoreIndex.value);

        // Get the updates for the current store
        List<StoreUpdateModel> updates =
            widget.allGroupedUpdates[currentStoreName]!;

        // Get the current update (status) image URL
        String currentImageUrl =
            updates[_storyController.currentUpdateIndex.value].imageUrl;

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _storyController.previousUpdate();
            } else {
              _storyController.nextUpdate(updates);
            }
          },
          child: Stack(
            children: [
              // Background image (current update)
              CachedNetworkImage(
                imageUrl: currentImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),

              // Store name and profile image at the top
              Positioned(
                top: 40,
                left: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        widget.allGroupedUpdates[currentStoreName]![0].logoUrl,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      currentStoreName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress indicator for each status (similar to WhatsApp)
              Positioned(
                top: 90,
                left: 16,
                right: 16,
                child: Row(
                  children: updates.map((update) {
                    int updateIndex = updates.indexOf(update);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: LinearProgressIndicator(
                          value: updateIndex <=
                                  _storyController.currentUpdateIndex.value
                              ? 0.7
                              : 0.0,
                          color: Colors.white,
                          backgroundColor: Colors.grey[600],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Tap on left side to go to previous update
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width / 2,
                child: GestureDetector(
                  onTap: () => _storyController.previousUpdate(),
                  onDoubleTap: () {
                    _storyController.previousStore();
                  },
                ),
              ),

              // Tap on right side to go to next update
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width / 2,
                child: GestureDetector(
                  onTap: () => _storyController.nextUpdate(updates),
                  onDoubleTap: () {
                    _storyController.nextStore();
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
