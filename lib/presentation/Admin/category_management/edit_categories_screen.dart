import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/all_categories_controller.dart';
import '../../../../data/models/category_model.dart';
import '../../../constants/app_colors.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/mytext.dart';
import '../../widgets/responsive.dart';
import '../../widgets/textfield.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({super.key});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (allCategoriesController.isLoading.value) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: MyAppBar(title: 'Category Details'),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final category = allCategoriesController.selectedCategory.value;
        if (category == null) {
          return Scaffold(
            appBar: MyAppBar(title: "Category Details"),
            body: const Center(
              child: HeadText(text: 'No Category data found'),
            ),
          );
        }

        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: MyAppBar(
              title: 'Edit ${category.categoryName} Details',
            ),
            body: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.isDesktop(context) ||
                            Responsive.isDesktopLarge(context)
                        ? MediaQuery.of(context).size.width * .4
                        : Responsive.isTablet(context)
                            ? MediaQuery.of(context).size.width * .7
                            : Responsive.isMobile(context)
                                ? MediaQuery.of(context).size.width * 1
                                : MediaQuery.of(context).size.width * .9,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Category Name TextField
                        CustomTextField(
                          controller:
                              allCategoriesController.categoryNameController,
                          hintText: 'Category Name',
                          // labelText: const HeadText(text: 'Category Name'),
                        ),
                        const SizedBox(height: 10),

                        // Category Description TextField
                        CustomTextField(
                          controller: allCategoriesController
                              .categoryDescriptionController,
                          maxLines: 3,
                          hintText: 'Category Description',
                          // labelText:
                          //     const HeadText(text: 'Category Description'),
                        ),
                        const SizedBox(height: 20),

                        // Display Selected Image or Existing Image
                        allCategoriesController.selectedImage.value != null
                            ? Image.memory(
                                allCategoriesController.webImageByte.value!,
                                height: 250,
                                width: 250,
                              )
                            : allCategoriesController
                                    .uploadedImageUrl.value.isNotEmpty
                                ? Image.network(
                                    allCategoriesController
                                        .uploadedImageUrl.value,
                                    height: 250,
                                    width: 250,
                                  )
                                : Container(),

                        const SizedBox(height: 10),

                        // Image picker button
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Show the image picker dialog
                            await allCategoriesController
                                .showImagesPickDialog();
                          },
                          icon: const Icon(Icons.image),
                          label: const HeadText(text: 'Pick Image'),
                        ),
                        const SizedBox(height: 20),

                        // Update Category Button
                        ElevatedButton(
                          onPressed: () async {
                            // Upload the selected image if any
                            if (allCategoriesController.selectedImage.value !=
                                null) {
                              await allCategoriesController
                                  .uploadSelectedImage();
                            }

                            // Call the update category function
                            await allCategoriesController
                                .updateCategoriesFromFirebase(categoryId!);
                            Get.snackbar(
                                'Success', 'Category updated successfully');
                            Get.back(); // Navigate back after updating
                          },
                          child: const HeadText(text: 'Update Category'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
