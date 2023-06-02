import 'package:flutter/material.dart';
import 'package:news_app/data/models/news_entity.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntity news;

  NewsDetailPage({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(news.title),
            Text(news.description),
          ],
        ),
      ),
    );
  }
}