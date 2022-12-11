import 'dart:developer';

import 'package:isoc/debug.dart';
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
    var customDebug =
        CustomDebug("purchase_api.dart", "PuchaseApi", "fetchOffers", "$all");

    customDebug.writeLog(state: "[Start]");

    List<Offering> offerings = [];

    try {
      final fetchedOfferings = await Purchases.getOfferings();
      if (!all) {
        final current = fetchedOfferings.current;

        offerings = current == null ? [] : [current];
      } else {
        offerings = fetchedOfferings.all.values.toList();
      }

      customDebug.writeLog(state: "[Fetched]", value: offerings.toString());
    } catch (e) {
      customDebug.writeLog(state: "[Error]");
    }

    customDebug.writeLog(state: "[End]", value: offerings.toString());

    return offerings;
  }

  static Future<CustomerInfo?> purchasePackage(Package package) async {
    var customDebug = CustomDebug(
        "purchase_api.dart", "PuchaseApi", "purchasePackage", "$package");

    CustomerInfo? result;

    customDebug.writeLog(state: "[Start]");

    try {
      result = await Purchases.purchasePackage(package);

      customDebug.writeLog(state: "[Fetched]", value: result.toString());
    } catch (e) {
      result = null;
      customDebug.writeLog(state: "[Error]");
    }

    customDebug.writeLog(state: "[End]", value: result.toString());

    return result;
  }
}
