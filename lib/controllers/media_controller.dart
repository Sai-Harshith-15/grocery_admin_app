import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../data/repositories/media_repository.dart';


// Add a class to hold image name and URL
class ImageData {
  final String name;
  final String url;

  ImageData({required this.name, required this.url});
}

class MediaController extends GetxController {
  final MediaRepository mediaRepository;
  MediaController({required this.mediaRepository});
  var isLoading = false.obs;
  RxBool isUploadSectionVisible = false.obs;
  //drop down folder names
  RxList<String> folderNames = <String>[].obs;

  // Add separate variables for each dropdown
  final RxString selectedFolderForUpload = "Select-Folder".obs;
  final RxString selectedFolderForFetch = "Select-Folder".obs;
  RxList<ImageData> folderImages = <ImageData>[].obs; //pick image
  final ImagePicker imagePicker = ImagePicker();
//pick multiple images in a listy
  RxList<XFile> selectedImages = <XFile>[].obs;
  RxList<Uint8List> webImageBytesList = <Uint8List>[].obs;
  RxList<String> uploadedImageUrl = <String>[].obs;

  RxMap<String, List<String>> folderImagesMap = <String, List<String>>{}.obs;

  //for load more images

  int currentImageBatch = 0;
  final int imagesPerPage = 10;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFolders();
  }

  // Fetch folder names and update observable list

  Future<void> fetchFolders() async {
    isLoading.value = true;
    try {
      List<String> folders = await mediaRepository.fetchFolderNames();
      folderNames.assignAll(folders);

      if (folderNames.isNotEmpty && folderNames.contains("Select-Folder")) {
        selectedFolderForUpload.value = "Select-Folder";
        selectedFolderForFetch.value = "Select-Folder";
      } else if (folderNames.isNotEmpty) {
        selectedFolderForUpload.value = folderNames[0];
        selectedFolderForFetch.value = folderNames[0];
      }
    } catch (e) {
      print("Error fetching folders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch image URLs based on selected folder
  Future<void> fetchImagesForFolder(String folderName,
      {bool loadMore = false}) async {
    if (selectedFolderForFetch.value == "Select-Folder") {
      Get.snackbar(
        "Fetch Failed",
        "Please select a valid folder to fetch images.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    // isLoading.value = true;
    // Show loading indicator based on action
    if (!loadMore) {
      folderImages.clear(); // Clear if it's a fresh fetch
      currentImageBatch = 0; // Reset batch count for new fetch
    } else {
      currentImageBatch++;
    }
    int offset = currentImageBatch * imagesPerPage;
    isLoading.value = loadMore;
    isLoading.value = !loadMore;
    // loadMore ? isLoadingMore.value = true : isLoading.value = true;

    try {
      // folderImageUrls.clear();

      List<String> imageUrls = await mediaRepository.fetchImageUrlsFromFolder(
        folderName,
        limit: imagesPerPage,
        offset: offset,
      );
      // Add both image name and URL to the list
      for (var url in imageUrls) {
        String imageName =
            url.split('/').last; // Extract image name from the URL
        folderImages.add(ImageData(name: imageName, url: url));
      }
    } catch (e) {
      print("Error fetching images: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Method to refresh the folder and fetch all images again
  Future<void> refreshFolderImages() async {
    currentImageBatch = 0; // Reset batch count
    await fetchImagesForFolder(selectedFolderForFetch.value, loadMore: false);
  }

  // Select images for uploading
  Future<void> pickImages() async {
    try {
      if (kIsWeb) {
        final List<XFile>? pickedFiles = await imagePicker.pickMultiImage();
        if (pickedFiles != null) {
          selectedImages.assignAll(pickedFiles);
          webImageBytesList.clear();
          for (var image in pickedFiles) {
            Uint8List bytes = await image.readAsBytes();
            webImageBytesList.add(bytes);
          }
        }
      } else {
        final List<XFile>? pickedFiles = await imagePicker.pickMultiImage();
        if (pickedFiles != null) {
          selectedImages.assignAll(pickedFiles);
        }
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  // Update selected folder for upload
  void updateSelectedFolderForUpload(String folder) {
    selectedFolderForUpload.value = folder;
  }

  // Update selected folder for fetching
  void updateSelectedFolderForFetch(String folder) {
    selectedFolderForFetch.value = folder;
  }

  // Remove all selected images
  void removeAllSelectedImages() {
    selectedImages.clear();
    webImageBytesList.clear();
  }

  // Upload selected images to Firebase and store URLs in selected folder
  Future<void> uploadImagesToFolder() async {
    // if (selectedFolderName.value == null) return;
    if (selectedFolderForUpload.value == "Select-Folder" ||
        selectedImages.isEmpty) {
      Get.snackbar(
        "Upload Failed",
        "Please select a folder and images to upload.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      List<String> uploadedUrls = [];

      for (var imageFile in selectedImages) {
        Uint8List imageData = await imageFile.readAsBytes();
        String imageName = imageFile.name;
        String downloadUrl = await mediaRepository.uploadImage(
            imageData, selectedFolderForUpload.value, imageName);

        if (downloadUrl.isNotEmpty) {
          uploadedUrls.add(downloadUrl);
        }
      }

      if (uploadedUrls.isNotEmpty) {
        folderImagesMap[selectedFolderForUpload.value] = uploadedUrls;
        // Show success message
        Get.snackbar(
          "Upload Successful",
          "${uploadedUrls.length} images have been uploaded successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear selected images after upload
        selectedImages.clear();
        webImageBytesList.clear();
      } else {
        throw Exception("No images were uploaded");
      }
    } catch (e) {
      print("Error uploading images: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
