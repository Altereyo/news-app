import 'package:equatable/equatable.dart';
import 'package:news_app/data/models/news_entity.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends NewsEvent {}

class FetchNews extends NewsEvent {}

class NewsLoadedSuccessfully extends NewsEvent {
  final List<NewsEntity> topHeadlines;
  final List<NewsEntity> everything;
  final List<NewsEntity> bookmarks;


  const NewsLoadedSuccessfully(this.topHeadlines, this.everything, this.bookmarks);

  @override
  List<Object?> get props => [topHeadlines, everything, bookmarks];
}

class AddBookmark extends NewsEvent {
  final NewsEntity news;
  const AddBookmark(this.news);

  @override
  List<Object?> get props => [news];
}

class RemoveBookmark extends NewsEvent {
  final NewsEntity news;
  const RemoveBookmark(this.news);

  @override
  List<Object?> get props => [news];
}

class TopHeadlinesTapped extends NewsEvent {}
class EverythingTapped extends NewsEvent {}

class NewsTabTapped extends NewsEvent {}
class BookmarksTabTapped extends NewsEvent {}
