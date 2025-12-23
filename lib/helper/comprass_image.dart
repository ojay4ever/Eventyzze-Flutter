import 'dart:io';
import 'package:image/image.dart' as img;

class ImageCompressor {
  Future<File> compressImage(File image, int quality) async {
    img.Image originalImage = img.decodeImage(image.readAsBytesSync())!;
    List<int> compressedBytes = img.encodeJpg(originalImage, quality: quality);
    File compressedImage = File('${image.path}_compressed.jpg');
    await compressedImage.writeAsBytes(compressedBytes);
    return compressedImage;
  }
}