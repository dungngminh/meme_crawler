import 'package:myapp/model/meme_template.dart';

abstract class Crawler {
  Future<List<MemeTemplate>> start({
    Future<void> Function(MemeTemplate memeTemplate)? onMemeTemplateFound,
  });
}
