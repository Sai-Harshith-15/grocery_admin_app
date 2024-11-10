import 'package:get/get.dart';
import '../Presentation/Admin/screens/category_management/add_categories_screen.dart';
import '../Presentation/Admin/screens/category_management/all_categories_screen.dart';
import '../Presentation/Admin/screens/category_management/edit_categories_screen.dart';
import '../Presentation/Admin/screens/category_management/single_category_details_screen.dart';
import '../Presentation/Admin/screens/product_management/add_products_screen.dart';
import '../Presentation/Admin/screens/users_management/add_user_screen.dart';
import '../Presentation/Admin/screens/users_management/all_users_screen.dart';
import '../Presentation/Admin/screens/users_management/edit_user_details_screen.dart';
import '../Presentation/Admin/screens/main_screen.dart';
import '../Presentation/Admin/screens/users_management/single_user_details_screen.dart';
import '../controllers/sidebar_controller.dart';
import '../presentation/Admin/screens/auth_screen/login_screen.dart';
import '../presentation/Admin/screens/media/media_storage_screen.dart';
import '../presentation/Admin/screens/orders_management/all_orders_screen.dart';
import '../presentation/Admin/screens/orders_management/single_order_details_screen.dart';
import '../presentation/Admin/screens/product_management/all_products_screen.dart';
import '../presentation/Admin/screens/product_management/edit_products_screen.dart';
import '../presentation/Admin/screens/product_management/single_product_screen.dart';
import '../presentation/Admin/screens/sidebar_screen/sidebar_screen.dart';

// Define your routes
class AppRoutes {
  static const String loginScreen = "/loginScreen";
  static const String sidebarScreen = '/sidebarScreen';
  static const String mainScreen = '/MainScreen';
  static const String mediaStorageScreen = '/MediaStorageScreen';
  static const String allOrdersScreen = '/AllOrdersScreen';
  static const String singleOrderDetailsScreen = '/SingleOrderDetailsScreen';
  static const String allUsersScreen = '/AllusersScreen';
  static const String singleUserDetailsScreen = '/SingleUserDetailsScreen';
  static const String addUserScreen = '/AddUserScreen';
  static const String editUserDetailsScreen = '/EditUserDetailsScreen';
  static const String allCategoriesScreen = '/AllCategoriesScreen';
  static const String addCategoriesScreen = '/AddCategoriesScreen';
  static const String singleCategoryDetailsScreen =
      '/SingleCategoryDetailsScreen';
  static const String editCategoriesScreen = '/EditCategoriesScreen';
  static const String addProductsScreen = '/AddProductsScreen';
  static const String allProductsScreen = '/AllProductsScreen';
  static const String singleProductDetailsScreen =
      '/SingleProductDetailsScreen';
  static const String editProductsScreen = '/EditProductsScreen';

  static final List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(
      name: sidebarScreen,
      page: () => const SidebarScreen(),
      binding: BindingsBuilder(() {
        Get.put(SidebarController());
      }),
      children: [
        GetPage(name: sidebarScreen, page: () => const SidebarScreen()),
        GetPage(name: mainScreen, page: () => const MainScreen()),
        GetPage(
            name: mediaStorageScreen, page: () => const MediaStorageScreen()),
        GetPage(name: allOrdersScreen, page: () => const AllOrdersScreen()),
        GetPage(
            name: singleOrderDetailsScreen,
            page: () => const SingleOrderDetailsScreen()),
        GetPage(name: allUsersScreen, page: () => const AllUsersScreen()),
        GetPage(
            name: singleUserDetailsScreen,
            page: () => SingleUserDetailsScreen()),
        GetPage(name: addUserScreen, page: () => const AddUserScreen()),
        GetPage(
            name: editUserDetailsScreen,
            page: () => const EditUserDetailsScreen()),
        GetPage(
            name: allCategoriesScreen, page: () => const AllCategoriesScreen()),
        GetPage(
            name: addCategoriesScreen, page: () => const AddCategoriesScreen()),
        GetPage(
            name: singleCategoryDetailsScreen,
            page: () => const SingleCategoryDetailsScreen()),
        GetPage(
            name: editCategoriesScreen, page: () => const EditCategoryScreen()),
        GetPage(name: addProductsScreen, page: () => const AddProductsScreen()),
        GetPage(name: allProductsScreen, page: () => const AllProductsScreen()),
        GetPage(
            name: singleProductDetailsScreen,
            page: () => const SingleProductDetailsScreen()),
        GetPage(name: editProductsScreen, page: () => EditProductsScreen()),

        // Add other child pages here
      ],
    ),
  ];
}
