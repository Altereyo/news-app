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
      )..add(FetchBookmarks()),
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
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
    } else if (state is NewsLoaded && state.news.isNotEmpty) {
      return ListView.builder(
        itemCount: state.news.length,
        itemBuilder: (context, index) {
          final news = state.news[index];
          return ListTile(
            title: Text(
              news.title!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              news.description ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.labelMedium
            ),
            trailing: Builder(
              builder: (context) {
                bool isBookmarked = context.read<NewsBloc>().bookmarkedNews.contains(news);
                return InkWell(
                  onTap: () {
                    if (isBookmarked) {
                      context.read<NewsBloc>().add(RemoveBookmark(news));
                    } else {
                      context.read<NewsBloc>().add(AddBookmark(news));
                    }
                  },
                  child: Icon(Icons.bookmark, color: isBookmarked ? AppColors.accentColor : AppColors.textColor,),
                );
              }
            ),
            leading: Builder(builder: (context) {
              // костыли для newsapi.org/v2
              String imageUrl = news.urlToImage ?? '';
              if (imageUrl.startsWith('https:////')) {
                // фиксим ссылки с 4мя лишними слешами: https:////
                imageUrl =
                    'https://${imageUrl.replaceFirst('https:////', 'https://')}';
              }
              if (imageUrl.endsWith('.pn')) {
                // фиксим ссылки с недописанным форматом: https://......pn
                imageUrl =
                    '${imageUrl.substring(0, imageUrl.length - 3)}.png';
              }

              return SizedBox(
                height: 100,
                width: 100,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, exception, stacktrace) {
                          return Placeholder(
                            child: Text('Corrupted image data',
                            style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w300),),
                          );
                        },
                      )
                    : Placeholder(
                        child: Text('Image url not provided',
                            style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w300),),
                      ),
              );
            }),
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
      onTap: (int tabIdx) {
        if (tabIdx == _currentTabIdx) return;
        setState(() {
          _currentTabIdx = tabIdx;
        });
        if (tabIdx == 0) {
        } else if (tabIdx == 1) {}
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
