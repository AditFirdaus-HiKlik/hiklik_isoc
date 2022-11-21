import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_sports/Classes/content.dart';
import 'package:hiklik_sports/Pages/NewsViewPage.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class HomeNews extends StatefulWidget {
  const HomeNews({super.key});

  @override
  State<HomeNews> createState() => _HomeNewsState();
}

class _HomeNewsState extends State<HomeNews> {

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      header: const WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.home_news,
                  style: textH1,
                ),
                const Divider(
                  thickness: 1,
                ),
                ListView.builder(
                          clipBehavior: Clip.hardEdge,
                          itemCount: cachedNews.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return NewsCard(cachedNews[index]);
                          }),
              ]),
        ),
      ),
    );
  }

  Future _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    await fetchAll();

    if (mounted) {
      setState(() {});
    }

    _refreshController.refreshCompleted();
  }

  Future _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }
}

class NewsCard extends StatelessWidget {
  final NewsData _newsData;

  const NewsCard(this._newsData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(PageTransition(
            type: PageTransitionType.size,
            curve: Curves.easeInOutQuart,
            childCurrent: this,
            alignment: Alignment.bottomCenter,
            child: NewsViewPage(_newsData),
            duration: const Duration(milliseconds: 500),
          ));
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
                    imageUrl:
                        _newsData.featured_image,
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
                      _newsData.title,
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
