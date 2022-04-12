import 'package:flutter/material.dart';
import 'package:bacc_studios/clip.dart';

class Project {
  String? title = "Untitled Project";
  DateTime? date = DateTime.now();
  Image? thumbnail = Image.asset('images/untitled thumbnail.jpg');
  List<MediaClip>? media;

  Project({this.title, this.date, this.thumbnail, this.media});
}
