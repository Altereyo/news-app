import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/presentation/screens/news_page.dart';
import 'package:news_app/presentation/theme/theme_data.dart';

Future<void> main() async {
  await dotenv.load();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: themeData,
      home: NewsPage(),
    );
  }
}