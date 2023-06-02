import 'package:news_app/data/bookmark_repository.dart';
import 'package:news_app/data/models/news_entity.dart';
import 'package:news_app/domain/news_usecase.dart';
import 'package:news_app/data/news_repository.dart';

class NewsUseCaseImpl implements NewsUseCase {
  final NewsRepository newsRepository;
  final BookmarkRepository bookmarkRepository;

  NewsUseCaseImpl({
    required this.newsRepository,
    required this.bookmarkRepository,
  });

  @override
  Future<List<NewsEntity>> fetchTopHeadlines(String category) async {
    return newsRepository.getTopHeadlines(category);
  }

  @override
  Future<List<NewsEntity>> fetchEverything(String category) async {
    return newsRepository.getEverything(category);
  }

  @override
  Future<void> addBookmark(NewsEntity news) async {
    return bookmarkRepository.addBookmark(news);
  }

  @override
  Future<void> removeBookmark(NewsEntity news) async {
    return bookmarkRepository.removeBookmark(news);
  }

  @override
  Future<List<NewsEntity>> getBookmarkedNews() async {
    return bookmarkRepository.getBookmarkedNews();
  }
}