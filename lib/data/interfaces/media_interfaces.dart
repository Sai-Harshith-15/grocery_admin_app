import 'dart:typed_data';

abstract class MediaInterfaces {
  Future<List<String>> fetchFolderNames();
  Future<String> uploadImage(
      Uint8List imageData, String folderName, String imageName);

  Future<List<String>> fetchImageUrlsFromFolder(String folderName,
      {int limit = 10, int offset = 0});
}
