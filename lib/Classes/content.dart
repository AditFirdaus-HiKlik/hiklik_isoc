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
  String featured_image = "";
  String title = "";
  String type = "";
  String date_time = "";
  String address = "";
  String phone = "";

  EventData(this.featured_image, this.title, this.type, this.date_time,
      this.address, this.phone);

  EventData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("featured_image")) featured_image = json['featured_image'].toString();
    if (json.containsKey("title")) title = json['title'].toString();
    if (json.containsKey("type")) type = json['type'].toString();
    if (json.containsKey("date_time")) date_time = json['date_time'].toString();
    if (json.containsKey("address")) address = json['address'].toString();
    if (json.containsKey("phone")) phone = json['phone'].toString();
  }

  DateTime? getDateTime() {
    return DateTime.tryParse(date_time);
  }
}

class LocationData {
  String title = "";
  String address = "";
  String phone = "";
  String link = "";

  LocationData(this.title, this.address, this.phone, this.link);

  LocationData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("title")) title = json['title'].toString();
    if (json.containsKey("address")) address = json['address'].toString();
    if (json.containsKey("phone")) phone = json['phone'].toString();
    if (json.containsKey("link")) link = json['link'].toString();
  }
}

class NewsData {
  String featured_image = "";
  String title = "";
  String content = "";
  String author = "";

  NewsData(this.featured_image, this.title, this.content);

  NewsData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("featured_image")) featured_image = json['featured_image'].toString();
    if (json.containsKey("title")) title = json['title'].toString();
    if (json.containsKey("content")) content = json['content'].toString();
    if (json.containsKey("author")) author = json['author'].toString();
  }
}

class StreamData {
  String name = "";
  String description = "";
  String url = "";

  StreamData(this.name, this.url);

  StreamData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("name")) name = json['name'].toString();
    if (json.containsKey("description")) description = json['description'].toString();
    if (json.containsKey("url")) url = json['url'].toString();
  }
}

Future fetchNews() async {
  cachedNews = await getNews(category: appSportMode);
}

Future fetchEvents() async {
  cachedEvent = await getEvents(category: appSportMode);
}

Future fetchMembers() async {
  cachedMember = await getMembers(category: appSportMode);
}

Future fetchLocations() async {
  cachedLocation = await getLocations(category: appSportMode);
}

Future fetchStreams() async {
  cachedStream = await getStreams();
}

Future fetchAll() async {
  await fetchNews();
  await fetchEvents();
  await fetchLocations();
  await fetchStreams();
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
