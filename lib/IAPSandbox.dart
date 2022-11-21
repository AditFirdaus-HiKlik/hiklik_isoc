import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:hiklik_sports/Pages/PaymentService.dart';
import 'package:hiklik_sports/sports_widget.dart';

class IAPSandbox extends StatefulWidget {
  @override
  State<IAPSandbox> createState() => _IAPSandboxState();
}

class _IAPSandboxState extends State<IAPSandbox> {
  @override
  void initState() {
    PaymentService.instance.addToProStatusChangedListeners(fetchData);
    PaymentService.instance.addToErrorListeners(fetchDataError);
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    PaymentService.instance.removeFromProStatusChangedListeners(fetchData);
    PaymentService.instance.removeFromErrorListeners(fetchDataError);
    super.dispose();
  }

  Future subscribe() async {
    scaffoldMessage(context, "Subscribing");
    await fetchData();
    PaymentService.instance.buyProduct(products.firstWhere(
        (element) => element.productId == 'sports_19000_streaming'));
  }

  bool isProUser = false;
  List<IAPItem> products = [];
  List<PurchasedItem> purchases = [];

  Future fetchData() async {
    isProUser = PaymentService.instance.isProUser;
    products = await PaymentService.instance.products;
    purchases = PaymentService.instance.pastPurchases;

    setState(() {});

    scaffoldMessage(context, "Fetching Data");
  }

  Future fetchDataError() async {
    scaffoldMessage(context, "Error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  onPressed: subscribe, child: const Text("Subscribe")),
              Text("isProUser: ${isProUser.toString()}"),
              Text("products: ${products.toString()}"),
              Text("pastPurchases: ${purchases.toString()}"),
            ],
          ),
        ),
      ),
    );
  }
}
