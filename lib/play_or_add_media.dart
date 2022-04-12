import 'package:flutter/material.dart';
import 'project.dart';

class VideoPlayerOrAddMedia extends StatelessWidget {
  final Project project;
  final Function pickMultiImages;
  final Function pickVideo;
  const VideoPlayerOrAddMedia(
      {Key? key,
      required this.project,
      required this.pickMultiImages,
      required this.pickVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget addMedia = (project.media != null ? project.media!.isEmpty : true)
        ? Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.photo_library,
                        size: 80,
                      ),
                      Text(
                        "Add Photos",
                        style: TextStyle(
                            fontFamily: 'Myriad Pro',
                            fontSize: 30,
                            color: Colors.white),
                      )
                    ],
                  ),
                  onPressed: () => pickMultiImages()),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.video_library, size: 80),
                      Text("Add Video",
                          style: TextStyle(
                              fontFamily: 'Myriad Pro',
                              fontSize: 30,
                              color: Colors.white))
                    ],
                  ),
                  onPressed: () => pickVideo())
            ]))
        : project.media!.first.mediaIcon;
    return addMedia;
  }
}
