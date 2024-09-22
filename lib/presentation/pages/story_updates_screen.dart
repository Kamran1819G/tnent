import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/store_update_model.dart';

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
  int currentStoreIndex = 0;
  int currentUpdateIndex = 0;
  double loaderPercent = 0.0;
  Timer? _timer;

  @override
  void initState() {
    currentStoreIndex = widget.currentStoreIndex;
    _startLoader();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void nextUpdate(List<StoreUpdateModel> updates) {
    if (currentUpdateIndex < updates.length - 1) {
      setState(() {
        currentUpdateIndex++;
        _resetLoader();
      });
    } else {
      nextStore(); // Move to next store if it's the last update
    }
  }

  void previousUpdate() {
    if (currentUpdateIndex > 0) {
      setState(() {
        currentUpdateIndex--;
        _resetLoader();
      });
    } else {
      previousStore(); // Move to previous store if it's the first update
    }
  }

  void nextStore() {
    if (currentStoreIndex < widget.allGroupedUpdates.length - 1) {
      setState(() {
        currentStoreIndex++;
        currentUpdateIndex = 0;
        _resetLoader();
      });
    } else {
      Navigator.of(context).pop(); // Exit if on the last store
    }
  }

  void previousStore() {
    if (currentStoreIndex > 0) {
      setState(() {
        currentStoreIndex--;
        currentUpdateIndex = 0;
        _resetLoader();
      });
    } else {
      Navigator.of(context).pop(); // Exit if on the first store
    }
  }

  void _startLoader() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        loaderPercent += 0.0167; // Progress by ~1/60 (3 seconds)
        if (loaderPercent >= 1.0) {
          nextUpdate(
              widget.allGroupedUpdates.values.elementAt(currentStoreIndex));
        }
      });
    });
  }

  void _resetLoader() {
    _timer?.cancel();
    setState(() {
      loaderPercent = 0.0;
      _startLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentStoreName =
        widget.allGroupedUpdates.keys.elementAt(currentStoreIndex);
    List<StoreUpdateModel> updates =
        widget.allGroupedUpdates[currentStoreName]!;
    String currentImageUrl = updates[currentUpdateIndex].imageUrl;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe left to right-to-left (next store)
            nextStore();
          } else if (details.primaryVelocity! > 0) {
            // Swipe right to left-to-right (previous store)
            previousStore();
          }
        },
        child: Stack(
          children: [
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
                  Row(
                    children: updates.map((update) {
                      int updateIndex = updates.indexOf(update);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: LinearProgressIndicator(
                            value: updateIndex < currentUpdateIndex
                                ? 1.0
                                : (updateIndex == currentUpdateIndex
                                    ? loaderPercent
                                    : 0.0),
                            color: Colors.white,
                            backgroundColor: Colors.grey[600],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
                                color: Colors.black.withOpacity(0.45),
                                blurRadius: 4,
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
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: () => previousUpdate(),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width / 2,
              child: GestureDetector(
                onTap: () => nextUpdate(updates),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
