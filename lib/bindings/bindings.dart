import 'package:get/get.dart';
import '../controllers/all_categories_controller.dart';
import '../controllers/all_orders_controller.dart';
import '../controllers/all_products_controller.dart';
import '../controllers/all_users_controller.dart';
import '../controllers/media_controller.dart';
import '../controllers/sidebar_controller.dart';
import '../data/interfaces/categories_interfaces.dart';
import '../data/interfaces/media_interfaces.dart';
import '../data/interfaces/orders_interfaces.dart';
import '../data/interfaces/products_interfaces.dart';
import '../data/interfaces/users_interfaces.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/media_repository.dart';
import '../data/repositories/orders_repository.dart';
import '../data/repositories/products_repository.dart';
import '../data/repositories/users_repository.dart';
import '../data/services/categories_services.dart';
import '../data/services/media_services.dart';
import '../data/services/orders_services.dart';
import '../data/services/products_services.dart';
import '../data/services/users_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    //side bar
    Get.lazyPut<SidebarController>(() => SidebarController());
    //user
    Get.lazyPut<Interfaces>(() => UsersServices());
    Get.lazyPut<UsersRepository>(
        () => UsersRepository(interfaces: Get.find<Interfaces>()));

    Get.lazyPut<AllUsersController>(
        () => AllUsersController(usersRepository: Get.find<UsersRepository>()));
    //category
    Get.lazyPut<CategoriesInterfaces>(() => CategoriesServices());
    Get.lazyPut<CategoryRepository>(
        () => CategoryRepository(interfaces: Get.find<CategoriesInterfaces>()));

    Get.lazyPut<AllCategoriesController>(() => AllCategoriesController(
        categoryRepository: Get.find<CategoryRepository>()));

    //products
    Get.lazyPut<ProductsInterfaces>(() => ProductsServices());
    Get.lazyPut<ProductsRepository>(
        () => ProductsRepository(interfaces: Get.find<ProductsInterfaces>()));

    Get.lazyPut(() => AllProductsController(
        productsRepository: Get.find<ProductsRepository>()));

    //media

    Get.lazyPut<MediaInterfaces>(() => MediaServices());
    Get.lazyPut<MediaRepository>(
        () => MediaRepository(interfaces: Get.find<MediaInterfaces>()));

    Get.lazyPut<MediaController>(
        () => MediaController(mediaRepository: Get.find<MediaRepository>()));

    //orders
    Get.lazyPut<OrdersInterfaces>(() => OrdersServices());
    Get.lazyPut<OrdersRepository>(
        () => OrdersRepository(interfaces: Get.find<OrdersInterfaces>()));

    Get.lazyPut<AllOrdersController>(() =>
        AllOrdersController(ordersRepository: Get.find<OrdersRepository>()));
  }
}
