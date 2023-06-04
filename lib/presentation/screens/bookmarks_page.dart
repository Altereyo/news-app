import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/logic/news_bloc.dart';
import 'package:news_app/logic/news_state.dart';
import 'package:news_app/presentation/shared/bottom_navigation_bar.dart';
import 'package:news_app/presentation/shared/news_list.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({
    Key? key,
    // required this.blocContext
  }) : super(key: key);

  // final BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(title: const Text('Bookmarks')),
            body: _buildBody(context, state),
            bottomNavigationBar: AppBottomNavigationBar(
              currentTabIndex: 1,
              blocContext: context,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NewsState state) {
    if (state is NewsInitial || state is NewsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NewsLoaded) {
      return state.bookmarks.isEmpty
          ? Center(
              child: Text(
              'No bookmarked news',
              style: Theme.of(context).textTheme.labelSmall,
            ))
          : NewsList(news: state.bookmarks);
    } else if (state is NewsError) {
      return Center(child: Text(state.message));
    } else {
      return Center(child: Text('Unknown app state $state'));
    }
  }
}
