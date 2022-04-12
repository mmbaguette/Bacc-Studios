import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bacc_studios/project.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';

Color red = Colors.redAccent.shade700;
Color darkGrey = Colors.grey.shade900;

final String defaultLocale = Platform.localeName;

class ProjectsList extends StatefulWidget {
  final List<Project> projectsList;

  const ProjectsList(this.projectsList, {Key? key}) : super(key: key);

  @override
  _ProjectsListState createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
        child: ListView.builder(
      itemCount: widget.projectsList.length,
      itemBuilder: (BuildContext context, int index) {
        Project project = widget.projectsList[index];
        return SizedBox(
            height: 230,
            child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                            decoration: BoxDecoration(
                                color: red,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: AutoSizeText(project.title!,
                                          maxFontSize: 25,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontFamily: 'Myriad Pro',
                                              fontWeight: FontWeight.normal))),
                                  flex: 2,
                                ),
                                Text(
                                    DateFormat.yMd(defaultLocale)
                                        .format(project.date!),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Myriad Pro',
                                        fontWeight: FontWeight.normal)),
                                IconButton(
                                    icon: const Icon(Icons.edit_rounded,
                                        color: Colors.white),
                                    onPressed: () => {
                                          print(
                                              "Editing project ${project.title}")
                                        })
                              ],
                            ))),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Colors.black,
                                image: DecorationImage(
                                  image: project.thumbnail!.image,
                                  fit: BoxFit.fitHeight,
                                ))),
                        flex: 4)
                  ],
                )));
      },
    ));
  }
}
