import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/data/models/get_news_response.dart';
import 'package:news_app/data/news_repository.dart';
import 'package:news_app/data/models/news_entity.dart';

class NewsRepositoryImpl implements NewsRepository {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://newsapi.org/v2/',
    queryParameters: {
      "q": dotenv.env['NEWS_CATEGORY']!,
      "apiKey": dotenv.env['API_KEY']!,
    }
  ));

  @override
  Future<List<NewsEntity>> getTopNews() async {
    final json = await dio.get('/top-headlines');
    final response = GetNewsResponse.fromJson(json.data);
    return response.articles!;
  }

  @override
  Future<List<NewsEntity>> getEverything() async {
    final json = await dio.get('/everything');
    final response = GetNewsResponse.fromJson(json.data);
    return response.articles!;
  }
}
