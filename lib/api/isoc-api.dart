import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../Classes/content.dart';

class NewsApi {
  static String endpoint = "https://isoc.co.id/api/articles";

  static Map<String, NewsData> newsMap = {};
  static List<NewsData> get newsList => newsMap.values.toList();

  static void clearNews() => newsMap = {};

  static Future<List<NewsData>> Load(
      {String category = "", int page = 1}) async {
    List<NewsData> tempNews = [];

    String finalEndpoint = "$endpoint?category=$category&page=$page";

    log("Final Endpoint: $finalEndpoint");

    try {
      final response = await http.get(Uri.parse(finalEndpoint));

      String body = response.body;

      Map<String, dynamic> map = jsonDecode(body);

      for (var newsJson in map["data"]["data"]) {
        tempNews.add(NewsData.fromJson(newsJson));
      }
    } catch (e) {
      log("Error");
    }

    // Register to map
    for (var news in tempNews) {
      String id = news.id;
      if (newsMap.containsKey(id)) {
        newsMap[id] = news;
      } else {
        log(id);
        newsMap.addEntries({MapEntry(id, news)});
      }
    }

    return newsMap.values.toList();
  }
}
