import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

const originalUrl = "https://imgflip.com";

Future<void> main() async {
  final baseUrl = 'https://imgflip.com/memetemplates';
  final memeTemplates = await fetchMemeTemplates(baseUrl);

  if (memeTemplates.isNotEmpty) {
    print('Meme Templates Found:');
    for (final template in memeTemplates) {
      print('Title: ${template['title']}');
      print('Original Image URL: ${template['originalImageUrl']}'); // Output the original image
      print('---');
    }
  } else {
    print('No meme templates found.');
  }
}


Future<List<Map<String, String>>> fetchMemeTemplates(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    print('Failed to fetch meme templates. Status code: ${response.statusCode}');
    return [];
  }
  final document = parser.parse(response.body);
  final memeBoxes = document.querySelectorAll('div.mt-box');
  final memeTemplates = <Map<String, String>>[];

  for (final memeBox in memeBoxes) {
    final titleElement = memeBox.querySelector('h3.mt-title a');
    final imageUrlElement = memeBox.querySelector('div.mt-img-wrap a img');

    if (titleElement != null && imageUrlElement != null) {
      final title = titleElement.text.trim();
      final detailMemePath = titleElement.attributes['href']?.replaceFirst("meme/", '') ?? "";
      final detailUrl = 'https://imgflip.com/memetemplate$detailMemePath';
      final imageUrl = imageUrlElement.attributes['src'];

      if (imageUrl != null) {
        print("=====================================");
        print("Start to fetch image from: $detailUrl");
        final originalImageUrl = await fetchDetailImage(detailUrl);

        if(originalImageUrl != null) {
            final template = {
              'title': title,
              'originalImageUrl': "$originalUrl$originalImageUrl", //Store the original image URL
            };
            print("Fetched image from: $detailUrl successfully!!");
            memeTemplates.add(template);
        } else {
            print("Failed to retrieve original image for $title");
        }
      }
    }
  }
  return memeTemplates;
}

Future<String?> fetchDetailImage(String url) async {
  final detailResponse = await http.get(Uri.parse(url));
  if (detailResponse.statusCode != 200) {
    print('Failed to fetch detail page for $url. Status code: ${detailResponse.statusCode}');
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
    print('Could not find image element on detail page $url');
    return null;
  }
}