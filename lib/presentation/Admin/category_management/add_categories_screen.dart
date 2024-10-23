// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../controllers/all_categories_controller.dart';
import '../../../../routes/routes.dart';
import '../../../constants/app_colors.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/mytext.dart';
import '../../widgets/responsive.dart';
import '../../widgets/textfield.dart';

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({super.key});

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final AllCategoriesController allCategoriesController =
      Get.find<AllCategoriesController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Schedule clearing of text controllers after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      allCategoriesController.categoryNameController.clear();
      allCategoriesController.categoryDescriptionController.clear();

      // Optional: Debugging print statements
      print(
          "Category Name cleared: ${allCategoriesController.categoryNameController.text}");
      print(
          "Category Description cleared: ${allCategoriesController.categoryDescriptionController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => allCategoriesController.isLoading.value
            ? const Center(child: CupertinoActivityIndicator())
            : Scaffold(
                backgroundColor: AppColors.background,
                appBar: MyAppBar(
                  leading: IconButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.allCategoriesScreen);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  title: "Add Category Screen",
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
                                : MediaQuery.of(context).size.width,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const HeadText(text: 'Select Image'),
                                ElevatedButton(
                                  onPressed: () async {
                                    await allCategoriesController
                                        .showImagesPickDialog();
                                  },
                                  child: const HeadText(text: 'Select Image'),
                                ),
                              ],
                            ),
                          ),
                          /*    Obx(() {
                            return */
                          allCategoriesController.selectedImage.value != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: SizedBox(
                                    height: 300,
                                    width: 500,
                                    child: Stack(
                                      children: [
                                        kIsWeb
                                            ? Image.memory(
                                                allCategoriesController
                                                    .webImageByte.value!,
                                                fit: BoxFit.cover,
                                                height: 500,
                                                width: 500,
                                              )
                                            : Image.file(
                                                File(allCategoriesController
                                                    .selectedImage.value!.path),
                                                fit: BoxFit.cover,
                                                height: 500,
                                                width: 500,
                                              ),
                                        Positioned(
                                          right: 10,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              allCategoriesController
                                                  .removeSelectedImage();
                                            },
                                            child: const CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          // }),
                          const SizedBox(height: 25),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hintText: 'Category Name',
                                    controller: allCategoriesController
                                        .categoryNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Category Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                    hintText: 'Category Description',
                                    controller: allCategoriesController
                                        .categoryDescriptionController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Category Description';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        allCategoriesController
                                            .isLoading.value = true;
                                        // Trigger loading state and upload the selected image
                                        await allCategoriesController
                                            .uploadSelectedImage();
                                        // Add category to Firebase
                                        await allCategoriesController
                                            .addCategoryToFirebase();
                                        allCategoriesController
                                            .isLoading.value = false;
                                        print("Data added into firebase");
                                      }
                                      allCategoriesController
                                          .categoryNameController
                                          .clear();
                                      allCategoriesController
                                          .categoryDescriptionController
                                          .clear();
                                    },
                                    child: const HeadText(
                                      text: 'Add Category',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
