import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:myapp/crawler/crawler.dart';
import 'package:myapp/model/meme_template.dart';
import 'package:myapp/util/image_size_getter.dart';
import 'package:uuid/uuid.dart';

const originalUrl = "https://imgflip.com";

class ImgFlipCrawler extends Crawler {
  ImgFlipCrawler({String? templateUrl})
      : templateUrl = templateUrl ?? 'https://imgflip.com/memetemplates?page=';

  final String templateUrl;

  @override
  Future<List<MemeTemplate>> start({
    Future<void> Function(MemeTemplate memeTemplate)? onMemeTemplateFound,
  }) async {
    // run from page 1 to 100 if exception occurs then stop
    final fetchedMemeTemplates = List<MemeTemplate>.empty(growable: true);
    for (int i = 1; i <= 100; i++) {
      print("⏳ ImgFlipCrawler Start to fetch meme templates from page $i");
      final memeTemplates = await fetchMemeTemplates(
        '$templateUrl$i',
        onMemeTemplateFound: onMemeTemplateFound,
      );
      if (memeTemplates.isEmpty) {
        break;
      }
      fetchedMemeTemplates.addAll(memeTemplates);
    }
    return fetchedMemeTemplates;
  }

  Future<List<MemeTemplate>> fetchMemeTemplates(
    String url, {
    Future<void> Function(MemeTemplate memeTemplate)? onMemeTemplateFound,
  }) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      print(
          '❌ Failed to fetch meme templates. Status code: ${response.statusCode}');
      return [];
    }
    final document = parser.parse(response.body);
    final memeBoxes = document.querySelectorAll('div.mt-box');
    final memeTemplates = <MemeTemplate>[];

    for (final memeBox in memeBoxes) {
      final titleElement = memeBox.querySelector('h3.mt-title a');
      final imageUrlElement = memeBox.querySelector('div.mt-img-wrap a img');
      final captionElement = memeBox.querySelector('a');

      final hrefCaptionElement = captionElement?.attributes['href'];

      /// Skip gif maker
      if (hrefCaptionElement != null &&
          hrefCaptionElement.startsWith('/gif-maker')) {
        continue;
      }

      if (titleElement != null && imageUrlElement != null) {
        final title = titleElement.text.trim();
        final detailMemePath =
            titleElement.attributes['href']?.replaceFirst("meme/", '') ?? '';
        final detailUrl = 'https://imgflip.com/memetemplate$detailMemePath';
        final imageUrl = imageUrlElement.attributes['src'];

        if (imageUrl != null) {
          print("=====================================");
          print("⏳ Start to fetch image from: $detailUrl");
          final originalImageUrl = await fetchDetailImage(detailUrl);

          if (originalImageUrl != null) {
            final imageUrl = originalImageUrl.contains('i.imgflip.com')
                ? "https:$originalImageUrl"
                : "$originalUrl$originalImageUrl";
            final imageSize = await ImageSizeGetterUtil.getImageSize(imageUrl);
            final memeTemplate = MemeTemplate(
              id: Uuid().v4(),
              title: title,
              originalImageUrl: imageUrl,
              imageHeight: imageSize?.height,
              imageWidth: imageSize?.width,
              needRotate: imageSize?.needRotate,
              detailUrl: detailUrl,
              source: 'imgflip',
              crawledAt: DateTime.now().toUtc(),
            );
            print("✅ Fetched image from: $detailUrl successfully!!");
            memeTemplates.add(memeTemplate);
            await onMemeTemplateFound?.call(memeTemplate);
          } else {
            print("❌ Failed to retrieve original image for $title");
          }
        }
      }
    }
    return memeTemplates;
  }

  Future<String?> fetchDetailImage(String url) async {
    final detailResponse = await http.get(Uri.parse(url));
    if (detailResponse.statusCode != 200) {
      print(
          '❌ Failed to fetch detail page for "$url". Status code: ${detailResponse.statusCode}');
      return null;
    }
    final detailDocument = parser.parse(detailResponse.body);
    final imageElement = detailDocument.querySelector('div#page img#mtm-img');
    if (imageElement != null) {
      final imgSrc = imageElement.attributes['src'];
      if (imgSrc != null) {
        return imgSrc.replaceAll('?', ''); // Remove the ?
      }
      return null;
    } else {
      print('❌ Could not find image element on detail page "$url"');
      return null;
    }
  }
}
