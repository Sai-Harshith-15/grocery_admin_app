/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../constants/appcolors.dart';
import '../../routes/routes.dart';
import 'mytext.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 25),
      child: Drawer(
        backgroundColor: AppColors.primarygreen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: HeadText(
                  text: "Vav Foods Admin",
                  textColor: AppColors.background,
                ),
                subtitle: HeadText(
                  text: "Version 1.0.1",
                  textColor: AppColors.background,
                ),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.background,
                  child: HeadText(
                    text: "V",
                    textColor: AppColors.background,
                  ),
                ),
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1.5,
            ),
            //home
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () => Get.toNamed(AppRoutes.mainScreen),
                titleAlignment: ListTileTitleAlignment.center,
                title: HeadText(
                  text: "Home",
                  textColor: AppColors.background,
                ),
                leading: Icon(
                  Icons.home,
                  color: AppColors.background,
                ),
              ),
            ),

            //users
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () => Get.toNamed(AppRoutes.allUsersScreen),
                titleAlignment: ListTileTitleAlignment.center,
                title: HeadText(
                  text: "Users",
                  textColor: AppColors.background,
                ),
                leading: Icon(
                  Icons.group,
                  color: AppColors.background,
                ),
                /* trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ), */
              ),
            ),

            //categories
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () => Get.toNamed(AppRoutes.allCategoriesScreen),
                titleAlignment: ListTileTitleAlignment.center,
                title: HeadText(
                  text: "Categories",
                  textColor: AppColors.background,
                ),
                leading: Icon(
                  Icons.shopping_bag,
                  color: AppColors.background,
                ),
                /* trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ), */
              ),
            ),
            //products
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () => Get.toNamed(AppRoutes.allProductsScreen),
                titleAlignment: ListTileTitleAlignment.center,
                title: HeadText(
                  text: "Products",
                  textColor: AppColors.background,
                ),
                leading: Icon(
                  Icons.production_quantity_limits_sharp,
                  color: AppColors.background,
                ),
              ),
            ),
            //logout
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ListTile(
                onTap: () async {
                  // Get.toNamed(AppRoutes.welcomeScreen);
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: HeadText(
                  text: "Logout",
                  textColor: AppColors.background,
                ),
                leading: Icon(
                  Icons.logout,
                  color: AppColors.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */