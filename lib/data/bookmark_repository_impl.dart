import 'package:get_storage/get_storage.dart';
import 'package:news_app/data/bookmark_repository.dart';
import 'package:news_app/data/models/news_entity.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final GetStorage _storage = GetStorage();

  @override
  Future<void> addBookmark(NewsEntity news) async {
    final List<NewsEntity>? bookmarks = _storage.read('bookmarks');

    final List<NewsEntity> updatedBookmarks = bookmarks ?? [];
    updatedBookmarks.add(news);

    await _storage.write('bookmarks', updatedBookmarks);
  }

  @override
  Future<void> removeBookmark(NewsEntity news) async {
    final List<NewsEntity>? bookmarks = _storage.read('bookmarks');

    if (bookmarks != null) {
      final updatedBookmarks = bookmarks.where((bookmark) => bookmark.id != news.id).toList();
      await _storage.write('bookmarks', updatedBookmarks);
    }
  }

  @override
  Future<List<NewsEntity>> getBookmarkedNews() async {
    return List.generate(3, (index) {
      return NewsEntity(
        id: '$index',
        title: 'example_title $index',
        description: 'example_description $index',
        imageUrl: 'https://placehold.co/300x200/png',
      );
    });;
  }
}
