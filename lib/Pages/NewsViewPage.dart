
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hiklik_sports/Classes/content.dart';
import 'package:hiklik_sports/config.dart';

class NewsViewPage extends StatefulWidget {
  final NewsData _newsData;

  const NewsViewPage(this._newsData, {super.key});

  @override
  State<NewsViewPage> createState() => _NewsViewPageState();
}

class _NewsViewPageState extends State<NewsViewPage> {
  void toBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ClipRect(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appColors[0],
            leading: IconButton(
                onPressed: toBack,
                icon: Icon(
                  Icons.arrow_circle_left_outlined,
                  color: appColors[3],
                )),
          ),
          body: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget._newsData.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16,),
                      CachedNetworkImage(
                        height: 256,
                        imageUrl: widget._newsData.featured_image,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return const Image(
                            image: AssetImage('assets/no_image.png'),
                            fit: BoxFit.cover,
                            height: 256,
                          );
                        },
                        progressIndicatorBuilder: (context, url, progress) {
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                      const Divider(thickness: 1, height: 32,),
                      Html(data: widget._newsData.content),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
