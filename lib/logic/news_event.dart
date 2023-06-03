import 'package:equatable/equatable.dart';
import 'package:news_app/data/models/news_entity.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopNews extends NewsEvent {
  final String category;

  FetchTopNews(this.category);

  @override
  List<Object?> get props => [category];
}

class FetchEverything extends NewsEvent {
  final String category;

  FetchEverything(this.category);

  @override
  List<Object?> get props => [category];
}

class AddBookmark extends NewsEvent {
  final NewsEntity news;

  AddBookmark(this.news);

  @override
  List<Object?> get props => [news];
}
class RemoveBookmark extends NewsEvent {
  final NewsEntity news;

  RemoveBookmark(this.news);

  @override
  List<Object?> get props => [news];
}

class GetBookmarks extends NewsEvent {}
