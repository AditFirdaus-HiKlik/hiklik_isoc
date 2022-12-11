import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isoc/services/entitlement.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  SubscriptionEntitlement _subscriptionEntitlement =
      SubscriptionEntitlement.notsubscribed;
  SubscriptionEntitlement get subscriptionEntitlement =>
      _subscriptionEntitlement;

  Future init() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      updatePurchaseStatus();
    });

    updatePurchaseStatus();
  }

  Future updatePurchaseStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();

    final entitlements = customerInfo.entitlements.active.values.toList();

    _subscriptionEntitlement = entitlements.isNotEmpty
        ? SubscriptionEntitlement.subscribed
        : SubscriptionEntitlement.notsubscribed;

    notifyListeners();
  }

  Future tooglePurchaseStatus() async {
    _subscriptionEntitlement =
        _subscriptionEntitlement == SubscriptionEntitlement.notsubscribed
            ? SubscriptionEntitlement.subscribed
            : SubscriptionEntitlement.notsubscribed;
    notifyListeners();
  }
}
