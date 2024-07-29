import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tnennt/models/store_update_model.dart';
import '../helpers/color_utils.dart';

class UpdateScreen extends StatefulWidget {
  final Image storeImage;
  final String storeName;
  final int initialUpdateIndex;
  final List<StoreUpdateModel> updates;

  const UpdateScreen({
    Key? key,
    required this.storeImage,
    required this.storeName,
    required this.initialUpdateIndex,
    required this.updates,
  }) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late int currentUpdateIndex;
  late Image _storeImage;
  late String _storeName;
  bool isPaused = false;
  Timer? _timer;

  List<double> percentWatched = [];

  @override
  void initState() {
    super.initState();

    currentUpdateIndex = widget.initialUpdateIndex;
    _storeImage = widget.storeImage;
    _storeName = widget.storeName;

    // initially, all stories haven't been watched yet
    for (int i = 0; i < widget.updates.length; i++) {
      percentWatched.add(0);
    }

    _startWatching();
  }

  void _startWatching() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!isPaused) {
        setState(() {
          if (percentWatched[currentUpdateIndex] + 0.01 < 1) {
            percentWatched[currentUpdateIndex] += 0.01;
          } else {
            percentWatched[currentUpdateIndex] = 1;
            timer.cancel();

            if (currentUpdateIndex < widget.updates.length - 1) {
              currentUpdateIndex++;
              _startWatching();
            } else {
              Navigator.pop(context);
            }
          }
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void _onTapDown(TapDownDetails details) {
    if (isPaused) return; // Don't change stories when paused

    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 2) {
      setState(() {
        if (currentUpdateIndex > 0) {
          percentWatched[currentUpdateIndex - 1] = 0;
          percentWatched[currentUpdateIndex] = 0;
          currentUpdateIndex--;
          _startWatching();
        }
      });
    } else {
      setState(() {
        if (currentUpdateIndex < widget.updates.length - 1) {
          percentWatched[currentUpdateIndex] = 1;
          currentUpdateIndex++;
          _startWatching();
        } else {
          percentWatched[currentUpdateIndex] = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // story
            GestureDetector(
              onTapDown: (details) => _onTapDown(details),
              child: Image.network(
                widget.updates[currentUpdateIndex].imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),

            // progress bar
            Align(
              alignment: Alignment(0, -0.95),
              child: UpdateBars(
                percentWatched: percentWatched,
                length: widget.updates.length,
              ),
            ),

            Align(
              alignment: Alignment(0, -0.95),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(height: 40, width: 40, child: _storeImage),
                    SizedBox(width: 10),
                    Text(
                      _storeName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                      ),
                      onPressed: _togglePause,
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: Colors.black),
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
    );
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
