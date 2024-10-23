import 'package:get/get.dart';

import '../controllers/all_categories_controller.dart';
import '../controllers/all_products_controller.dart';
import '../controllers/all_users_controller.dart';
import '../data/interfaces/categories_interfaces.dart';
import '../data/interfaces/products_interfaces.dart';
import '../data/interfaces/users_interfaces.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/products_repository.dart';
import '../data/repositories/users_repository.dart';
import '../data/services/categories_services.dart';
import '../data/services/products_services.dart';
import '../data/services/users_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<Interfaces>(() => FirebaseAuthServices());
    Get.lazyPut<Interfaces>(() => UsersServices());
    Get.lazyPut<UsersRepository>(
        () => UsersRepository(interfaces: Get.find<Interfaces>()));

    Get.lazyPut<AllUsersController>(
        () => AllUsersController(usersRepository: Get.find<UsersRepository>()));
    //category repo
    Get.lazyPut<CategoryRepository>(
        () => CategoryRepository(interfaces: Get.find<CategoriesInterfaces>()));
    //category interfaces
    Get.lazyPut<CategoriesInterfaces>(() => CategoriesServices());
    //all categories controller
    Get.lazyPut<AllCategoriesController>(() => AllCategoriesController(
        categoryRepository: Get.find<CategoryRepository>()));

    //products
    Get.lazyPut<ProductsInterfaces>(() => ProductsServices());
    Get.lazyPut<ProductsRepository>(
        () => ProductsRepository(interfaces: Get.find<ProductsInterfaces>()));

    Get.lazyPut(() => AllProductsController(
        productsRepository: Get.find<ProductsRepository>()));
  }
}
