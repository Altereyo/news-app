import 'package:equatable/equatable.dart';
import 'package:news_app/data/models/news_entity.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> topHeadlines;
  final List<NewsEntity> everything;
  final List<NewsEntity> bookmarks;

  const NewsLoaded({required this.topHeadlines, required this.everything, required this.bookmarks});


  @override
  List<Object?> get props => [topHeadlines, everything, bookmarks];
}

class ShowBookmarks extends NewsState {}

class BookmarkedNewsLoaded extends NewsState {
  final List<NewsEntity> news;

  BookmarkedNewsLoaded(this.news);

  @override
  List<Object?> get props => [news];
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
