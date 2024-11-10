import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/repositories/products_repository.dart';
import '../presentation/widgets/mytext.dart';

class AllProductsController extends GetxController {
  final ProductsRepository productsRepository;
  AllProductsController({required this.productsRepository});

  var isLoading = false.obs;
  var productsList = <ProductModel>[].obs;
  var categoryList = <CategoryModel>[].obs;

  var filteredProductsList = <ProductModel>[].obs;

  // Category handling (selected category)
  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  //single product
  Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
//pick image
  final ImagePicker imagePicker = ImagePicker();

  // For cover image
  Rx<XFile?> coverImage = Rx<XFile?>(null);
  Rx<Uint8List?> webCoverImageBytes = Rx<Uint8List?>(null);
  RxString uploadedCoverImageUrl = ''.obs;

  // For multiple selected images (urlImages)
  RxList<XFile> selectedImages = <XFile>[].obs;
  RxList<Uint8List> webImageBytesList = <Uint8List>[].obs;
  RxList<String> uploadedImageUrl = <String>[].obs;

  // Text Controllers
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDiscountController = TextEditingController();
  TextEditingController stockQuantityController = TextEditingController();
  TextEditingController stockThresholdController = TextEditingController();

  //search

  TextEditingController searchProductsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProductsFromFirebase();
    searchProductsController.addListener(() {
      filterProducts(searchProductsController.text);
    });
  }

  @override
  void onClose() {
    super.onClose();
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    productDiscountController.dispose();
    stockQuantityController.dispose();
    stockThresholdController.dispose();
    searchProductsController.dispose();
  }

  // Fetch categories from Firebase
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final categories = await productsRepository.fetchCategoriesFromFirebase();
      // categoryList.assignAll(categories);
      if (categories.isNotEmpty) {
        categoryList.value = categories;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductsFromFirebase() async {
    try {
      isLoading.value = true;
      final fetchProducts =
          await productsRepository.fetchProductsFromFirebase();
      if (fetchProducts.isNotEmpty) {
        productsList.value = fetchProducts;
        filteredProductsList.value = fetchProducts;
      } else {
        print("Products not Found");
      }
    } catch (e) {
      print("Error fetching products : $e");
    } finally {
      isLoading.value = false;
    }
  }

  //fileter fun

  void filterProducts(String data) {
    if (data.isEmpty) {
      filteredProductsList.value = productsList;
    } else {
      filteredProductsList.value = productsList
          .where((product) =>
              product.productName.toLowerCase().contains(data.toLowerCase()))
          .toList();
    }
  }

  //fetch product by id

  Future<void> fetchProductById(String productId) async {
    try {
      isLoading.value = true;
      final ProductModel? product =
          await productsRepository.fetchsingleProductFromFirebase(productId);

      if (product != null) {
        selectedProduct.value = product;
        productNameController.text = product.productName;
        productDescriptionController.text = product.productDescription;
        productPriceController.text = product.productPrice.toString();
        productDiscountController.text = product.productDiscount.toString();
        stockQuantityController.text = product.stockQuantity.toString();
        stockThresholdController.text = product.stockThreshold.toString();
        uploadedCoverImageUrl.value =
            product.coverImg.isNotEmpty ? product.coverImg : "";
        uploadedImageUrl.value =
            product.urlImages.isNotEmpty ? product.urlImages : [''];

        // Set the selected category using the categoryId from the fetched product
        try {
          selectedCategory.value = categoryList.firstWhere(
            (category) => category.categoryId == product.categoryId,
          );
        } catch (e) {
          // Handle the case where no category matches (e.g., set to null)
          selectedCategory.value = null;
          print("No matching category found: $e");
        }
      } else {
        print("Product not Found");
      }
    } catch (e) {
      print("Error in fetching single product details : $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Show image picking dialog with permissions handling for mobile
  Future<void> showImagesPickDialog({required bool isCoverImage}) async {
    if (kIsWeb) {
      showPickDialog(isCoverImage: isCoverImage);
    } else {
      PermissionStatus storageStatus;
      PermissionStatus cameraStatus;

      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;

      if (androidDeviceInfo.version.sdkInt < 32) {
        storageStatus = await Permission.storage.request();
        cameraStatus = await Permission.camera.request();
      } else {
        storageStatus = await Permission.mediaLibrary.request();
        cameraStatus = await Permission.camera.request();
      }

      if (storageStatus.isGranted && cameraStatus.isGranted) {
        showPickDialog(isCoverImage: isCoverImage);
      } else if (storageStatus.isDenied || cameraStatus.isDenied) {
        Get.snackbar('Error', 'Permissions denied, open app settings.');
        openAppSettings();
      }
    }
  }

  // Dialog to choose between single or multiple images
  void showPickDialog({required bool isCoverImage}) {
    Get.defaultDialog(
      title: "Choose Image",
      middleText: "Pick an image from the camera or gallery",
      actions: [
        ElevatedButton(
          onPressed: () {
            if (isCoverImage) {
              pickImage("Camera", isCoverImage: isCoverImage);
            } else {
              pickMultipleImages();
            }
            Get.back();
          },
          child: const HeadText(text: 'Camera'),
        ),
        ElevatedButton(
          onPressed: () {
            if (isCoverImage) {
              pickImage("Gallery", isCoverImage: isCoverImage);
            } else {
              pickMultipleImages();
            }
            Get.back();
          },
          child: const HeadText(text: 'Gallery'),
        ),
      ],
    );
  }

// Method to pick a single image (handles web and mobile)
  Future<void> pickImage(String sourceType,
      {required bool isCoverImage}) async {
    XFile? image;
    if (kIsWeb) {
      image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        if (isCoverImage) {
          webCoverImageBytes.value = bytes;
          coverImage.value = image;
        } else {
          webImageBytesList.add(bytes);
          selectedImages.add(image);
        }
      }
    } else {
      image = await imagePicker.pickImage(
          source:
              sourceType == 'Camera' ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 80);
      if (image != null) {
        if (isCoverImage) {
          coverImage.value = image;
        } else {
          selectedImages.add(image);
        }
      }
    }
  }

  // Method to pick multiple images (web and mobile)
  Future<void> pickMultipleImages() async {
    List<XFile>? images = await imagePicker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images);
      if (kIsWeb) {
        for (var image in images) {
          final bytes = await image.readAsBytes();
          webImageBytesList.add(bytes);
        }
      }
    }
  }

  // Remove the selected cover image
  void removeSelectedCoverImage() {
    coverImage.value = null;
    webCoverImageBytes.value = null;
  }

  // Remove the selected multiple images
  /*  void removeSelectedImages() {
    selectedImages.clear();
    webImageBytesList.clear();
  } */

  void removeSelectedImages(int index) {
    if (kIsWeb) {
      webImageBytesList.removeAt(index);
    } else {
      selectedImages.removeAt(index);
    }
    update(); // Update the UI after removing the image
  }

  //storage

  // Upload single and multiple images
  Future<void> uploadSelectedImages() async {
    if (coverImage.value != null) {
      final imageUrl = await productsRepository
          .uploadProductsImageToStorage(coverImage.value!);
      uploadedCoverImageUrl.value = imageUrl;
    }

    if (selectedImages.isNotEmpty) {
      for (var image in selectedImages) {
        final imageUrl =
            await productsRepository.uploadProductsImageToStorage(image);
        uploadedImageUrl.add(imageUrl);
      }
    }
  }

  Future<void> addProductsToFirebase() async {
    // Validate all fields
    if (productNameController.text.isEmpty ||
        productDescriptionController.text.isEmpty ||
        productPriceController.text.isEmpty ||
        stockQuantityController.text.isEmpty ||
        stockThresholdController.text.isEmpty ||
        coverImage.value == null ||
        selectedImages.isEmpty ||
        selectedCategory.value == null) {
      Get.snackbar('Error', 'Please fill all fields and select images');
      return;
    }

    try {
      isLoading.value = true;

      // Convert inputs to proper types with safety checks
      String productName = productNameController.text.trim();
      String productDescription = productDescriptionController.text.trim();
      double productPrice =
          double.tryParse(productPriceController.text.trim()) ?? 0.0;

      int productDiscount =
          int.tryParse(productDiscountController.text.trim()) ?? 0;

      int stockQuantity =
          int.tryParse(stockQuantityController.text.trim()) ?? 0;
      int stockThreshold =
          int.tryParse(stockThresholdController.text.trim()) ?? 0;

      String categoryId = selectedCategory.value!.categoryId;
      String categoryName = selectedCategory.value!.categoryName;

      String coverImageUrl = await productsRepository
          .uploadProductsImageToStorage(coverImage.value!);

      List<String> urlImages = [];
      for (var image in selectedImages) {
        String imageUrl =
            await productsRepository.uploadProductsImageToStorage(image);
        urlImages.add(imageUrl);
      }

      // Add the product to Firebase
      await productsRepository.addProductsToFirebase(
        productName,
        productDescription,
        productPrice,
        productDiscount,
        categoryId,
        categoryName,
        coverImageUrl,
        urlImages,
        stockQuantity,
        stockThreshold,
      );

      // Clear the form after submission
      clearForm();
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Clear the form after submission
  void clearForm() {
    productNameController.clear();
    productDescriptionController.clear();
    productPriceController.clear();
    productDiscountController.clear();
    stockQuantityController.clear();
    stockThresholdController.clear();
    coverImage.value = null;
    selectedImages.clear();
    selectedCategory.value = null;
    webCoverImageBytes.value = null;
    webImageBytesList.clear();
  }

  //updated products

  Future<void> updatedProductFromFirebase(String productId) async {
    if (productNameController.text.isEmpty ||
        productDescriptionController.text.isEmpty ||
        productPriceController.text.isEmpty ||
        productDiscountController.text.isEmpty ||
        stockQuantityController.text.isEmpty ||
        stockThresholdController.text.isEmpty ||
        coverImage.value != null ||
        selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please provide all required fields and an image');
      return;
    }
    try {
      isLoading.value = true;

      if (coverImage.value != null) {
        final coverImgUrl = await productsRepository
            .uploadProductsImageToStorage(coverImage.value!);

        uploadedCoverImageUrl.value = coverImgUrl;
      } else if (selectedImages.isNotEmpty) {
        for (var images in selectedImages) {
          final selectedImgUrl =
              await productsRepository.uploadProductsImageToStorage(images);
          uploadedImageUrl.add(selectedImgUrl);
        }
      }

      double productPrice =
          double.tryParse(productPriceController.text.trim()) ?? 0.0;

      int productDiscount =
          int.tryParse(productDiscountController.text.trim()) ?? 0;

      int stockQuantity =
          int.tryParse(stockQuantityController.text.trim()) ?? 0;
      int stockThreshold =
          int.tryParse(stockThresholdController.text.trim()) ?? 0;
      String categoryId = selectedCategory.value!.categoryId;
      String categoryName = selectedCategory.value!.categoryName;

      await productsRepository.UpdateProductFromFirebase(
        productId,
        productNameController.text.trim(),
        productDescriptionController.text.trim(),
        productPrice,
        productDiscount,
        categoryId,
        categoryName,
        uploadedCoverImageUrl.value,
        uploadedImageUrl,
        stockQuantity,
        stockThreshold,
      );
      clearForm();
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //delet images

  Future<void> deleteImagesFromStorage(dynamic imageUrls) async {
    try {
      isLoading.value = true;
      if (imageUrls is String) {
        await productsRepository.deleteImagesFromStorage(imageUrls);
        print("single images deleted");
      } else if (imageUrls is List<String>) {
        for (String url in imageUrls) {
          try {
            await productsRepository.deleteImagesFromStorage(url);
            print("multiple images deleted");
          } catch (e) {
            print("error deleting images $e");
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed while deleting the product image: $e");
      print("Error while deleting the product image: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //delete product

  Future<void> deleteProductFromFirebase(String productId) async {
    try {
      isLoading.value = true;
      productsList.value =
          await productsRepository.deleteProductFromFirebase(productId);
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar("Error", "Failed to delete the Product: $e");
      print("Error deleting product: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
