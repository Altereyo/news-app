import 'package:news_app/data/models/news_entity.dart';

abstract class NewsUseCase {
  Future<List<NewsEntity>> fetchTopNews(String category);
  Future<List<NewsEntity>> fetchEverything(String category);
  Future<void> addBookmark(NewsEntity news);
  Future<void> removeBookmark(NewsEntity news);
  Future<List<NewsEntity>> getBookmarkedNews();
}