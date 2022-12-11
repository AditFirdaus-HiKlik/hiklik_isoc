// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/Pages/stream_page.dart';
import 'package:isoc/app/app_config.dart';
import 'package:isoc/services/entitlement.dart';
import 'package:isoc/services/purchase_api.dart';
import 'package:isoc/services/revenuecat.dart';
import 'package:isoc/sports_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class HomeStream extends StatefulWidget {
  const HomeStream({super.key});

  @override
  State<HomeStream> createState() => _HomeStreamState();
}

class _HomeStreamState extends State<HomeStream> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<String> productIdentifiers = ["subscription_streaming_19999_1m"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSubscribed() {
    final provider = Provider.of<RevenueCatProvider>(context, listen: false);

    return provider.subscriptionEntitlement ==
        SubscriptionEntitlement.subscribed;
  }

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
                      "Our Streams!",
                      style: textH1,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Consumer<RevenueCatProvider>(
                      builder: (context, provider, widget) {
                        if (provider.subscriptionEntitlement ==
                            SubscriptionEntitlement.subscribed) {
                          return const StreamCardList();
                        } else {
                          return Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "Subscribe to watch premium sport events",
                                  textAlign: TextAlign.center,
                                  style: textH2,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                packageCardList(productIdentifiers),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  ]),
            )));
  }

  Widget packageCardList(List<String> identifiers) {
    return FutureBuilder(
        future: PurchaseApi.fetchOffersByIDs(identifiers),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final offerings = snapshot.data!;
            final packages = offerings
                .map((e) => e.availablePackages)
                .expand((element) => element)
                .toList();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: packages.length,
              itemBuilder: (context, index) {
                return packageCard(packages[index]);
              },
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget packageCard(Package package) {
    final product = package.storeProduct;

    return Card(
      color: appColors[1],
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          title: Text(product.title),
          subtitle: Text(product.description),
          trailing: Text(product.priceString),
          onTap: () async {
            var result = await PurchaseApi.purchasePackage(package);

            final provider =
                Provider.of<RevenueCatProvider>(context, listen: false);

            log(result.toString());
          },
        ),
      ),
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

class StreamCardList extends StatelessWidget {
  const StreamCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        clipBehavior: Clip.hardEdge,
        itemCount: cachedStream.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return StreamCard(cachedStream[index]);
        });
  }
}

class StreamCard extends StatelessWidget {
  final StreamData _streamData;

  const StreamCard(this._streamData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: const Color(0xFFF5F5F5),
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
            child: StreamPage(_streamData),
            duration: const Duration(milliseconds: 500),
            reverseDuration: const Duration(milliseconds: 500),
          ));
        },
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
                  _streamData.name,
                  style: const TextStyle(
                    color: Color(0xFF2D3436),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
                        "Watch",
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
                        Icons.play_arrow,
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
