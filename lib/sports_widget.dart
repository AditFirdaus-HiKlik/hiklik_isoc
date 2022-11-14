import 'package:flutter/material.dart';
import 'package:hiklik_sports/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

TextStyle textH1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: appColors[3],
);

TextStyle textH2 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: appColors[3],
);

TextStyle textH3 = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: appColors[3],
);

TextStyle textH4 = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: appColors[2],
);

TextStyle textH5 = TextStyle(
  fontSize: 8,
  fontWeight: FontWeight.w500,
  color: appColors[2],
);

void scaffoldMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
