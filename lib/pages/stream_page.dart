// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/app/app_config.dart';
import 'package:isoc/sports_widget.dart';
import 'package:video_player/video_player.dart';

class StreamPage extends StatefulWidget {
  final StreamData _streamData;

  const StreamPage(this._streamData, {super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  late VideoPlayerController _controller = VideoPlayerController.network("");

  String error = "";

  String get hlsURL => widget._streamData.url;

  void toBack() {
    Navigator.of(context).pop();
  }

  Future initializeVideo() async {
    if (error != "") scaffoldMessage(context, error);

    log(hlsURL);

    _controller = VideoPlayerController.network(
      hlsURL,
    )..initialize().then((_) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: _controller,
            autoPlay: true,
            looping: true,
            errorBuilder: (context, errorMessage) {
              return Text(errorMessage);
            },
          );
        });
      }).onError((error, stackTrace) async {
        error == error.toString();
      });
  }

  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(videoPlayerController: _controller);
    initializeVideo();
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
    _controller.dispose();
  }

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
                      child: (_controller.value.isInitialized)
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Chewie(controller: chewieController),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                    ),
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
