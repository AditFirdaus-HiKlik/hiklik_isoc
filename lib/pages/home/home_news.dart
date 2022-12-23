import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/Pages/news_view_page.dart';
import 'package:isoc/api/isoc-api.dart';
import 'package:isoc/app/app_config.dart';
import 'package:isoc/contents_api.dart';
import 'package:isoc/sports_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeNews extends StatefulWidget {
  const HomeNews({super.key});

  @override
  State<HomeNews> createState() => _HomeNewsState();
}

class _HomeNewsState extends State<HomeNews> {

  static const _pageSize = 20;

  final PagingController<int, NewsData> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    
    try {
      final newItems = await getNews(category: appSportMode, page: pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => 
      PagedListView<int, NewsData>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<NewsData>(
          itemBuilder: (context, item, index) => _buildCard(item),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  // final RefreshController _refreshController =
  //     RefreshController(initialRefresh: true);

  // int page = 1;
  // bool isEndPage = false;
  // List<NewsData> newsDatas = [];

  // Future LoadFirst() async {
  //   isEndPage = false;
  //   page = 1;

  //   NewsApi.clearNews();
  //   await NewsApi.Load(category: appSportMode, page: page);
  //   newsDatas = NewsApi.newsList;
  // }

  // Future LoadMore() async {
  //   int tempPage = page + 1;

  //   final tempNewsDatas =
  //       await NewsApi.Load(category: appSportMode, page: tempPage);

  //   if (!isEndPage && tempNewsDatas.isNotEmpty) {
  //     isEndPage = false;
  //     page = tempPage;
  //   } else {
  //     isEndPage = true;
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return SmartRefresher(
  //     enablePullUp: true,
  //     header: const WaterDropHeader(),
  //     controller: _refreshController,
  //     onRefresh: _onRefresh,
  //     onLoading: _onLoading,
  //     child: SingleChildScrollView(
  //       clipBehavior: Clip.none,
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               Text(
  //                 AppLocalizations.of(context)!.home_news,
  //                 style: textH1,
  //               ),
  //               const Divider(
  //                 thickness: 1,
  //               ),
  //               _buildCardList(cachedNews),
  //             ]),
  //       ),
  //     ),
  //   );
  // }

  // Future _onRefresh() async {
  //   await LoadFirst();

  //   if (mounted) {
  //     setState(() {});
  //   }

  //   _refreshController.refreshCompleted();
  // }

  // Future _onLoading() async {
  //   await LoadMore();

  //   if (mounted) {
  //     setState(() {});
  //   }

  //   _refreshController.loadComplete();
  // }

  // Widget _buildCardList(List<NewsData> newsDatas) {
  //   return ListView.builder(
  //       clipBehavior: Clip.hardEdge,
  //       itemCount: cachedNews.length,
  //       shrinkWrap: true,
  //       primary: false,
  //       itemBuilder: (context, index) {
  //         return _buildCard(cachedNews[index]);
  //       });
  // }

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
