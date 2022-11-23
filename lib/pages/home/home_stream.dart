// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:hiklik_sports/Classes/content.dart';
import 'package:hiklik_sports/Classes/iap.dart';
import 'package:hiklik_sports/Pages/payment_service.dart';
import 'package:hiklik_sports/Pages/stream_page.dart';
import 'package:hiklik_sports/app/app_config.dart';
import 'package:hiklik_sports/sports_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeStream extends StatefulWidget {
  const HomeStream({super.key});

  @override
  State<HomeStream> createState() => _HomeStreamState();
}

class _HomeStreamState extends State<HomeStream> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  IAPItem? streamingSubscription;

  static bool purchased = false;

  static bool loading = false;

  static bool connectedToInternet = false;

  Future toPayment() async {
    log("Buying");
    setState(() {
      purchased = true;
    });

    final result =
        await PaymentService.instance.buyProduct(streamingSubscription!);

    log("result: $result");

    log("Subscription Complete");
  }

  @override
  void initState() {
    loading = false;
    connectedToInternet = true;
    PaymentService.instance.addToProStatusChangedListeners(subscriptionChanged);
    fetchSubscription();
    super.initState();
  }

  @override
  void dispose() {
    PaymentService.instance
        .removeFromProStatusChangedListeners(subscriptionChanged);
    super.dispose();
  }

  void subscriptionChanged() async {
    fetchSubscription();
    scaffoldMessage(context, streamingSubscription.toString());
  }

  Future fetchSubscription() async {
    setState(() {
      loading = true;
    });
    log("Loading");
    streamingSubscription = await getItem("sports_19000_streaming");
    // purchased = PaymentService.instance.isProUser;
    log("Loading Finished");
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      header: const WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: !loading
          ? SingleChildScrollView(
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
                      purchased
                          ? const StreamCardList()
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 48,
                                  ),
                                  Icon(
                                    Icons.warning_rounded,
                                    color: appColors[3],
                                  ),
                                  Text(
                                    "You must subscribe to watch our content",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: appColors[3],
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  connectedToInternet
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: appColors[3],
                                            minimumSize: const Size(128, 32),
                                          ),
                                          onPressed: toPayment,
                                          child: Text(streamingSubscription!
                                              .localizedPrice!))
                                      : const Text(
                                          "You're not connected to the Server"),
                                ],
                              ),
                            ),
                    ]),
              ))
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: appColors[3],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text("Verifying Purchases..."),
                ],
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
          log(cachedStream.toString());
          return StreamCard(cachedStream[index], "streamCard$index");
        });
  }
}

class StreamCard extends StatelessWidget {
  final heroTag;
  final StreamData _streamData;

  const StreamCard(this._streamData, this.heroTag, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Card(
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
              child: StreamPage(_streamData, heroTag),
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
      ),
    );
  }
}
