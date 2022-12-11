import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isoc/app/app_config.dart';
import 'package:isoc/services/purchase_api.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: PurchaseApi.fetchOffers(),
          builder: (context, snapshot) {
            log(snapshot.toString());

            final offerings = snapshot.data;

            final packages = offerings!
                .map((e) => e.availablePackages)
                .expand((element) => element)
                .toList();

            if (packages.isNotEmpty) {
              return ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  return paywallPackage(packages[index]);
                },
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget paywallPackage(Package package) {
    final product = package.storeProduct;

    return Card(
      color: appColors[1],
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(product.title),
        subtitle: Text(product.description),
        trailing: Text(product.priceString),
        onTap: () {},
      ),
    );
  }
}
