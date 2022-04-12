import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'clip.dart';
import 'project.dart';

class ClipsTimeline extends StatefulWidget {
  final Project project;
  const ClipsTimeline({Key? key, required this.project}) : super(key: key);

  @override
  _ClipsTimelineState createState() => _ClipsTimelineState();
}

class _ClipsTimelineState extends State<ClipsTimeline> {
  final ScrollController _controller = ScrollController();
  final int pixelSecondsMultiplier = 50;
  String scrollTime = "00:00:000";

  @override
  Widget build(BuildContext context) {
    Project project = widget.project;

    return (project.media != null ? project.media!.length : 0) == 0
        ? const AutoSizeText('No Clips Yet',
            maxLines: 1,
            maxFontSize: 20,
            style: TextStyle(color: Colors.white, fontSize: 20))
        : Column(children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: NotificationListener(
                      child: Scrollbar(
                          controller: _controller,
                          thickness: 0,
                          child: ListView.builder(
                              controller: _controller,
                              scrollDirection: Axis.horizontal,
                              itemCount: (project.media != null
                                  ? project.media!.length
                                  : 0),
                              itemBuilder: (BuildContext context, int index) {
                                MediaClip clipWidget = project.media![index];
                                Image image = Image(
                                    image: clipWidget.mediaIcon.image,
                                    repeat: ImageRepeat.repeatX);

                                double videoClipTimelineLength =
                                    (clipWidget.mediaLength.inSeconds *
                                            pixelSecondsMultiplier)
                                        .toDouble();
                                return SizedBox(
                                    //padding: const EdgeInsets.only(left: 5, right: 5),
                                    width: videoClipTimelineLength,
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Stack(children: [
                                          Container(),
                                          Positioned.fill(child: image)
                                        ])));
                              })),
                      onNotification: (notificationInfo) {
                        if (notificationInfo is ScrollUpdateNotification) {
                          setState(() {
                            Duration scrollDuration = Duration(
                                milliseconds: (double.parse(
                                            (_controller.offset /
                                                    pixelSecondsMultiplier)
                                                .toStringAsFixed(3)) *
                                        1000)
                                    .round());
                            int hoursScroll = scrollDuration.inHours.round();
                            int secondsScroll =
                                scrollDuration.inSeconds.round() -
                                    hoursScroll * 60;
                            int millisecondsScroll =
                                scrollDuration.inMilliseconds.round() -
                                    secondsScroll * 1000;

                            String hours =
                                '0' * (2 - hoursScroll.toString().length) +
                                    hoursScroll.toString();
                            String seconds =
                                '0' * (2 - secondsScroll.toString().length) +
                                    secondsScroll.toString();
                            String milliseconds = '0' *
                                    (3 - millisecondsScroll.toString().length) +
                                millisecondsScroll.toString();

                            scrollTime = "$hours:$seconds:$milliseconds";
                          });
                        }
                        return true;
                      },
                    ))),
            Expanded(
                child: Text(scrollTime,
                    style: const TextStyle(color: Colors.white, fontSize: 20)))
          ]);
  }
}
