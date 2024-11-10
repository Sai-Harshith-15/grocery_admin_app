import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../globals/globals.dart';
import '../interfaces/media_interfaces.dart';

class MediaServices implements MediaInterfaces {
  // Fetch folder names
  @override
  Future<List<String>> fetchFolderNames() async {
    try {
      ListResult result = await Globals.storage.ref().listAll();
      List<String> folders =
          result.prefixes.map((prefix) => prefix.name).toList();
      return folders;
    } catch (e) {
      print("Error fetching folders: $e");
      return [];
    }
  }

  // Upload image to a specific folder
  Future<String> uploadImage(
      Uint8List imageData, String folderName, String imageName) async {
    try {
      String path = '$folderName/$imageName';
      Reference ref = Globals.storage.ref().child(path);
      await ref.putData(imageData);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  // Fetch image URLs from a specific folder
  // Fetch image URLs from a specific folder with pagination
  Future<List<String>> fetchImageUrlsFromFolder(String folderName,
      {int limit = 10, int offset = 0}) async {
    try {
      ListResult result =
          await Globals.storage.ref().child(folderName).listAll();
      List<String> imageUrls = [];

      // Fetch URLs with offset and limit for pagination
      for (var item in result.items.skip(offset).take(limit)) {
        String url = await item.getDownloadURL();
        imageUrls.add(url);
        // Filter by file type (images only in this case)
        /*  if (item.name.endsWith('.jpg') ||
            item.name.endsWith('.png') ||
            item.name.endsWith('.jpeg')) {
          String url = await item.getDownloadURL();
          imageUrls.add(url);
        } */
      }

      return imageUrls;
    } catch (e) {
      print("Error fetching image URLs: $e");
      return [];
    }
  }
}
