import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutternews/model/news_chhenel_headline_model.dart';
import 'package:http/http.dart' as http;

import '../model/category_news.dart';
class newsRepository{
  Future<NewsChhnelsHeadlinesModel> fetchnewsChannelHeadLinesApi(String source) async{
    String url="https://newsapi.org/v2/top-headlines?sources=$source&apiKey=c671d0ffd3d34b3588479c5758155d1f";
    final responce=await http.get(Uri.parse(url));
    if(kDebugMode){
      print(responce.body);
    }
    if(responce.statusCode==200){
      final body=jsonDecode(responce.body);
      return NewsChhnelsHeadlinesModel.fromJson(body);
    }
    throw Exception("Error");
  }
  Future<category_news> fetchcatogoriesNewsApi(String cat) async{
    String url="https://newsapi.org/v2/everything?q=${cat}&apiKey=c671d0ffd3d34b3588479c5758155d1f";
    final responce=await http.get(Uri.parse(url));
    if(kDebugMode){
      print(responce.body);
    }
    if(responce.statusCode==200){
      final body=jsonDecode(responce.body);
      return category_news.fromJson(body);
    }
    throw Exception("Error");
  }
}