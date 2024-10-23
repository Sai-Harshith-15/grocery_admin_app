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
}
