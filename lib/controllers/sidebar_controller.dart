import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../data/models/category_model.dart';
import '../data/models/order_model.dart';
import '../data/models/product_model.dart';
import '../data/models/user_model.dart';
import '../presentation/Admin/screens/category_management/add_categories_screen.dart';
import '../presentation/Admin/screens/category_management/all_categories_screen.dart';
import '../presentation/Admin/screens/category_management/edit_categories_screen.dart';
import '../presentation/Admin/screens/category_management/single_category_details_screen.dart';
import '../presentation/Admin/screens/main_screen.dart';
import '../presentation/Admin/screens/media/media_storage_screen.dart';
import '../presentation/Admin/screens/orders_management/all_orders_screen.dart';
import '../presentation/Admin/screens/orders_management/single_order_details_screen.dart';
import '../presentation/Admin/screens/product_management/add_products_screen.dart';
import '../presentation/Admin/screens/product_management/all_products_screen.dart';
import '../presentation/Admin/screens/product_management/edit_products_screen.dart';
import '../presentation/Admin/screens/product_management/single_product_screen.dart';
import '../presentation/Admin/screens/users_management/add_user_screen.dart';
import '../presentation/Admin/screens/users_management/all_users_screen.dart';
import '../presentation/Admin/screens/users_management/edit_user_details_screen.dart';
import '../presentation/Admin/screens/users_management/single_user_details_screen.dart';
import '../routes/routes.dart';

class SidebarController extends GetxController {
  Rxn<Widget> selectedPage = Rxn<Widget>(const MainScreen()); // Default page
  RxString selectedRoute = ''.obs; // Track selected route

  // Set the selected page based on the route
  void setPageByRoute(String route, {dynamic arguments}) {
    switch (route) {
      case AppRoutes.mediaStorageScreen:
        selectedPage.value = const MediaStorageScreen();
        break;
      case AppRoutes.allOrdersScreen:
        selectedPage.value = const AllOrdersScreen();
        break;
      case AppRoutes.singleOrderDetailsScreen:
        selectedPage.value =
            SingleOrderDetailsScreen(order: arguments as OrderModel);
        break;
      case AppRoutes.allUsersScreen:
        selectedPage.value = const AllUsersScreen();
        break;
      case AppRoutes.addUserScreen:
        selectedPage.value = const AddUserScreen();
        break;
      case AppRoutes.singleUserDetailsScreen:
        selectedPage.value =
            SingleUserDetailsScreen(user: arguments as UserModel);
        break;
      case AppRoutes.editUserDetailsScreen:
        selectedPage.value =
            EditUserDetailsScreen(user: arguments as UserModel);
        break;
      case AppRoutes.allCategoriesScreen:
        selectedPage.value = const AllCategoriesScreen();
        break;
      case AppRoutes.addCategoriesScreen:
        selectedPage.value = const AddCategoriesScreen();
        break;
      case AppRoutes.singleCategoryDetailsScreen:
        selectedPage.value =
            SingleCategoryDetailsScreen(category: arguments as CategoryModel);
        break;
      case AppRoutes.editCategoriesScreen:
        selectedPage.value =
            EditCategoryScreen(category: arguments as CategoryModel);
        break;

      case AppRoutes.allProductsScreen:
        selectedPage.value = const AllProductsScreen();
        break;
      case AppRoutes.addProductsScreen:
        selectedPage.value = const AddProductsScreen();
        break;
      case AppRoutes.singleProductDetailsScreen:
        selectedPage.value =
            SingleProductDetailsScreen(product: arguments as ProductModel);
        break;
      case AppRoutes.editProductsScreen:
        selectedPage.value =
            EditProductsScreen(product: arguments as ProductModel);
        break;

      // Add other routes as needed
      default:
        selectedPage.value = const MainScreen(); // Default page
    }
  }
}
