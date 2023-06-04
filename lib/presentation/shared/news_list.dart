import 'package:flutter/material.dart';
import 'package:news_app/data/models/news_entity.dart';
import 'package:news_app/presentation/shared/news_widget.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key? key, required this.news}) : super(key: key);
  final List<NewsEntity> news;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        return NewsWidget(news: news[index]);
      },
    );
  }
}
