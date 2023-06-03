import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/data/bookmark_repository_impl.dart';
import 'package:news_app/data/news_repository_impl.dart';
import 'package:news_app/domain/news_usecase_impl.dart';
import 'package:news_app/logic/news_bloc.dart';
import 'package:news_app/logic/news_event.dart';
import 'package:news_app/logic/news_state.dart';
import 'package:news_app/presentation/screens/news_detail_page.dart';

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
      )..add(FetchTopNews(dotenv.env['NEWS_CATEGORY']!)),
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Home'),
            ),
            body: _buildBody(context, state),
            bottomNavigationBar: _buildTabs(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, NewsState state) {
    if (state is NewsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NewsError) {
      return Center(child: Text(state.message));
    } else if (state is NewsLoaded) {
      return ListView.builder(
        itemCount: state.news.length,
        itemBuilder: (context, index) {
          final news = state.news[index];
          return ListTile(
            title: Text(news.title),
            subtitle: Text(news.description),
            leading: Image.network(news.imageUrl),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailPage(news: news),
                ),
              );
            },
          );
        },
      );
    } else {
      return const Center(child: Text('Unknown app state'));
    }
  }

  Widget _buildTabs(BuildContext context, NewsState state) {
    return BottomNavigationBar(
      currentIndex: _currentTabIdx,
      selectedItemColor: Colors.blue,
      onTap: (int tabIdx) {
        if (tabIdx == _currentTabIdx) return;
        setState(() {
          _currentTabIdx = tabIdx;
        });
        if (tabIdx == 0) {}
        else if (tabIdx == 1) {}
        print(tabIdx);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Bookmarks',
        ),
      ],
    );
  }
}
