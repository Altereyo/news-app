import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/data/news_repository.dart';
import 'package:news_app/data/models/news_entity.dart';

class NewsRepositoryImpl implements NewsRepository {
  final String apiKey = dotenv.env['API_KEY']!;



  // request: https://newsapi.org/v2/everything?q=flutter&language=en&apiKey=38823f356abb4c6d9fa19f68dd78b40b




  final List<NewsEntity> exapmleResponse = List.generate(3, (index) {
    return NewsEntity(
      id: '$index',
      title: 'example_title $index',
      description: 'example_description $index',
      imageUrl: 'https://placehold.co/300x200/png',
    );
  });

  @override
  Future<List<NewsEntity>> getTopHeadlines(String category) async {
    // логика получения списка новостей по выбранной теме
    return exapmleResponse;
  }

  @override
  Future<List<NewsEntity>> getEverything(String category) async {
    // логика получения списка всех новостей по теме
    return exapmleResponse;
  }
}
