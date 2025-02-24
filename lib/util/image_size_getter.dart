import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter_http_input/image_size_getter_http_input.dart';

abstract class ImageSizeGetterUtil {
  static Future<Size?> getImageSize(String imageUrl) async {
    try {
      final httpInput = await HttpInput.createHttpInput(imageUrl);

      final sizeResult = await ImageSizeGetter.getSizeResultAsync(httpInput);
      print('🖼️ Size of $imageUrl: ${sizeResult.size}');
      return sizeResult.size;
    } catch (e) {
      print('❌ Error getting image $imageUrl: $e');
      return null;
    }
  }
}
