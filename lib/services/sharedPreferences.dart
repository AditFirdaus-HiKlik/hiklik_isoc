// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

Future<SharedPreferences> initializeSharedPreferences() async {
  return sharedPreferences = await SharedPreferences.getInstance();
}