import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tnent/presentation/widgets/show_case_view.dart';
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
  final GlobalKey globalKeyLeftTap = GlobalKey();
  final GlobalKey globalKeyRightTap = GlobalKey();
  final GlobalKey globalKeyRightDoubleTap = GlobalKey();
  final GlobalKey globalKeyLeftDoubleTap = GlobalKey();

  late final StoryUpdatesScreenController _storyController;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([
              globalKeyLeftTap,
              globalKeyRightTap,
              globalKeyRightDoubleTap,
              globalKeyLeftDoubleTap,
            ]));
    // Initialize the StoryController with the passed allGroupedUpdates map
    _storyController =
        Get.put(StoryUpdatesScreenController(widget.allGroupedUpdates));
    _storyController.updateStoreIndex(widget.currentStoreIndex);
    super.initState();
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
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),

              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 5),

                    // Progress indicator for each status (similar to WhatsApp)
                    Obx(() {
                      // Get the updates list for the current store
                      List<StoreUpdateModel> updates = widget
                          .allGroupedUpdates.values
                          .elementAt(_storyController.currentStoreIndex.value);

                      return Row(
                        children: updates.map((update) {
                          int updateIndex = updates.indexOf(update);
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Obx(() {
                                return LinearProgressIndicator(
                                  value: updateIndex <
                                          _storyController
                                              .currentUpdateIndex.value
                                      ? 1.0
                                      : (updateIndex ==
                                              _storyController
                                                  .currentUpdateIndex.value
                                          ? _storyController.loaderPercent.value
                                          : 0.0),
                                  color: Colors.white,
                                  backgroundColor: Colors.grey[600],
                                );
                              }),
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    // Store name and profile image at the top

                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24.5,
                            backgroundColor: Colors.black.withOpacity(0.6),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: CachedNetworkImageProvider(
                                widget.allGroupedUpdates[currentStoreName]![0]
                                    .logoUrl,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            currentStoreName,
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.45), // Shadow color with some transparency
                                  blurRadius: 4, // Blur radius of the shadow
                                  offset: const Offset(2, 3),
                                )
                              ],
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // To display the tutorial to users...
                    const SizedBox(height: 260),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShowCaseView(
                          globalKey: globalKeyLeftTap,
                          title: 'Tap here',
                          description: 'to navigate to the previous update',
                          child: Container(
                            color: Colors.transparent,
                            height: 10,
                            width: 10,
                          ),
                        ),
                        ShowCaseView(
                          globalKey: globalKeyRightTap,
                          title: 'Tap here',
                          description: 'to navigate to the next update',
                          child: Container(
                            color: Colors.transparent,
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShowCaseView(
                          globalKey: globalKeyRightDoubleTap,
                          title: 'Double Tap',
                          description: 'to navigate to the next store\'s',
                          child: Container(
                            color: Colors.transparent,
                            height: 10,
                            width: 10,
                          ),
                        ),
                        ShowCaseView(
                          globalKey: globalKeyLeftDoubleTap,
                          title: 'Double Tap',
                          description: 'to navigate to the previous store\'s',
                          child: Container(
                            color: Colors.transparent,
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ],
                    )
                  ],
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
