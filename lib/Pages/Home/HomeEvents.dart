import 'package:flutter/material.dart';
import 'package:hiklik_sports/Classes/content.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:intl/intl.dart';
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
            padding: const EdgeInsets.all(24.0),
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

class EventCard extends StatelessWidget {
  final EventData _eventData;

  const EventCard(this._eventData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.parse(_eventData.date);
    String formattedDate = DateFormat.yMMMEd().format(now);
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: const Color(0xFFF5F5F5),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              formattedDate,
              style: const TextStyle(),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
              child: Text(
                _eventData.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _eventData.address,
                      style: const TextStyle(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    child: Icon(
                      Icons.phone_iphone,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                  Expanded(
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
      ),
    );
  }
}
