import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tnent/models/store_update_model.dart';
import '../../core/helpers/color_utils.dart';
import 'package:transparent_image/transparent_image.dart';

class UpdateScreen extends StatefulWidget {
  final String storeName;
  final Widget storeImage;
  final int initialUpdateIndex;
  final List<StoreUpdateModel> updates;

  const UpdateScreen({
    Key? key,
    required this.storeName,
    required this.storeImage,
    required this.initialUpdateIndex,
    required this.updates,
  }) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen>
    with SingleTickerProviderStateMixin {
  late int currentUpdateIndex;
  late Widget _storeImage;
  late String _storeName;
  bool isPaused = false;
  late AnimationController _animationController;

  List<double> percentWatched = [];

  @override
  void initState() {
    super.initState();

    currentUpdateIndex = widget.initialUpdateIndex;
    _storeImage = widget.storeImage;
    _storeName = widget.storeName;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // initially, all stories haven't been watched yet
    for (int i = 0; i < widget.updates.length; i++) {
      percentWatched.add(0);
    }

    _startWatching();
  }

  void _startWatching() {
    _animationController.forward(from: percentWatched[currentUpdateIndex]);
    _animationController.addListener(() {
      setState(() {
        percentWatched[currentUpdateIndex] = _animationController.value;
      });
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    if (currentUpdateIndex < widget.updates.length - 1) {
      setState(() {
        percentWatched[currentUpdateIndex] = 1;
        currentUpdateIndex++;
        _startWatching();
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (currentUpdateIndex > 0) {
      setState(() {
        percentWatched[currentUpdateIndex] = 0;
        percentWatched[currentUpdateIndex - 1] = 0;
        currentUpdateIndex--;
        _startWatching();
      });
    }
  }

  void _togglePause(bool pause) {
    setState(() {
      if (pause) {
        _animationController.stop();
      } else {
        _animationController.forward();
      }
      isPaused = pause;
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      _previousStory();
    } else if (dx > 2 * screenWidth / 3) {
      _nextStory();
    }
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _togglePause(true);
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _togglePause(false);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      _previousStory();
    } else if (details.primaryVelocity! < 0) {
      _nextStory();
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTapDown: _onTapDown,
          onLongPressStart: _onLongPressStart,
          onLongPressEnd: _onLongPressEnd,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: Stack(
            children: [
              // story

              CachedNetworkImage(
                imageUrl: widget.updates[currentUpdateIndex].imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: hexToColor('#094446'),
                ),
              ),

              // progress bar
              Align(
                  alignment: const Alignment(0, -0.95),
                  child: UpdateBars(
                    percentWatched: percentWatched,
                    length: widget.updates.length,
                  )),
              Align(
                alignment: const Alignment(0, -0.95),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 40, width: 40, child: _storeImage),
                      const SizedBox(width: 10),
                      Text(
                        _storeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class UpdateBars extends StatelessWidget {
  List<double> percentWatched = [];
  final int length;

  UpdateBars({super.key, required this.percentWatched, required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          for (int i = 0; i < length; i++)
            Expanded(
              child: LinearPercentIndicator(
                lineHeight: 3,
                percent: percentWatched[i],
                progressColor: hexToColor('#FFFFFF'),
                backgroundColor: hexToColor('#D9D9D9'),
              ),
            ),
        ],
      ),
    );
  }
}
