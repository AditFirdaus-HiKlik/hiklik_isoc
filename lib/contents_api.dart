import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isoc/Classes/content.dart';
import 'package:isoc/Classes/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:isoc/debug.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<UserData>> getMembers({String category = "", int page = 1}) async {
  var customDebug =
      CustomDebug("contents_api.dart", "", "getMembers", category);

  customDebug.writeLog(state: "[Start]");

  List<UserData> users = [];

  try {
    QuerySnapshot<Map<String, dynamic>> usersRef;

    if (category == "") {
      usersRef = await db.collection("users").limit(10).get();
    } else {
      usersRef = await db
          .collection("users")
          .where('sport', isEqualTo: category)
          .limit(10)
          .get();
    }

    for (var doc in usersRef.docs) {
      users.add(UserData.fromJson(doc.data()));
    }

    customDebug.writeLog(state: "[Fetched]", value: usersRef.toString());
  } catch (e) {
    customDebug.writeLog(state: "[Error]");
  }

  customDebug.writeLog(state: "[End]");

  return users;
}

Future<List<StreamData>> getStreams() async {
  var customDebug = CustomDebug("contents_api.dart", "", "getStreams", "");

  customDebug.writeLog(state: "[Start]");

  List<StreamData> streams = [];

  try {
    QuerySnapshot<Map<String, dynamic>> streamingRef;

    streamingRef = await db.collection("streaming").get();

    for (var doc in streamingRef.docs) {
      streams.add(StreamData.fromJson(doc.data()));
    }

    customDebug.writeLog(state: "[Fetched]", value: streamingRef.toString());
  } catch (e) {
    customDebug.writeLog(state: "[Error]");
  }

  customDebug.writeLog(state: "[End]");

  return streams;
}

Future<List<NewsData>> getNews({String category = "", int page = 1}) async {
  var customDebug = CustomDebug("contents_api.dart", "", "getNews", category);

  customDebug.writeLog(state: "[Start]");

  String endpoint = 'https://isoc.co.id/api/articles?';

  if (category != "") endpoint += 'category=$category';
  if (page != 0) endpoint += 'page=$page';

  List<NewsData> news = [];

  // try {

  final response = await http.get(Uri.parse(endpoint));

  log(response.body);

  String body = response.body;

  Map<String, dynamic> map = jsonDecode(body);

  for (var newsJson in map["data"]["data"]) {
    news.add(NewsData.fromJson(newsJson));
  }

  customDebug.writeLog(state: "[Fetched]", value: map.toString());
  // } catch (e) {
  //   customDebug.writeLog(state: "[Error]");
  // }

  customDebug.writeLog(state: "[End]");

  return news;
}

Future<List<EventData>> getEvents({String category = "", int page = 1}) async {
  var customDebug = CustomDebug("contents_api.dart", "", "getEvents", category);

  customDebug.writeLog(state: "[Start]");

  String endpoint = 'https://isoc.co.id/api/events?';

  if (category != "") endpoint += 'category=$category';
  if (page != 0) endpoint += 'page=$page';

  List<EventData> events = [];

  try {
    final response = await http.get(Uri.parse(endpoint));

    String body = response.body;

    Map<String, dynamic> map = jsonDecode(body);

    for (var eventJson in map["data"]["data"]) {
      events.add(EventData.fromJson(eventJson));
    }

    customDebug.writeLog(state: "[Fetched]", value: map.toString());
  } catch (e) {
    customDebug.writeLog(state: "[Error]");
  }

  customDebug.writeLog(state: "[End]");

  return events;
}

Future<List<LocationData>> getLocations(
    {String category = "", int page = 1}) async {
  var customDebug =
      CustomDebug("contents_api.dart", "", "getLocations", category);

  customDebug.writeLog(state: "[Start]");

  String endpoint = 'https://isoc.co.id/api/locations?';

  if (category != "") endpoint += 'category=$category';
  if (page != 0) endpoint += 'page=$page';

  List<LocationData> locations = [];

  try {
    final response = await http.get(Uri.parse(endpoint));

    String body = response.body;

    Map<String, dynamic> map = jsonDecode(body);

    for (var newsJson in map["data"]["data"]) {
      locations.add(LocationData.fromJson(newsJson));
    }

    customDebug.writeLog(state: "[Fetched]", value: map.toString());
  } catch (e) {
    customDebug.writeLog(state: "[Error]");
  }

  customDebug.writeLog(state: "[End]");

  return locations;
}
