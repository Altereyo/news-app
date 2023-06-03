import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/data/models/news_entity.dart';
import 'package:news_app/domain/news_usecase.dart';
import 'package:news_app/logic/news_event.dart';
import 'package:news_app/logic/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsUseCase _newsUseCase;
  Timer? _topNewsFetchTimer;
  List<NewsEntity> bookmarkedNews = [];

  NewsBloc(this._newsUseCase) : super(NewsInitial()) {
    on<FetchBookmarks>((event, emit) async {
      try {
        bookmarkedNews = await _newsUseCase.getBookmarkedNews();
      } catch (e) {
        emit(NewsError('Failed to fetch bookmarks'));
      }
    });

    on<NewsLoadedSuccessfully>((event, emit) async {
      emit(NewsLoaded(event.news));
    });

    on<FetchTopNews>((event, emit) async {
      emit(NewsLoading());
      try {
        final topNews = await _newsUseCase.fetchTopNews();
        add(NewsLoadedSuccessfully(topNews));
        _topNewsFetchTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
          final topNews = await _newsUseCase.fetchTopNews();
          add(NewsLoadedSuccessfully(topNews));
        });
      } catch (e) {
        if (_topNewsFetchTimer != null) _topNewsFetchTimer!.cancel();
        emit(NewsError('Failed to fetch top news'));
      }
    });

    on<FetchEverything>((event, emit) async {
      emit(NewsLoading());
      try {
        final everything = await _newsUseCase.fetchEverything();
        add(NewsLoadedSuccessfully(everything));
      } catch (e) {
        emit(NewsError('Failed to fetch everything'));
      }
    });

    on<AddBookmark>((event, emit) async {
      try {
        await _newsUseCase.addBookmark(event.news);
        // emit(NewsLoaded());
        add(GetBookmarks());
      } catch (e, s) {
        emit(NewsError('Failed to add bookmark'));
      }
    });

    on<RemoveBookmark>((event, emit) async {
      try {
        await _newsUseCase.removeBookmark(event.news);
        add(GetBookmarks());
      } catch (e) {
        emit(NewsError('Failed to remove bookmark'));
      }
    });

    on<GetBookmarks>((event, emit) async {
      emit(NewsLoading());
      try {
        bookmarkedNews = await _newsUseCase.getBookmarkedNews();
        emit(BookmarkedNewsLoaded(bookmarkedNews));
      } catch (e) {
        emit(NewsError('Failed to get bookmarkes'));
      }
    });
  }
}

