import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../helpers/color_utils.dart';

class StoryScreen extends StatefulWidget {
  final Image storeImage;
  final String storeName;

  const StoryScreen({
    Key? key,
    required this.storeImage,
    required this.storeName,
  }) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentStoryIndex = 0;
  late Image _storeImage;
  late String _storeName;

  final List<Widget> Stories = [
    Container(
      color: Colors.green[200],
    ),
    Container(
      color: Colors.blue[200],
    ),
    Container(
      color: Colors.red[200],
    ),
    Container(
      color: Colors.yellow[200],
    )
  ];

  List<double> percentWatched = [];

  @override
  void initState() {
    super.initState();

    _storeImage = widget.storeImage;
    _storeName = widget.storeName;

    // initially, all stories haven't been watched yet
    for (int i = 0; i < Stories.length; i++) {
      percentWatched.add(0);
    }

    _startWatching();
  }

  void _startWatching() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        // only add 0.01 as long as it's below 1
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.01;
        }
        // if adding 0.01 exceeds 1, set percentage to 1 and cancel timer
        else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();

          // also go to next story as long as there are more stories to go through
          if (currentStoryIndex < Stories.length - 1) {
            currentStoryIndex++;
            // restart story timer
            _startWatching();
          }
          // if we are finishing the last story then return to homepage
          else {
            Navigator.pop(context);
          }
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    // user taps on first half of screen
    if (dx < screenWidth / 2) {
      setState(() {
        // as long as this isnt the first story
        if (currentStoryIndex > 0) {
          // set previous and curent story watched percentage back to 0
          percentWatched[currentStoryIndex - 1] = 0;
          percentWatched[currentStoryIndex] = 0;

          // go to previous story
          currentStoryIndex--;
        }
      });
    }
    // user taps on second half of screen
    else {
      setState(() {
        // if there are more stories left
        if (currentStoryIndex < Stories.length - 1) {
          // finish current story
          percentWatched[currentStoryIndex] = 1;
          // move to next story
          currentStoryIndex++;
        }
        // if user is on the last story, finish this story
        else {
          percentWatched[currentStoryIndex] = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // story
              Stories[currentStoryIndex],
          
              // progress bar
              Align(
                alignment: Alignment(0, -0.95),
                child: StoryBars(
                  percentWatched: percentWatched,
                  length: Stories.length,
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
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Spacer(),
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
      ),
    );
  }
}

class StoryBars extends StatelessWidget {
  List<double> percentWatched = [];
  final int length;

  StoryBars({super.key, required this.percentWatched, required this.length});

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
              backgroundColor: hexToColor('#D9D9D9'),),
          ),
        ],
      ),
    );
  }
}
