import 'package:news_app/data/models/news_entity.dart';

abstract class BookmarkRepository {
  Future<void> addBookmark(NewsEntity news);
  Future<void> removeBookmark(NewsEntity news);
  Future<List<NewsEntity>> getBookmarkedNews();
}
