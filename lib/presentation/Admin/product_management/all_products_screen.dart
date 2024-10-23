import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/all_products_controller.dart';
import '../../../../routes/routes.dart';
import '../../../constants/app_colors.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_drawer.dart';
import '../../widgets/mytext.dart';
import '../../widgets/responsive.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final AllProductsController allProductsController =
      Get.find<AllProductsController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: const MyDrawer(),
        appBar: MyAppBar(
          title: "All Products Screen",
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.addProductsScreen);
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
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: allProductsController.productsList.length,
                    itemBuilder: (context, index) {
                      final product = allProductsController.productsList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Card(
                          color: AppColors.background,
                          elevation: 5,
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(AppRoutes.singleProductDetailsScreen,
                                  arguments: product);
                            },
                            leading: ClipRRect(
                              child: CachedNetworkImage(
                                height: 100,
                                width: 100,
                                imageUrl: product.coverImg,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            title:
                                HeadText(text: "Name : ${product.productName}"),
                            subtitle: HeadText(
                                text: "des : ${product.productDescription}"),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
