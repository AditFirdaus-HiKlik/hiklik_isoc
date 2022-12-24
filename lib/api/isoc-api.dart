import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../Classes/content.dart';

class NewsApi {
  final String _apiUrl = 'https://isoc.co.id/api/articles/posts';

  final int _limit = 10;

  int _startIndex = 0;

  final List<NewsData> _articles = [];

  final StreamController<List<NewsData>> _newsController = StreamController();

  bool isEmpty = false;

  bool isNotEmpty = false;

  Stream<List<NewsData>> get newsStream => _newsController.stream;

  Future<List<NewsData>> fetchNews({
    bool onScrollMax = false,
  }) async {
    final response = await http.get(
      Uri.parse('$_apiUrl?start=$_startIndex&limit=$_limit'),
    );
    if (response.statusCode == 200) {
      List newsDataJson = json.decode(response.body);
      if (onScrollMax) {
        _startIndex += _limit;
      }

      return newsDataJson
          .map((newsData) => NewsData.fromJson(newsData))
          .toList();
    } else {
      throw Exception('Failed to load article');
    }
  }

  void loadMoreNews() {
    fetchNews(onScrollMax: true).then((value) {
      if (value.isNotEmpty) {
        _articles.addAll(value);
        _newsController.sink.add(_articles);
        isNotEmpty = value.isNotEmpty;
      }
      if (value.isEmpty) {
        isEmpty = value.isEmpty;
      }
    });
  }
}
