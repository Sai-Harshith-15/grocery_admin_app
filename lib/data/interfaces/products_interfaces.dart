import 'package:image_picker/image_picker.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class ProductsInterfaces {
  //for drop down
  Future<List<CategoryModel>> fetchCategoriesFromFirebase();

  //fetch all products
  Future<List<ProductModel>> fetchProductsFromFirebase();
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
  );
  //fetch single product from firebase
  Future<ProductModel?> fetchsingleProductFromFirebase(String productId);

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
  );

  //store
  Future<String> uploadProductImageToStorage(XFile image);

  //delete images in storage
  Future<void> deleteImagesFromStorage(dynamic imageUrls);

  //delete

  Future<List<ProductModel>> deleteProductFromFirebase(String productId);
}
