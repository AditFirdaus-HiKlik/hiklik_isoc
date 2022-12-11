import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/sports_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeEvents extends StatefulWidget {
  const HomeEvents({super.key});

  @override
  State<HomeEvents> createState() => _HomeEventsState();
}

class _HomeEventsState extends State<HomeEvents> {
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
                    AppLocalizations.of(context)!.home_events,
                    style: textH1,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  ListView.builder(
                      clipBehavior: Clip.hardEdge,
                      itemCount: cachedEvent.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return EventCard(cachedEvent[index]);
                      }),
                ]),
          )),
    );
  }

  Future _onRefresh() async {
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

class EventCard extends StatelessWidget {
  final EventData _eventData;

  const EventCard(this._eventData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? dateTime = _eventData.getDateTime();

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: const Color(0xFFF5F5F5),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            height: 128,
            imageUrl: _eventData.featured_image,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return const Image(
                image: AssetImage('assets/no_image.png'),
                fit: BoxFit.cover,
              );
            },
            progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
              value: progress.progress,
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (dateTime != null) Text(
                  "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                  textAlign: TextAlign.right,
                  style: const TextStyle(),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                  child: Text(
                    _eventData.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                  child: Text(
                    _eventData.type,
                    style: const TextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                  child: Text(
                    _eventData.address,
                    style: const TextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                  child: Text(
                    _eventData.phone,
                    style: const TextStyle(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
