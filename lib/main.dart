import 'dart:io';
import 'package:bacc_studios/clip.dart';
import 'package:bacc_studios/projects_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bacc_studios/project.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bacc_studios/edit_page.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'other_functions.dart';

Color red = Colors.redAccent.shade700;
Color darkGrey = Colors.grey.shade900;
final FlutterFFprobe _flutterFFprobe = FlutterFFprobe();

/*
TODO: Resize timeline clips based on image and video length.
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return const MaterialApp(
      title: "Bacc Studios",
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Project> projectsList = [
    Project(
        title: "squid game",
        date: DateTime.fromMillisecondsSinceEpoch(1624129069000),
        thumbnail: Image.asset('images/thumbnail example.webp')),
    Project(
        title: "9/10/21 bri'ish edition",
        date: DateTime.fromMillisecondsSinceEpoch(1625079469000),
        thumbnail: Image.asset('images/thumbnail example.webp'))
  ];
  List<XFile>? newImagesChosen;
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

  void pickMultiImages() async {
    Project project = Project();
    newImagesChosen = await _picker.pickMultiImage();

    if (newImagesChosen != null && newImagesChosen!.isNotEmpty) {
      project.thumbnail = Image.file(File(newImagesChosen![0].path));
      project.media ??= [];

      setState(() {
        for (XFile xFileImage in newImagesChosen!) {
          File imageFile = File(xFileImage.path);
          Image image = Image.file(imageFile, fit: BoxFit.contain);
          project.media!.add(
              MediaClip(imageFile, image, false, const Duration(seconds: 1)));
        }
      });
    }

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditingPage(project, widget)));
  }

  void pickVideo() async {
    XFile? newVideoChosen =
        await _picker.pickVideo(source: ImageSource.gallery);
    Project project = Project();

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
        print("problem");
        showAlert("Error", "Cannot process the video", context);
      }
    }

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditingPage(project, widget)));
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => {
              showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          ListTile(
                              leading: const Icon(
                                Icons.folder_open_rounded,
                              ),
                              title: const Text('Create empty project'),
                              onTap: () => {
                                    print('Creating project from scratch'),
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditingPage(Project(), widget)))
                                  }),
                          ListTile(
                              leading: const Icon(
                                Icons.library_add_rounded,
                              ),
                              title: const Text('Import from camera roll'),
                              onTap: () => {
                                    print(
                                        'Creating project from camera roll assets'),
                                    Navigator.pop(context),
                                    pickFromGallery()
                                  })
                        ]),
                      ))
            },
            icon: const Icon(
              Icons.add_rounded,
            ),
          )
        ],
        title: Transform.scale(
            scale: 1.5,
            child: Row(
              children: [
                Image.asset('images/bacc logo.png', height: 25, width: 25),
                const Text(
                  'acc Studios',
                  style: TextStyle(
                      fontFamily: 'Myriad Pro', fontWeight: FontWeight.bold),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )),
        backgroundColor: red,
      ),
      backgroundColor: darkGrey,
      body: ProjectsList(projectsList),
    );
  }
}
