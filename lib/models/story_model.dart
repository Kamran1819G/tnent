import 'package:flutter/material.dart';

import 'user_model.dart';

enum MediaType { image, video }

class Story {
  String storyId;
  MediaType media;
  DateTime timeStamp;
  Durations durations;
  String expiry;
  bool isHighlight;
  User user;
// Add any other relevant fields

  Story({
    required this.storyId,
    required this.media,
    required this.user,
    required this.timeStamp,
    required this.durations,
    required this.expiry,
    required this.isHighlight,
  });
}