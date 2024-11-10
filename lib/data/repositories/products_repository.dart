import 'package:image_picker/image_picker.dart';

import '../interfaces/products_interfaces.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductsRepository {
  final ProductsInterfaces interfaces;
  ProductsRepository({required this.interfaces});

//fetch products
  Future<List<ProductModel>> fetchProductsFromFirebase() async {
    return interfaces.fetchProductsFromFirebase();
  }

  //fetchSingleProduct

  Future<ProductModel?> fetchsingleProductFromFirebase(String productId) async {
    return await interfaces.fetchsingleProductFromFirebase(productId);
  }

  //add
  Future<List<ProductModel>> addProductsToFirebase(
    String productName,
    String productDescription,
    double productPrice,
    int productDiscount,
    String categoryId,
    String categoryName,
    String coverImg,
    List<String> urlImages,
    int stockQuantity,
    int stockThreshold,
  ) async {
    return interfaces.addProductsToFirebase(
      productName,
      productDescription,
      productPrice,
      productDiscount,
      categoryId,
      categoryName,
      coverImg,
      urlImages,
      stockQuantity,
      stockThreshold,
    );
  }

  //update products

  Future<List<ProductModel>> UpdateProductFromFirebase(
    String productId,
    String productName,
    String productDescription,
    double productPrice,
    int productDiscount,
    String categoryId,
    String categoryName,
    String coverImg,
    List<String> urlImages,
    int stockQuantity,
    int stockThreshold,
  ) async {
    return interfaces.UpdateProductFromFirebase(
      productId,
      productName,
      productDescription,
      productPrice,
      productDiscount,
      categoryId,
      categoryName,
      coverImg,
      urlImages,
      stockQuantity,
      stockThreshold,
    );
  }

//for drop down
  Future<List<CategoryModel>> fetchCategoriesFromFirebase() async {
    return interfaces.fetchCategoriesFromFirebase();
  }

//store
  Future<String> uploadProductsImageToStorage(XFile image) async {
    return interfaces.uploadProductImageToStorage(image);
  }

  //delete images form storage
  Future<void> deleteImagesFromStorage(dynamic imageUrls) async {
    return interfaces.deleteImagesFromStorage(imageUrls);
  }

  //delete

  Future<List<ProductModel>> deleteProductFromFirebase(String productId) async {
    return interfaces.deleteProductFromFirebase(productId);
  }
}
