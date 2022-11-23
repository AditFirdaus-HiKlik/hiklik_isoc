import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiklik_sports/Classes/content.dart';
import 'package:hiklik_sports/Classes/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

FirebaseFirestore db = FirebaseFirestore.instance;

   Future<List<UserData>> getMembers({String category = ""}) async {
    List<UserData> users = [];

    QuerySnapshot<Map<String, dynamic>> productRef;

    if (category == "")
    {
      productRef = await db.collection("users").get();
    }
    else
    {
      productRef = await db.collection("users").where('sport', isEqualTo: category).get();
    }
    for (var doc in productRef.docs) {
      users.add(UserData.fromJson(doc.data()));
    }

    return users;
  }

   Future<List<StreamData>> getStreams() async {
    List<StreamData> streams = [];

    QuerySnapshot<Map<String, dynamic>> productRef;
      
    productRef = await db.collection("streaming").get();

    for (var doc in productRef.docs) {
      streams.add(StreamData.fromJson(doc.data()));
    }

    return streams;
  }

   Future<List<NewsData>> getNews({String category = ""}) async {
    List<NewsData> news = [];

    try {
      final response = await http.get(Uri.parse('http://hiklik-sports.herokuapp.com/api/articles?category=$category'));

      String body = response.body;
      
      Map<String, dynamic> map = jsonDecode(body);

      for (var newsJson in map["data"]["data"]) {
        news.add(NewsData.fromJson(newsJson));
      }
    } catch (e) {
      log("Fetch news failed");
    }

    return news;
  }

   Future<List<EventData>> getEvents({String category = ""}) async {
    List<EventData> news = [];

    try {
      final response = await http.get(Uri.parse(
          'http://hiklik-sports.herokuapp.com/api/events?category=$category'));

      String body = response.body;

      Map<String, dynamic> map = jsonDecode(body);

      for (var eventJson in map["data"]["data"]) {
        news.add(EventData.fromJson(eventJson));
      }
    } catch (e) {
      log("Fetch events failed");
    }

    return news;
  }

  Future<List<LocationData>> getLocations({String category = ""}) async {
    List<LocationData> news = [];

    try {
      final response = await http.get(Uri.parse(
          'http://hiklik-sports.herokuapp.com/api/locations?category=$category'));

      String body = response.body;

      Map<String, dynamic> map = jsonDecode(body);

      for (var newsJson in map["data"]["data"]) {
        news.add(LocationData.fromJson(newsJson));
      }
    } catch (e) {
      log("Fetch locations failed");
    }

    return news;
  }