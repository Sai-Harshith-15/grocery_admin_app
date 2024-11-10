import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/all_products_controller.dart';
import '../../../../controllers/sidebar_controller.dart';
import '../../../../routes/routes.dart';
import '../../../widgets/my_app_bar.dart';
import '../../../widgets/mytext.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/textfield.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final AllProductsController allProductsController =
      Get.find<AllProductsController>();

  final SidebarController sidebarController = Get.find<SidebarController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        // drawer: const MyDrawer(),
        appBar: MyAppBar(
          automaticallyImplyLeading: false,
          title: "All Products Screen",
          actions: [
            IconButton(
              onPressed: () {
                sidebarController.setPageByRoute(AppRoutes.addProductsScreen);
                // Get.toNamed(AppRoutes.addProductsScreen);
              },
              icon: Icon(
                Icons.add,
                color: AppColors.background,
              ),
            ),
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
            child: Obx(
              () {
                if (allProductsController.isLoading.value) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (allProductsController.productsList.isEmpty) {
                  return const Center(
                    child: HeadText(text: "No  Products Found"),
                  );
                }
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller:
                          allProductsController.searchProductsController,
                      hintText: "Search products here...",
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
                      child: allProductsController.filteredProductsList.isEmpty
                          ? const Center(
                              child: HeadText(
                                  text: "No products Available with This Name"),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: allProductsController
                                  .filteredProductsList.length,
                              itemBuilder: (context, index) {
                                final product = allProductsController
                                    .filteredProductsList[index];
                                return Dismissible(
                                  key: Key(product.productId),
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
                                    await allProductsController
                                        .deleteProductFromFirebase(
                                            product.productId);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Card(
                                      color: AppColors.background,
                                      elevation: 5,
                                      child: ListTile(
                                        onTap: () {
                                          /*  Get.toNamed(
                                          AppRoutes.singleProductDetailsScreen,
                                          arguments: product); */

                                          sidebarController.setPageByRoute(
                                            AppRoutes
                                                .singleProductDetailsScreen,
                                            arguments: product,
                                          );
                                        },
                                        leading: ClipRRect(
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: 100,
                                            imageUrl: product.coverImg,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                const CupertinoActivityIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        title: HeadText(
                                            text:
                                                "Name : ${product.productName}"),
                                        subtitle: HeadText(
                                            text:
                                                "des : ${product.productDescription}"),
                                        trailing: IconButton(
                                          onPressed: () {
                                            /*  Get.toNamed(
                                          AppRoutes.editProductsScreen,
                                          arguments: product,
                                        ); */
                                            sidebarController.setPageByRoute(
                                              AppRoutes.editProductsScreen,
                                              arguments: product,
                                            );
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
