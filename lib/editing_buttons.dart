import 'package:bacc_studios/clip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditingButtons extends StatefulWidget {
  const EditingButtons({Key? key}) : super(key: key);

  @override
  _EditingButtonsState createState() => _EditingButtonsState();
}

class _EditingButtonsState extends State<EditingButtons> {
  void slideFromBottom(Widget widget) {
    showMaterialModalBottomSheet(
        context: context, builder: (context) => widget);
  }

  @override
  Widget build(BuildContext context) {
    var editIconsController = ScrollController();
    GlobalKey key = GlobalKey();
    return CupertinoScrollbar(
      key: key,
        isAlwaysShown: true,
        controller: editIconsController,
        child: ListView(
          itemExtent: 90,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: editIconsController,
          children: [
            // Column(children: [
            //   IconButton(
            //       icon: Icon(Icons.mic, size: 45, color: Colors.white),
            //       onPressed: () => slideFromBottom(Container(
            //             height: key,
            //             width: double.infinity,
            //             decoration: BoxDecoration(color: darkGrey),
            //           ))),
            //   const Text("Record",
            //       style: TextStyle(fontSize: 20, color: Colors.white))
            // ]),
            Column(children: const [
              Icon(Icons.photo_camera, size: 45, color: Colors.white),
              Text("Film", style: TextStyle(fontSize: 20, color: Colors.white))
            ]),
            Column(children: const [
              Icon(Icons.content_cut, size: 45, color: Colors.white),
              Text("Trim", style: TextStyle(fontSize: 20, color: Colors.white))
            ]),
            Column(children: const [
              Icon(Icons.crop, size: 45, color: Colors.white),
              Text("Crop", style: TextStyle(fontSize: 20, color: Colors.white))
            ]),
            Column(children: const [
              Icon(Icons.volume_up, size: 45, color: Colors.white),
              Text("Sound", style: TextStyle(fontSize: 20, color: Colors.white))
            ])
          ],
        ));
  }
}
