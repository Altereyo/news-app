import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:news_app/data/bookmark_repository.dart';
import 'package:news_app/data/models/news_entity.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final GetStorage _storage = GetStorage();

  @override
  Future<void> addBookmark(NewsEntity news) async {
    final List<NewsEntity> bookmarks = getBookmarkedNews();
    bookmarks.add(news);
    await _storage.write('bookmarks', jsonEncode(bookmarks));
  }

  @override
  Future<void> removeBookmark(NewsEntity news) async {
    final List<NewsEntity> bookmarks = getBookmarkedNews();
    final updatedBookmarks = bookmarks.where((bookmark) => bookmark.title != news.title).toList();
    await _storage.write('bookmarks', jsonEncode(updatedBookmarks));
  }

  @override
  List<NewsEntity> getBookmarkedNews() {
    final String? bookmarksString = _storage.read('bookmarks');
    if (bookmarksString == null || bookmarksString.isEmpty) {
      return [];
    }
    final List<NewsEntity> bookmarks = jsonDecode(bookmarksString);
    return bookmarks;
  }
}
