import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../interfaces/products_interfaces.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductsServices implements ProductsInterfaces {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
//for drop down
  @override
  Future<List<CategoryModel>> fetchCategoriesFromFirebase() async {
    List<CategoryModel> categoriesList = [];

    try {
      QuerySnapshot snapshot =
          await firebaseFirestore.collection('categories').get();
      for (var element in snapshot.docs) {
        categoriesList
            .add(CategoryModel.fromMap(element.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print("Error in fetching the categories: $e");
    }

    return categoriesList;
  }

  //fetch products

  @override
  Future<List<ProductModel>> fetchProductsFromFirebase() async {
    List<ProductModel> productsList = [];
    try {
      QuerySnapshot snapshot =
          await firebaseFirestore.collection('products').get();

      /*  for (var element in snapshot.docs) {
        productsList
            .add(ProductModel.fromMap(element.data() as Map<String, dynamic>));
      } */

      /* productsList = snapshot.docs
    .map((element) => ProductModel.fromMap(element.data() as Map<String, dynamic>))
    .toList();
 */
      snapshot.docs.forEach((element) {
        productsList
            .add(ProductModel.fromMap(element.data() as Map<String, dynamic>));
      });
    } catch (e) {
      print("Error in fetching the products: $e");
    }
    return productsList;
  }

  //fetch single category
  @override
  Future<ProductModel?> fetchsingleProductFromFirebase(String productId) async {
    try {
      DocumentSnapshot productDoc =
          await firebaseFirestore.collection('products').doc(productId).get();

      if (productDoc.exists) {
        return ProductModel.fromMap(productDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error in fetching the single product : $e");
    }

    return null;
  }

//add
  @override
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
    List<ProductModel> productsList = [];

    try {
      DocumentReference docRef = firebaseFirestore.collection('products').doc();
      final String productId = docRef.id;

      ProductModel productModel = ProductModel(
        productId: productId,
        productName: productName,
        productDescription: productDescription,
        productPrice: productPrice,
        productDiscount: productDiscount,
        categoryId: categoryId,
        categoryName: categoryName,
        coverImg: coverImg,
        urlImages: urlImages,
        stockQuantity: stockQuantity,
        stockThreshold: stockThreshold,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await firebaseFirestore
          .collection('products')
          .doc(productId)
          .set(productModel.toMap());
      productsList.add(productModel);
    } catch (e) {
      print("Error in adding the products: $e");
    }

    return productsList;
  }

  //update

  @override
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
      int stockThreshold) async {
    List<ProductModel> productsList = [];
    if (productsList.isEmpty) {
      throw Exception("Product ID cannot be emppty");
    }
    try {
      final DocumentReference productDoc =
          firebaseFirestore.collection('products').doc(productId);

      DocumentSnapshot existingProductDoc = await productDoc.get();
      if (!existingProductDoc.exists) {
        throw Exception("Product does not exist");
      }

      //exsisting cproduct data

      Map<String, dynamic> existingProductData =
          existingProductDoc.data() as Map<String, dynamic>;

      Timestamp createdAt;

      if (existingProductData['createdAt'] is Timestamp) {
        createdAt = existingProductData['createdAt'] as Timestamp;
      } else {
        throw Exception("Invalid createdAt format");
      }

      print(
          'product data with category : ${existingProductData['categoryId']} + ${existingProductData['categoryName']}');
      final ProductModel productModel = ProductModel(
        productId: productId,
        productName: productName,
        productDescription: productDescription,
        productPrice: productPrice,
        categoryId: categoryId,
        categoryName: categoryName,
        coverImg: coverImg,
        urlImages: urlImages,
        stockQuantity: stockQuantity,
        stockThreshold: stockThreshold,
        createdAt: createdAt,
        updatedAt: Timestamp.now(),
      );

      await productDoc.update(productModel.toMap());

      productsList = await fetchProductsFromFirebase();
    } catch (e) {
      print("Error in updating the Product : $e");
    }
    return productsList;
  }

  //store

  @override
  Future<String> uploadProductImageToStorage(XFile image) async {
    TaskSnapshot reference;
    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      reference = await firebaseStorage
          .ref('product-images/${image.name + DateTime.now().toString()}')
          .putData(bytes);
    } else {
      reference = await firebaseStorage
          .ref('product-images/${image.name + DateTime.now().toString()}')
          .putFile(File(image.path));
    }

    return await reference.ref.getDownloadURL();
  }

//delete images

  @override
  Future<void> deleteImagesFromStorage(dynamic imageUrls) async {
    try {
      if (imageUrls is String) {
        await firebaseStorage.refFromURL(imageUrls).delete();
        print("Deleted single image: $imageUrls");
      } else if (imageUrls is List<String>) {
        for (String url in imageUrls) {
          try {
            await firebaseStorage.refFromURL(url).delete();
            print("Deleted image: $url");
          } catch (e) {
            print("Error deleting image: $url, $e");
          }
        }
      }
    } catch (e) {
      print("Error in deleting images from storage: $e");
    }
  }

//delete  product

  @override
  Future<List<ProductModel>> deleteProductFromFirebase(String productId) async {
    List<ProductModel> productsList = [];
    try {
      DocumentSnapshot productSnapshot =
          await firebaseFirestore.collection("products").doc(productId).get();

      if (productSnapshot.exists) {
        String imgeUrl = productSnapshot['coverImg'];

        // Explicitly convert the dynamic list to List<String>
        List<String> imgUrls =
            List<String>.from(productSnapshot['urlImages'] ?? []);

        // print("Deleting product : ${productSnapshot.data()}");

        if (imgeUrl.isNotEmpty) {
          try {
            await firebaseStorage.refFromURL(imgeUrl).delete();
            print("Cover image deleted successfully.");
          } catch (e) {
            print("Error in deleting image from Storage : $e");
          }
        }

        // Delete all images in the urlImages list
        if (imgUrls.isNotEmpty) {
          for (String imageUrl in imgUrls) {
            try {
              await firebaseStorage.refFromURL(imageUrl).delete();
              print("Deleted image: $imageUrl");
            } catch (e) {
              print("Error in deleting image from Storage: $e");
            }
          }
        }

        await firebaseFirestore.collection("products").doc(productId).delete();
        print("Product data is deleted from Firestore");
      } else {
        print("Product does not exist");
      }
    } catch (e) {
      print("Error in deleting the product : $e");
    }
    productsList = await fetchProductsFromFirebase();
    return productsList;
  }

/*   Future<List<ProductModel>> deleteProductFromFirebase(String productId) async {
    List<ProductModel> productsList = [];
    try {
      DocumentSnapshot productSnapshot =
          await firebaseFirestore.collection("products").doc(productId).get();

      if (productSnapshot.exists) {
        String imgeUrl = productSnapshot['coverImg'];

        List<String> imgUrls = productSnapshot['urlImages'];

        print("Deleting product : ${productSnapshot.data()}");

        if (imgeUrl.isNotEmpty) {
          try {
            await firebaseStorage.refFromURL(imgeUrl).delete();
            print("Cover image deleted successfully.");
          } catch (e) {
            print("Error in deleting image from Storage : $e");
          }
        }

        // Delete all images in the urlImages list
        if (imgUrls.isNotEmpty) {
          for (String imageUrl in imgUrls) {
            try {
              await firebaseStorage.refFromURL(imageUrl).delete();
              print("Deleted image: $imageUrl");
            } catch (e) {
              print("Error in deleting image from Storage: $e");
            }
          }
        }

        await firebaseFirestore.collection("products").doc(productId).delete();
        print("product data is deleted from the firestore");
      } else {
        print("Product does not exist");
      }
    } catch (e) {
      print("Error in deleting the product : $e");
    }
    productsList = await fetchProductsFromFirebase();
    return productsList;
  } */
}
