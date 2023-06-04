import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/logic/news_bloc.dart';
import 'package:news_app/logic/news_event.dart';
import 'package:news_app/presentation/screens/bookmarks_page.dart';
import 'package:news_app/presentation/screens/news_page.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({Key? key, required this.currentTabIndex, required this.blocContext}) : super(key: key);
  final int currentTabIndex;
  final BuildContext blocContext;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentTabIndex,
      onTap: (int tabIdx) {
        if (tabIdx == currentTabIndex) return;
        if (tabIdx == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NewsPage(),
            ),
          );
        } else if (tabIdx == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<NewsBloc>(context),
                child: BookmarksPage(),
              ),
            ),
          );
        }
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
