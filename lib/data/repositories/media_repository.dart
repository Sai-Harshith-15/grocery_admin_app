import 'dart:typed_data';
import '../interfaces/media_interfaces.dart';

class MediaRepository {
  final MediaInterfaces interfaces;

  MediaRepository({required this.interfaces});

  Future<List<String>> fetchFolderNames() async {
    return await interfaces.fetchFolderNames();
  }

  Future<String> uploadImage(
      Uint8List imageData, String folderName, String imageName) async {
    return await interfaces.uploadImage(imageData, folderName, imageName);
  }

  Future<List<String>> fetchImageUrlsFromFolder(String folderName,
      {int limit = 10, int offset = 0}) async {
    return await interfaces.fetchImageUrlsFromFolder(folderName,
        limit: limit, offset: offset);
  }
}
