import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/all_categories_controller.dart';
import '../../../../controllers/sidebar_controller.dart';
import '../../../../routes/routes.dart';
import '../../../widgets/my_app_bar.dart';
import '../../../widgets/mytext.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/textfield.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});
  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final SidebarController sidebarController = Get.find<SidebarController>();
  final AllCategoriesController allCategoriesController =
      Get.find<AllCategoriesController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(
          automaticallyImplyLeading: false,
          title: 'All Categories Screen',
          actions: [
            /* IconButton(
              onPressed: () {
                /*  Get.toNamed(
                  AppRoutes.addCategoriesScreen,
                ); */
                sidebarController.setPageByRoute(
                  AppRoutes.addCategoriesScreen,
                );
              },
              icon: Icon(
                Icons.add,
                color: AppColors.background,
              ),
            ), */
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.isDesktop(context) ||
                      Responsive.isDesktopLarge(context)
                  ? MediaQuery.of(context).size.width * .5
                  : Responsive.isTablet(context)
                      ? MediaQuery.of(context).size.width * .8
                      : Responsive.isMobile(context)
                          ? MediaQuery.of(context).size.width * 1
                          : MediaQuery.of(context).size.width * .9,
            ),
            child: Obx(() {
              if (allCategoriesController.isLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (allCategoriesController.categoriesList.isEmpty) {
                return const Center(
                  child: HeadText(text: "No Categories Found"),
                );
              }
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //search bar
                  CustomTextField(
                    controller:
                        allCategoriesController.searchCategoriesController,
                    hintText: "Search categories here...",
                    // prefix: Icons.search,
                    labelText: HeadText(
                      text: "Search",
                      textSize: Responsive.isDesktop(context) ||
                              Responsive.isDesktopLarge(context)
                          ? 14
                          : 16,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryBlack, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryBlack, width: 1),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: allCategoriesController
                            .filteredCategoriesList.isEmpty
                        ? const Center(
                            child: HeadText(
                                text: "No Categories Available with This Name"),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: allCategoriesController
                                .filteredCategoriesList.length,
                            itemBuilder: (context, index) {
                              final category = allCategoriesController
                                  .filteredCategoriesList[index];

                              return Dismissible(
                                key: Key(category.categoryId),
                                movementDuration: const Duration(seconds: 2),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  await allCategoriesController
                                      .deleteCategoryFromFirebase(
                                          category.categoryId);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Card(
                                    color: AppColors.background,
                                    elevation: 5,
                                    child: ListTile(
                                      onTap: () {
                                        sidebarController.setPageByRoute(
                                          AppRoutes.singleCategoryDetailsScreen,
                                          arguments: category,
                                        );
                                      },
                                      leading: ClipRRect(
                                        child: CachedNetworkImage(
                                          height: 100,
                                          width: 100,
                                          imageUrl: category.categoryImg,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              const CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      title: HeadText(
                                          text:
                                              "name: ${category.categoryName}"),
                                      subtitle: HeadText(
                                        text:
                                            "des: ${category.categoryDescription}",
                                        isTextOverflow: false,
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            /*  Get.toNamed(
                                          AppRoutes.editCategoriesScreen,
                                          arguments: category,
                                        ); */
                                            sidebarController.setPageByRoute(
                                              AppRoutes.editCategoriesScreen,
                                              arguments: category,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                          )),
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
