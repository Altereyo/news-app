import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/data/bookmark_repository_impl.dart';
import 'package:news_app/data/news_repository_impl.dart';
import 'package:news_app/domain/news_usecase_impl.dart';
import 'package:news_app/logic/news_bloc.dart';
import 'package:news_app/logic/news_event.dart';
import 'package:news_app/logic/news_state.dart';
import 'package:news_app/presentation/shared/bottom_navigation_bar.dart';
import 'package:news_app/presentation/shared/news_list.dart';
import 'package:news_app/presentation/theme/app_colors.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _currentTabIdx = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsBloc(
        NewsUseCaseImpl(
          newsRepository: NewsRepositoryImpl(),
          bookmarkRepository: BookmarkRepositoryImpl(),
        ),
      )..add(InitialEvent()),
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (_, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: _buildAppBar(_, state),
              body: _buildBody(_, state),
              bottomNavigationBar: AppBottomNavigationBar(
                currentTabIndex: 0,
                blocContext: _,
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context, NewsState state) {
    return AppBar(
      title: const Text('Home'),
      bottom: TabBar(
        indicatorColor: AppColors.accentColor,
        tabs: const [
          Tab(icon: Icon(Icons.list_alt)),
          Tab(icon: Icon(Icons.list)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, NewsState state) {
    if (state is NewsInitial || state is NewsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NewsLoaded) {
      return TabBarView(
        children: [
          NewsList(news: state.topHeadlines),
          NewsList(news: state.everything),
        ],
      );
    } else if (state is NewsError) {
      return Center(
        child: Text(
          state.message,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    } else {
      return Center(
        child: Text(
          'Unknown app state $state',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    }
  }
}
