import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/sports_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeLocations extends StatefulWidget {
  const HomeLocations({super.key});

  @override
  State<HomeLocations> createState() => _HomeLocationsState();
}

class _HomeLocationsState extends State<HomeLocations> {
  
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
                AppLocalizations.of(context)!.home_locations,
                style: textH1,
              ),
              const Divider(
                thickness: 1,
              ),
              ListView.builder(
                clipBehavior: Clip.hardEdge,
                itemCount: cachedLocation.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return LocationCard(cachedLocation[index]);
                }
              ),
            ]
          ),
        )
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

class LocationCard extends StatelessWidget {
  final LocationData _locationData;

  const LocationCard(this._locationData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: const Color(0xFFF5F5F5),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Slidable(
        key: const ValueKey(0),

        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                launchUrlString(_locationData.link, mode: LaunchMode.externalApplication);
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.directions,
              label: 'Direction',
            ),
            SlidableAction(
              onPressed: (context) {
                launchUrlString("tel:${_locationData.phone}");
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.call,
              label: 'Call',
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Text(
                  _locationData.title,
                  style: const TextStyle(
                    color: Color(0xFF2D3436),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                      child: Icon(
                        Icons.location_pin,
                        color: Color(0xFF2D3436),
                        size: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _locationData.address,
                        style: const TextStyle(
                          color: Color(0xFF2D3436),
                          fontSize: 16,
                        ),
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
                        color: Color(0xFF2D3436),
                        size: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _locationData.phone,
                        style: const TextStyle(
                          color: Color(0xFF2D3436),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Expanded(
                      child: Text(
                        "Slide to expand",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color(0xFF2D3436),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Icon(
                        Icons.swipe_left,
                        color: Color(0xFF2D3436),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

