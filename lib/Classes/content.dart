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

int pageNews = 1;
int pageEvent = 1;
int pageMember = 1;
int pageLocation = 1;

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
    if (json.containsKey("featured_image"))
      featured_image = json['featured_image'].toString();
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
  String id = "";
  String featured_image = "";
  String title = "";
  String content = "";
  String author = "";

  NewsData(this.featured_image, this.title, this.content);

  NewsData.fromJson(Map<String, dynamic> json) {
    id = assign(json, "id");
    featured_image = assign(json, "featured_image");
    title = assign(json, "title");
    content = assign(json, "content");
    author = assign(json, "author");
  }

  String assign(Map<String, dynamic> json, String key) =>
      json.containsKey(key) ? json[key].toString() : "";
}

class StreamData {
  String name = "";
  String description = "";
  String url = "";

  StreamData(this.name, this.url);

  StreamData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("name")) name = json['name'].toString();
    if (json.containsKey("description"))
      description = json['description'].toString();
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

Future fetchLoadNews() async {
  var temp = await getNews(category: appSportMode, page: pageNews);
  if (temp.isNotEmpty) pageNews++;
  cachedNews += temp;
}

Future fetchLoadEvents() async {
  var temp = await getEvents(category: appSportMode, page: pageEvent);
  if (temp.isNotEmpty) pageEvent++;
  cachedEvent += temp;
}

Future fetchLoadMembers() async {
  var temp = await getMembers(category: appSportMode, page: pageMember);
  if (temp.isNotEmpty) pageMember++;
  cachedMember += temp;
}

Future fetchLoadLocations() async {
  var temp = await getLocations(category: appSportMode, page: pageLocation);
  if (temp.isNotEmpty) pageLocation++;
  cachedLocation += temp;
}

Future fetchLoadStreams() async {
  cachedStream = await getStreams();
}

Future fetchAll() async {
  pageNews = 2;
  pageEvent = 2;
  pageLocation = 2;

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
