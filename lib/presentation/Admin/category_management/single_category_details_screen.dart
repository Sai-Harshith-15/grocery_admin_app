import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/all_categories_controller.dart';
import '../../../../data/models/category_model.dart';
import '../../../constants/app_colors.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/mytext.dart';
import '../../widgets/responsive.dart';

class SingleCategoryDetailsScreen extends StatefulWidget {
  const SingleCategoryDetailsScreen({super.key});

  @override
  State<SingleCategoryDetailsScreen> createState() =>
      _SingleCategoryDetailsScreenState();
}

class _SingleCategoryDetailsScreenState
    extends State<SingleCategoryDetailsScreen> {
  final AllCategoriesController allCategoriesController =
      Get.find<AllCategoriesController>();

  String? categoryId;

  @override
  void initState() {
    super.initState();

    categoryId = (Get.arguments as CategoryModel?)?.categoryId;
    if (categoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        allCategoriesController.fetchCategoryById(categoryId!);
      });
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        // appBar: MyAppBar(title: "Category Details"),
        body: Obx(() {
          if (allCategoriesController.isLoading.value) {
            return const Center(child: CupertinoActivityIndicator());
          }
          final category = allCategoriesController.selectedCategory.value;
          if (category == null) {
            return const Center(
              child: HeadText(text: 'No category found.'),
            );
          }
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: MyAppBar(
                title: category != null
                    ? '${category.categoryName} Category Details'
                    : 'Loading Category Details...',
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: Responsive.isDesktop(context) ||
                                Responsive.isDesktopLarge(context)
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              height: 200,
                              width: 500,
                              imageUrl: category.categoryImg,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(height: 10),
                          HeadText(
                              text: "Category Name: ${category.categoryName}"),
                          const SizedBox(height: 10),
                          HeadText(
                              text:
                                  "Category Description: ${category.categoryDescription}"),
                          const SizedBox(height: 10),
                          HeadText(text: "CategoryId: ${category.categoryId}"),
                          const SizedBox(height: 10),
                          HeadText(
                              text:
                                  "CreatedAt: ${formatTimestamp(category.createdAt)}"),
                          const SizedBox(height: 10),
                          HeadText(
                              text:
                                  "UpdatedAt: ${formatTimestamp(category.updatedAt)}"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
