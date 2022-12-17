// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/app/app_config.dart';
import 'package:isoc/sports_widget.dart';

class StreamPage extends StatefulWidget {
  final StreamData _streamData;

  const StreamPage(this._streamData, {super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {

  final double playerWidth = 640;
  final double playerHeight = 360;

  late VlcPlayerController controller;

  String error = "";

  String get hlsURL => widget._streamData.url;

  void toBack() {
    Navigator.of(context).pop();
  }

  Future initializeVideo() async {
    if (error != "") scaffoldMessage(context, error);

    log(hlsURL);

    controller = VlcPlayerController.network(hlsURL);

    log(controller.toString());

    // controller
    //     .initialize()
    //     .then((value) => setState(() {}))
    //     .onError((error, stackTrace) => log(error.toString()));
  }

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appColors[0],
          leading: IconButton(
              onPressed: toBack,
              icon: Icon(
                Icons.arrow_circle_left_outlined,
                color: appColors[3],
              )),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.black,
                  clipBehavior: Clip.antiAlias,
                  child: AspectRatio(
                    aspectRatio: 1.777,
                    child: Center(
                        child: VlcPlayer(
                      aspectRatio: 16 / 9,
                      controller: controller,
                      placeholder:
                          const Center(child: CircularProgressIndicator()),
                    )),
                  ),
                ),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: appColors[0],
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget._streamData.name,
                          style: textH3,
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Text(
                          widget._streamData.description,
                          style: textH4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
