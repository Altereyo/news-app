import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/data/models/news_entity.dart';
import 'package:news_app/logic/news_bloc.dart';
import 'package:news_app/logic/news_event.dart';
import 'package:news_app/presentation/screens/news_detail_page.dart';
import 'package:news_app/presentation/theme/app_colors.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({Key? key, required this.news}) : super(key: key);
  final NewsEntity news;

  @override
  Widget build(BuildContext context) {
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
        style: Theme.of(context).textTheme.labelMedium,
      ),
      trailing: InkWell(
          onTap: () {
            if (news.isBookmarked!) {
              context.read<NewsBloc>().add(RemoveBookmark(news));
            } else {
              context.read<NewsBloc>().add(AddBookmark(news));
            }
          },
          child: Icon(
            Icons.bookmark,
            color: news.isBookmarked! ? AppColors.accentColor : AppColors.textColor,
          ),
        ),
      leading: Builder(builder: (context) {
        // ниже костыли для newsapi.org/v2
        String imageUrl = news.urlToImage ?? '';
        if (imageUrl.startsWith('https:////')) {
          // фиксим ссылки с 4мя лишними слешами: https:////
          imageUrl =
              'https://${imageUrl.replaceFirst('https:////', 'https://')}';
        }
        if (imageUrl.endsWith('.pn')) {
          // фиксим ссылки с недописанным форматом png: https://......pn
          imageUrl = '${imageUrl.substring(0, imageUrl.length - 3)}.png';
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
                    return loadingProgress == null
                        ? child
                        : const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, exception, stacktrace) {
                    return Placeholder(
                      child: Text(
                        'Corrupted image data',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    );
                  },
                )
              : Placeholder(
                  child: Text(
                    'Image url not provided',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
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
  }
}
