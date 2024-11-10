import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controllers/sidebar_controller.dart';
import '../../../../routes/routes.dart';
import '../../../widgets/mytext.dart';

class SidebarScreen extends StatefulWidget {
  const SidebarScreen({super.key});

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  final SidebarController controller = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 50,
            width: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Logo.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: AppColors.primaryBlack,
              size: 25,
            ),
          ),
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
                "https://e7.pngegg.com/pngimages/348/800/png-clipart-man-wearing-blue-shirt-illustration-computer-icons-avatar-user-login-avatar-blue-child.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadText(text: "App Admin"),
                HeadText(text: "admin@gmail.com"),
              ],
            ),
          ),
        ],
      ),
      sideBar: SideBar(
        borderColor: Colors.black,
        textStyle: TextStyle(color: AppColors.primaryBlack, fontSize: 14),
        activeTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        activeIconColor: AppColors.primaryGreen,
        activeBackgroundColor: AppColors.primaryGreen,
        iconColor: AppColors.secondaryGreen,
        header: HeadText(
          text: "Admin Pannel",
          textSize: 16,
          textWeight: FontWeight.w700,
          textColor: AppColors.primaryBlack,
        ),
        footer: TextButton.icon(
          // style: TextButton.styleFrom(),
          onPressed: () {},
          label: HeadText(
            text: "Logout",
            textColor: AppColors.primaryBlack,
            textSize: 16,
            textWeight: FontWeight.w700,
          ),
          icon: Icon(
            Icons.logout,
            color: AppColors.primaryGreen,
          ),
        ),
        backgroundColor: AppColors.background,
        items: _buildSidebarItems(),
        selectedRoute: controller.selectedRoute.value,
        onSelected: (item) {
          final String route = item.route ?? '';
          controller.setPageByRoute(route);
          controller.selectedRoute.value = route;
        },
      ),
      body: Obx(() {
        final selectedPage = controller.selectedPage.value;
        return selectedPage ?? Container();
      }),
    );
  }

  // Method to dynamically build the sidebar items including dropdowns
  List<AdminMenuItem> _buildSidebarItems() {
    return SidebarIten.values.map((e) {
      if (e.children != null && e.children!.isNotEmpty) {
        // If the item has children, build a dropdown
        return AdminMenuItem(
          title: e.value!,
          icon: e.iconData,
          children: e.children!.map((child) {
            return AdminMenuItem(
              title: child.value!,
              icon: child.iconData,
              route: child.route,
            );
          }).toList(),
        );
      }
      // Otherwise, create a normal sidebar item
      return AdminMenuItem(
        title: e.value!,
        icon: e.iconData,
        route: e.route,
      );
    }).toList();
  }
}

enum SidebarIten {
  dashboard(
    value: "Dashboard",
    iconData: Icons.dashboard,
    route: AppRoutes.mainScreen,
  ),

  //media
  mediaStorage(
    value: "Media Storage",
    iconData: Icons.storage,
    route: AppRoutes.mediaStorageScreen,
  ),

  //orders
  orderManagement(
    value: "Order Management",
    iconData: Icons.inbox,
    route: AppRoutes.allOrdersScreen,
  ),

  //User
  userManagement(
    value: "User Management",
    iconData: Icons.people_alt,
    children: [
      SidebarItemData(
        value: "All User",
        iconData: Icons.group,
        route: AppRoutes.allUsersScreen,
      ),
      SidebarItemData(
        value: "Add User",
        iconData: Icons.person_add,
        route: AppRoutes.addUserScreen,
      ),
    ],
  ),
  //product
  productManagement(
    value: "Product Management",
    iconData: Icons.people_alt,
    children: [
      SidebarItemData(
        value: "All Categories",
        iconData: Icons.category,
        route: AppRoutes.allCategoriesScreen,
        /*  children: [
          SidebarItemData(
            value: "Add Category",
            iconData: Icons.category_outlined,
            route: AppRoutes.addCategoriesScreen,
          ),
          SidebarItemData(
            value: "Add Category",
            iconData: Icons.category_outlined,
            route: AppRoutes.addCategoriesScreen,
          ),
        ], */
      ),
      SidebarItemData(
        value: "Add Category",
        iconData: Icons.category_outlined,
        route: AppRoutes.addCategoriesScreen,
      ),
      SidebarItemData(
        value: "All Products",
        iconData: Icons.production_quantity_limits_sharp,
        route: AppRoutes.allProductsScreen,
      ),
      SidebarItemData(
        value: "Add Product",
        iconData: Icons.shopping_basket,
        route: AppRoutes.addProductsScreen,
      ),
    ],
  );

  const SidebarIten({
    this.value,
    this.iconData,
    this.route,
    this.children,
  });

  final String? value;
  final IconData? iconData;
  final String? route;
  final List<SidebarItemData>? children; // Children for dropdown
}

// Separate data class for child items
class SidebarItemData {
  const SidebarItemData({
    required this.value,
    required this.iconData,
    required this.route,
    this.children = const [],
  });

  final String value;
  final IconData iconData;
  final String route;
  final List<SidebarItemData> children;
}
