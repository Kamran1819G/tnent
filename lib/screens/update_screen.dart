import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../helpers/color_utils.dart';

class UpdateScreen extends StatefulWidget {
  final Image storeImage;
  final String storeName;

  const UpdateScreen({
    Key? key,
    required this.storeImage,
    required this.storeName,
  }) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  int currentUpdateIndex = 0;
  late Image _storeImage;
  late String _storeName;
  bool isPaused = false;
  Timer? _timer;

  final List<Widget> updates = [
    Image.asset(
      'assets/sample_update.png',
      fit: BoxFit.cover,
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
    for (int i = 0; i < updates.length; i++) {
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

            if (currentUpdateIndex < updates.length - 1) {
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
        if (currentUpdateIndex < updates.length - 1) {
          percentWatched[currentUpdateIndex] = 1;
          currentUpdateIndex++;
          _startWatching();
        } else {
          percentWatched[currentUpdateIndex] = 1;
          Navigator.pop(context);
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
                child: updates[currentUpdateIndex]),

            // progress bar
            Align(
              alignment: Alignment(0, -0.95),
              child: UpdateBars(
                percentWatched: percentWatched,
                length: updates.length,
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

            Align(
              alignment: Alignment(0, 0.9),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildBottomSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexToColorWithOpacity("#FFFFFF", 0.5),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Save As Highlight',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildBottomSheet() {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: hexToColor('#CACACA'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Add to Highlights',
            style: TextStyle(
                color: hexToColor('#343434'),
                fontSize: 16.0),
          ),
          SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: hexToColorWithOpacity("#474747", 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add,
                  color: hexToColor('#FFFFFF'),
                  size: 50,
                ),
              ),
            ],
          ),
        ],
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
