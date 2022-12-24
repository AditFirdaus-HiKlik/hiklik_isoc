import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/Pages/news_view_page.dart';
import 'package:isoc/api/isoc-api.dart';
// import 'package:isoc/app/app_config.dart';
// import 'package:isoc/contents_api.dart';
import 'package:isoc/sports_widget.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeNews extends StatefulWidget {
  const HomeNews({super.key});

  @override
  State<HomeNews> createState() => _HomeNewsState();
}

class _HomeNewsState extends State<HomeNews> {
  NewsApi? _newsApi;

  bool _isLoading = false;

  List<NewsData> _news = [];

  @override
  void initState() {
    super.initState();
    _newsApi = NewsApi();

    _newsApi!.newsStream.listen((news) {
      setState(() {
        _news = news;
        _isLoading = false;
      });
    });

    _newsApi!.loadMoreNews();
  }

  @override
  Widget build(BuildContext context) => NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            if (_newsApi!.isEmpty) {
              setState(() {
                _isLoading = false;
              });
            } else {
              if (!_isLoading) {
                setState(() {
                  _isLoading = true;
                });
                _newsApi!.loadMoreNews();
              }
            }
          }
          return true;
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: _news.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _news.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: Column(
                    children: const [
                      Divider(
                        thickness: 2,
                        height: 20,
                      ),
                      SizedBox(height: 10),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            }
            return _buildCard(_news[index]);
          },
        ),
      );

  Widget _buildCard(NewsData newsData) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewsViewPage(newsData)),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: CachedNetworkImage(
                    height: 96,
                    imageUrl: newsData.featured_image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return const Image(
                        image: AssetImage('assets/no_image.png'),
                        fit: BoxFit.cover,
                      );
                    },
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                            child: CircularProgressIndicator(
                      value: progress.progress,
                    )),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    child: Text(
                      newsData.title,
                      style: textH4,
                      maxLines: 3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
