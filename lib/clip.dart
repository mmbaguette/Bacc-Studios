import 'package:flutter/material.dart';
import 'dart:io';

Color red = Colors.redAccent.shade700;
Color darkGrey = Colors.grey.shade900;

// ignore: must_be_immutable
class MediaClip extends StatefulWidget {
  Image mediaIcon;
  File mediaFile;
  bool isVideo;
  bool selected = false;
  Duration mediaLength;
  Function? resetState;

  MediaClip(this.mediaFile, this.mediaIcon, this.isVideo, this.mediaLength,
      {Key? key})
      : super(key: key);

  @override
  _MediaClipState createState() => _MediaClipState();
}

class _MediaClipState extends State<MediaClip> {
  @override
  Widget build(BuildContext context) {
    widget.resetState = () => {setState(() {})};
    return AspectRatio(
        aspectRatio: 1,
        child: Container(
            child: widget.mediaIcon,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: widget.mediaIcon.image, fit: BoxFit.fill),
                color: darkGrey,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border:
                    Border.all(color: red, width: widget.selected ? 5 : 0))));
  }
}
