import 'dart:io';
import 'package:bacc_studios/play_or_add_media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'clips_timeline.dart';
import 'editing_buttons.dart';
import 'media_clips_scrollbar.dart';
import 'other_functions.dart';
import 'project.dart';
import 'clip.dart';

Color red = Colors.redAccent.shade700;
Color darkGrey = Colors.grey.shade900;
final FlutterFFprobe _flutterFFprobe = FlutterFFprobe();

class EditingPage extends StatefulWidget {
  final Project project;
  final StatefulWidget backPage;
  const EditingPage(this.project, this.backPage, {Key? key}) : super(key: key);
  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  final ImagePicker _picker = ImagePicker();

  Future<Image> videoClipThumbnail(XFile video) async {
    final thumbnailBytes = await VideoThumbnail.thumbnailData(
      video: File(video.path).path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 25,
    );

    if (thumbnailBytes != null) {
      Image newProjectThumbnail = Image.memory(thumbnailBytes);
      return newProjectThumbnail;
    } else {
      return Image.asset('images/clip thumbnail not found.png');
    }
  }

  void doneEditing() {
    print("Moving to export page!");
  }

  Future<void> pickMultiImages() async {
    Project project = widget.project;
    var newImagesChosen = await _picker.pickMultiImage();

    if (newImagesChosen != null && newImagesChosen.isNotEmpty) {
      project.media ??= [];

      setState(() {
        for (XFile xFileImage in newImagesChosen) {
          File imageFile = File(xFileImage.path);
          Image image = Image.file(imageFile, fit: BoxFit.contain);
          project.media!.add(
              MediaClip(imageFile, image, false, const Duration(seconds: 1)));
        }
      });
    }
  }

  Future<void> pickVideo() async {
    Project project = widget.project;
    XFile? newVideoChosen =
        await _picker.pickVideo(source: ImageSource.gallery);

    if (newVideoChosen != null) {
      project.media ??= [];
      File videoFile = File(newVideoChosen.path);
      Image videoIcon = await videoClipThumbnail(newVideoChosen);
      MediaInformation mediaInformation = await _flutterFFprobe
          .getMediaInformation(File(newVideoChosen.path).path);
      Map? videoInfo = mediaInformation.getMediaProperties();

      if (videoInfo != null && videoInfo.containsKey('duration')) {
        int videoDuration =
            (double.parse(videoInfo['duration']) * 1000).round();
        setState(() {
          project.media!.add(MediaClip(videoFile, videoIcon, true,
              Duration(milliseconds: videoDuration)));
        });
      } else {
        showAlert("Error", "Cannot process the video", context);
      }
    }
  }

  void pickFromGallery() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                    ),
                    title: const Text('Add images'),
                    onTap: () => {
                          print('Importing images!'),
                          Navigator.pop(context),
                          pickMultiImages()
                        }),
                ListTile(
                    leading: const Icon(
                      Icons.video_library,
                    ),
                    title: const Text('Add videos'),
                    onTap: () => {
                          print('Adding videos!'),
                          Navigator.pop(context),
                          pickVideo()
                        })
              ]),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var project = widget.project;
    Widget addMedia = VideoPlayerOrAddMedia(
        project: project,
        pickMultiImages: pickMultiImages,
        pickVideo: pickVideo);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: red,
          centerTitle: true,
          title: const AutoSizeText('Edit',
              maxFontSize: 25,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Myriad Pro',
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          leading: IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => widget.backPage))
            },
          ),
          actions: [
            IconButton(
                onPressed: doneEditing,
                icon: const Icon(Icons.navigate_next_rounded))
          ],
        ),
        backgroundColor: darkGrey,
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  child: ClipsTimeline(project: project))),
          Expanded(child: addMedia, flex: 6),
          Expanded(
              flex: 3,
              child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  color: Colors.black,
                  child: Column(children: [
                    const Expanded(child: EditingButtons()),
                    Expanded(
                        child: MediaClipScrollbar(
                            project: project, pickFromGallery: pickFromGallery))
                  ]))),
        ]));
  }
}
