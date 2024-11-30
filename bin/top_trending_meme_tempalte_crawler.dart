import 'dart:io';

import 'package:myapp/crawler/img_flip_crawler.dart';
import 'package:myapp/di/dependence_provider.dart';
import 'package:myapp/io/appwrite_io.dart';

Future<void> main() async {
  final projectId = Platform.environment['APPWRITE_PROJECT_ID'];
  final key = Platform.environment['APPWRITE_KEY'];

  if (projectId == null || key == null) {
    throw Exception('Please provide APPWRITE_PROJECT_ID and APPWRITE_KEY');
  }

  final client = DependenceProvider.provieClient(
    project: projectId,
    key: key,
  );
  final database = DependenceProvider.provieDatabase(client: client);
  final ioAppWrite = AppwriteIo(databases: database);

  final imgFlipCrawler = ImgFlipCrawler(
    templateUrl: 'https://imgflip.com/memetemplates?sort=top-new&page=',
  );
  await imgFlipCrawler.start(
    onMemeTemplateFound: (memeTemplate) async {
      await ioAppWrite.save(
        databaseId: '67498c42002df1485c49',
        collectionId: 'trending_meme',
        data: memeTemplate,
      );
    },
  );
  print('✅✅✅ Done crawling meme templates');
}
