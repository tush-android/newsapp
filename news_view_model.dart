import 'package:flutternews/model/category_news.dart';
import 'package:flutternews/model/news_chhenel_headline_model.dart';
import 'package:flutternews/repository/news_repository.dart';

class NewsViewModel{
  final _api=newsRepository();
  Future<NewsChhnelsHeadlinesModel>  fetchnewsChannelHeadLinesApi(String source) async{
    final response=await _api.fetchnewsChannelHeadLinesApi(source);
    return response;
  }
  Future<category_news>  fetchcategorynewsApi(String category) async{
    final response=await _api.fetchcatogoriesNewsApi(category);
    return response;
  }
}