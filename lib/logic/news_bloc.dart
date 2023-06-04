import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/data/models/news_entity.dart';
import 'package:news_app/domain/news_usecase.dart';
import 'package:news_app/logic/news_event.dart';
import 'package:news_app/logic/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsUseCase _newsUseCase;
  Timer? _topNewsFetchTimer;

  NewsBloc(this._newsUseCase) : super(NewsInitial()) {
    on<InitialEvent>((event, emit) async {
      try {
        add(FetchNews());
      } catch (e) {
        emit(NewsError('Failed to start app'));
      }
    });

    on<FetchNews>((event, emit) async {
      emit(NewsLoading());
      try {
        List<NewsEntity> topHeadlines = await _newsUseCase.fetchTopHeadlines();
        List<NewsEntity> everything = await _newsUseCase.fetchEverything();
        List<NewsEntity> bookmarkedNews = await _newsUseCase.getBookmarkedNews();

        topHeadlines = _checkBookmarked(topHeadlines, bookmarkedNews);
        everything = _checkBookmarked(everything, bookmarkedNews);

        print(topHeadlines.length);
        topHeadlines.forEach((element) => print(element.isBookmarked));

        emit(NewsLoaded(
          topHeadlines: topHeadlines,
          everything: everything,
          bookmarks: bookmarkedNews
        ));

        if (_topNewsFetchTimer != null && !_topNewsFetchTimer!.isActive) {
          // top headlines poll

          // _topNewsFetchTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
          //   List<NewsEntity> topNews = await _newsUseCase.fetchTopNews();
          //   List<NewsEntity> bookmarkedNews = await _newsUseCase.getBookmarkedNews();
          //
          //   topNews = _checkBookmarked(topHeadlines, bookmarkedNews);
          //
          //   add(NewsLoadedSuccessfully(topNews));
          // });
        }
      } catch (e) {
        if (_topNewsFetchTimer != null) _topNewsFetchTimer!.cancel();
        emit(NewsError('Failed to fetch news'));
      }
    });

    on<NewsLoadedSuccessfully>((event, emit) async {
      emit(NewsLoaded(
        topHeadlines: event.topHeadlines,
        everything: event.everything,
        bookmarks: event.bookmarks
      ));
    });

    on<AddBookmark>((event, emit) async {
      try {
        await _newsUseCase.addBookmark(event.news);
        add(FetchNews());
      } catch (e, s) {
        emit(NewsError('Failed to add bookmark'));
      }
    });

    on<RemoveBookmark>((event, emit) async {
      try {
        await _newsUseCase.removeBookmark(event.news);
        add(FetchNews());
      } catch (e) {
        emit(NewsError('Failed to remove bookmark'));
      }
    });
  }

  List<NewsEntity> _checkBookmarked(List<NewsEntity> currentList, List<NewsEntity> bookmarksList) {
    return currentList.map((el) => el.copyWith(
      isBookmarked: bookmarksList.contains(el),
    )).toList();
  }
}

