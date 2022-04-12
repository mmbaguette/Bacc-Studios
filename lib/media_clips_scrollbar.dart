import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'clip.dart';
import 'project.dart';

Color darkGrey = Colors.grey.shade900;

class MediaClipScrollbar extends StatefulWidget {
  final Project project;
  final Function pickFromGallery;
  const MediaClipScrollbar(
      {Key? key, required this.project, required this.pickFromGallery})
      : super(key: key);

  @override
  _MediaClipScrollbarState createState() => _MediaClipScrollbarState();
}

class _MediaClipScrollbarState extends State<MediaClipScrollbar> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    Project project = widget.project;
    var clipIconsController = ScrollController();

    return CupertinoScrollbar(
      controller: clipIconsController,
      child: ListView.builder(
        controller: clipIconsController,
        scrollDirection: Axis.horizontal,
        itemCount: (project.media != null ? project.media!.length : 0) + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index != (project.media != null ? project.media!.length : 0)) {
            MediaClip clipWidget = project.media![index];

            if (clipWidget.resetState != null) {
              //dirty way to refresh MediaClip state when it's selected
              clipWidget.resetState!();
            }

            if (index == selectedIndex) {
              clipWidget.selected = true;
            } else {
              clipWidget.selected = false;
            }

            Widget clip = SizedBox(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        splashFactory: NoSplash.splashFactory),
                    child: clipWidget,
                    onPressed: () => {
                          setState(() {
                            selectedIndex == index
                                ? selectedIndex = null
                                : selectedIndex = index;
                          })
                        }));
            return clip;
          } else {
            return SizedBox(
                //add media button
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        splashFactory: NoSplash.splashFactory),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          child: const Icon(Icons.add,
                              color: Colors.black, size: 100),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: darkGrey),
                        )),
                    onPressed: () => widget.pickFromGallery()));
          }
        },
      ),
    );
  }
}
