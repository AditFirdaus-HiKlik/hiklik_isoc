import 'dart:developer';

import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKey = 'goog_OFHcVJoNjpsamRYUQOEghXygjtB';

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  static Future<List<Offering>> fetchOffersByIDs(List<String> ids) async {
    final offers = await fetchOffers();

    return offers.where((offer) => ids.contains(offer.identifier)).toList();
  }

  static Future<List<Offering>> fetchOffers({bool all = true}) async {
    // try {
    final offerings = await Purchases.getOfferings();
    log(offerings.toString());
    if (!all) {
      final current = offerings.current;

      return current == null ? [] : [current];
    } else {
      return offerings.all.values.toList();
    }
    // } catch (e) {
    //   return [];
    // }
  }

  static Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      return await Purchases.purchasePackage(package);
    } catch (e) {
      return null;
    }
  }
}
