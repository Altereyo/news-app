import 'package:bloc/bloc.dart';
import 'package:news_app/data/models/news_entity.dart';
import 'package:news_app/domain/news_usecase.dart';
import 'package:news_app/logic/news_event.dart';
import 'package:news_app/logic/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsUseCase _newsUseCase;

  NewsBloc(this._newsUseCase) : super(NewsInitial()) {
    on<FetchTopHeadlines>((event, emit) async {
      emit(NewsLoading());
      try {
        final topHeadlines = await _newsUseCase.fetchTopHeadlines(event.category);
        emit(NewsLoaded(topHeadlines));
      } catch (e) {
        emit(NewsError('Failed to fetch top headlines'));
      }
    });

    on<FetchEverything>((event, emit) async {
      emit(NewsLoading());
      try {
        final everything = await _newsUseCase.fetchEverything(event.category);
        emit(NewsLoaded(everything));
      } catch (e) {
        emit(NewsError('Failed to fetch everything'));
      }
    });

    on<AddBookmark>((event, emit) async {
      try {
        await _newsUseCase.addBookmark(event.news);
        emit(NewsBookmarked());
      } catch (e) {
        emit(NewsError('Failed to add bookmark'));
      }
    });
    on<RemoveBookmark>((event, emit) async {
      try {
        await _newsUseCase.removeBookmark(event.news);
        emit(NewsBookmarked());
      } catch (e) {
        emit(NewsError('Failed to remove bookmark'));
      }
    });

    on<GetBookmarks>((event, emit) async {
      emit(NewsLoading());
      try {
        final bookmarkedNews = await _newsUseCase.getBookmarkedNews();
        emit(BookmarkedNewsLoaded(bookmarkedNews));
      } catch (e) {
        emit(NewsError('Failed to get bookmarkes'));
      }
    });
  }
}

