// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';

import 'package:isoc/Classes/user.dart';
import 'package:ntp/ntp.dart';
import 'package:isoc/app/app_config.dart';
import 'package:isoc/contents_api.dart';

List<NewsData> cachedNews = [];
List<EventData> cachedEvent = [];
List<UserData> cachedMember = [];
List<LocationData> cachedLocation = [];
List<StreamData> cachedStream = [];

class EventData {
  String title = "";
  String address = "";
  String phone = "";
  String date = "";

  EventData(this.title, this.address, this.phone);

  EventData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("title")) title = json['title'];
    if (json.containsKey("address")) address = json['address'];
    if (json.containsKey("phone")) phone = json['phone'];
    if (json.containsKey("date")) date = json['date'];
  }
}

class LocationData {
  String title = "";
  String address = "";
  String phone = "";
  String link = "";

  LocationData(this.title, this.address, this.phone);

  LocationData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("title")) title = json['title'];
    if (json.containsKey("address")) address = json['address'];
    if (json.containsKey("phone")) phone = json['phone'];
    if (json.containsKey("link")) link = json['link'];
  }
}

class NewsData {
  String featured_image = "";
  String title = "";
  String content = "";

  NewsData(this.featured_image, this.title, this.content);

  NewsData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("featured_image")) {
      featured_image = json['featured_image'];
    }
    if (json.containsKey("title")) title = json['title'];
    if (json.containsKey("content")) content = json['content'];
  }
}

class StreamData {
  String name = "";
  String description = "";
  String id = "";

  StreamData(this.name, this.id);

  StreamData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("name")) name = json['name'];
    if (json.containsKey("description")) description = json['description'];
    if (json.containsKey("id")) id = json['id'];

    log(description);
  }
}

Future fetchNews() async {
  log("Fetching News: Started...", name: "sign_in_page.dart");
  cachedNews = await getNews(category: appSportMode);
  log("Fetching News: Ended...", name: "sign_in_page.dart");
}

Future fetchEvents() async {
  log("Fetching Event: Started...", name: "content.dart");
  cachedEvent = await getEvents(category: appSportMode);
  log("Fetching Event: Ended...", name: "content.dart");
}

Future fetchMembers() async {
  log("Fetching Member: Started...", name: "content.dart");
  cachedMember = await getMembers(category: appSportMode);
  log("Fetching Member: Ended...", name: "content.dart");
}

Future fetchLocations() async {
  log("Fetching Location: Started...", name: "content.dart");
  cachedLocation = await getLocations(category: appSportMode);
  log("Fetching Location: Ended...", name: "content.dart");
}

Future fetchStreams() async {
  log("Stream: Fetching News Started...", name: "content.dart");
  cachedStream = await getStreams();
  log("Stream: Fetching News Ended...", name: "content.dart");
}

Future fetchAll() async {
  await fetchNews();
  await fetchEvents();
  await fetchLocations();
  // await fetchStreams();
}

Future<DateTime> internetTime() async {
  if (await isConnectedToInternet()) {
    return NTP.now();
  } else {
    return DateTime.now();
  }
}

Future<bool> isConnectedToInternet() async {
  bool connectionResult = false;
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      connectionResult = true;
    }
  } on SocketException catch (_) {}

  log("Checking Connection... $connectionResult");

  return connectionResult;
}
