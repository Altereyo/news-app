import 'package:news_app/data/models/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getTopHeadlines(String category);
  Future<List<NewsEntity>> getEverything(String category);
}
