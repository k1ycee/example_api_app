import 'dart:convert';
import 'dart:io';

import 'package:example_app/model/news_model.dart';
import 'package:example_app/util/failure.dart';
import 'package:http/http.dart' as http;

class ApiCallClass {

  Future<List<Article>> getNews() async {
    try {
      final news = await http.get(
        Uri.parse(
            "https://newsapi.org/v2/everything?q=tesla&from=2021-04-05&sortBy=publishedAt&apiKey=0033eec1ce834b8f93dbd041496980c9"),
      );
      if (news.statusCode == 200) {
        final Iterable rawJson = jsonDecode(news.body)["articles"];
        return rawJson.map((article) => Article.fromJson(article)).toList();
      } else {
        throw Failure(message: news.body.toString());
      }
    } on SocketException {
      throw Failure(message: "You are not connected to the Internet");
    } catch (error) {
      throw Failure(message: error.toString());
    }
  }
}
