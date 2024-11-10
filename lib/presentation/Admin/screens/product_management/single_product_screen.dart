import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';

import '../../../../controllers/all_products_controller.dart';
import '../../../../data/models/product_model.dart';
import '../../../widgets/my_app_bar.dart';
import '../../../widgets/mytext.dart';

class SingleProductDetailsScreen extends StatefulWidget {
  final ProductModel? product;
  const SingleProductDetailsScreen({super.key, this.product});

  @override
  State<SingleProductDetailsScreen> createState() =>
      _SingleProductDetailsScreenState();
}

class _SingleProductDetailsScreenState
    extends State<SingleProductDetailsScreen> {
  final AllProductsController allProductsController =
      Get.find<AllProductsController>();
/*   String? productId;
  @override
  void initState() {
    super.initState();

    productId = (Get.arguments as ProductModel?)?.productId;

    if (productId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        allProductsController.fetchProductById(productId!);
      });
    }
  } */

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
/*     return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (allProductsController.isLoading.value) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          final product = allProductsController.selectedProduct.value;
          if (product == null) {
            return const Center(
              child: HeadText(text: "No Product Found."),
            );
          } */
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(
          title: widget.product!.productId != null
              ? "${widget.product!.productName} Product Details"
              : "Loading Product Details...",
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              //carousal
              //covel image
              CachedNetworkImage(
                height: 200,
                width: 500,
                imageUrl: widget.product!.coverImg,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              //details
              const SizedBox(height: 10),
              HeadText(text: "Category Name: ${widget.product!.categoryName}"),
              const SizedBox(height: 10),
              HeadText(text: "Product Name: ${widget.product!.productName}"),
              const SizedBox(height: 10),
              HeadText(
                  text:
                      "Product Description: ${widget.product!.productDescription}"),
              const SizedBox(height: 10),
              HeadText(
                  text: "Product Discount: ${widget.product!.productDiscount}"),
              const SizedBox(height: 10),
              HeadText(
                  text:
                      "Product Stock Quantity: ${widget.product!.stockQuantity}"),
              const SizedBox(height: 10),
              HeadText(
                  text:
                      "Product Stock Threshold: ${widget.product!.stockThreshold}"),
              const SizedBox(height: 10),
              HeadText(
                  text:
                      "Product createdAt: ${formatTimestamp(widget.product!.createdAt)}"),
              const SizedBox(height: 10),
              HeadText(
                  text:
                      "Product updatedAt: ${formatTimestamp(widget.product!.updatedAt)}"),
            ],
          )),
        ),
      ),
    );
    /*  }),
      ),
    ); */
  }
}
