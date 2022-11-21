import 'dart:developer';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:hiklik_sports/Pages/PaymentService.dart';

PaymentService service = PaymentService.instance;
List<IAPItem> items = [];

Future fetchItems() async {
  items = await PaymentService.instance.products;
}

Future<IAPItem?> getItem(String id) async {
  await fetchItems();
  IAPItem? item =
      items.firstWhere((element) => element.productId == id, orElse: null);
  log("Item Fetched");
  return item;
}
