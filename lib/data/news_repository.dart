import 'package:news_app/data/models/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getTopNews();
  Future<List<NewsEntity>> getEverything();
}
