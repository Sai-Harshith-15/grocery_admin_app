// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import '../data/models/order_model.dart';
import '../data/models/product_model.dart';
import '../data/models/user_address_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/orders_repository.dart';
import '../globals/globals.dart';

class AllOrdersController extends GetxController {
  final OrdersRepository ordersRepository;
  AllOrdersController({required this.ordersRepository});
  var isLoading = true.obs;
  RxList<OrderModel> ordersList = <OrderModel>[].obs;

  Rx<OrderModel?> selectedOrderStatus = Rx<OrderModel?>(null);

  Rx<OrderModel?> selectedOrderDetails = Rx<OrderModel?>(null);

  RxBool toggleIsActive = true.obs;

  RxBool isCopied = false.obs;

  RxDouble stripeFee = 5.00.obs;

  late final StreamSubscription<List<OrderModel>> ordersSubscription;

  TextEditingController searchController = TextEditingController();
  RxList<OrderModel> filterOrderList = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrdersFromFirebase();
    searchController.addListener(() {
      filterOrders(searchController.text);
    });
  }

  void filterOrders(String data) {
    if (data.isEmpty) {
      filterOrderList.assignAll(ordersList);
    } else {
      filterOrderList.value = ordersList
          .where((order) =>
              order.orderId.toLowerCase().contains(data.toLowerCase()))
          .toList();
      filterOrderList.value = ordersList
          .where((order) => Globals.formatTimestamp(order.createdAt)
              .toLowerCase()
              .contains(data.toLowerCase()))
          .toList();
    }
  }

  Future<void> fetchOrdersFromFirebase() async {
    try {
      isLoading.value = true;
      ordersSubscription =
          ordersRepository.fetchOrdersFromFirebase().listen((fetchOrders) {
        ordersList.assignAll(fetchOrders);
        filterOrderList.assignAll(fetchOrders);
        isLoading.value = false;
      }, onError: (e) {
        isLoading.value = false;
        Get.snackbar("Error", "Error in fetching orders: $e");
      });
    } catch (e) {
      print('Error fetching Orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchsingleOrderFromFirebase(String orderId) async {
    try {
      isLoading.value = true;
      final OrderModel? order =
          await ordersRepository.fetchsingleOrderFromFirebase(orderId);
      if (order != null) {
        selectedOrderDetails.value = order;
      } else {
        print("Order not found");
      }
    } catch (e) {
      print("Error fetching single order details: $e");
    } finally {
      isLoading.value = false;
    }
  }

//products
  Future<ProductModel?> getProductById(String productId) async {
    try {
      isLoading.value = true;
      ProductModel? product = await ordersRepository.getProductById(productId);
      if (product != null) {
        // print("Product Name: ${product.productName}");
        return product;
      } else {
        print("product not found");
      }
    } catch (e) {
      print("Error in fetching the order product details: $e");
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  //user data

  Future<UserModel?> getUserById(String userId) async {
    try {
      isLoading.value = true;
      UserModel? user = await ordersRepository.getUserById(userId);
      if (user != null) {
        // print("user Name: ${user.fullName}");
        return user;
      } else {
        print("User not found");
      }
    } catch (e) {
      print("Error in fetching the order user details: $e");
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  //address data

  Future<UserAddressModel?> getAddressById(
      String addressId, String userId) async {
    try {
      isLoading.value = true;
      UserAddressModel? address =
          await ordersRepository.getAddressById(addressId, userId);

      if (address != null) {
        return address;
      } else {
        print("address not found");
      }
    } catch (e) {
      print("Error in fetching the order address details: $e");
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  //delete order

  Future<void> deleteOrderFromFirebase(String orderId, String userId) async {
    try {
      isLoading.value = true;
      await ordersRepository.deleteOrderFromFirebase(orderId, userId);
      toast("$orderId deleted successfully");
    } catch (e) {
      print("Error in deleting the order: $e");
      toast("failed to delete the order");
    } finally {
      isLoading.value = false;
    }
  }

  //update order details

  Future<void> updateOrderFromFirebase(
      String orderId, String userId, OrderStatus status) async {
    try {
      isLoading.value = true;
      if (orderId.isEmpty || userId.isEmpty) {
        throw Exception("Order ID or User ID is empty.");
      }
      await ordersRepository.updateOrderFromFirebase(orderId, userId, status);
      toast("Order status updated successfully");
    } catch (e) {
      print("Error updating order: $e");
    } finally {
      isLoading.value = false;
    }
  }

//toggling the isActive switch
  Future<void> toggleIsActiveUser(bool isActive, String userId) async {
    try {
      isLoading.value = true;
      await ordersRepository.toggleIsActiveUser(isActive, userId);
      toggleIsActive.value = isActive;
    } catch (e) {
      print("Error in toggling the user isActive: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //copied the details function

  Future<void> copiedDetails(String copiedText) async {
    try {
      if (copiedText.isNotEmpty) {
        await Clipboard.setData(ClipboardData(text: copiedText));

        //set isCopied to true

        isCopied.value = true;
        Future.delayed(const Duration(seconds: 2), () {
          isCopied.value = false;
        });
      }
    } catch (e) {
      print("Error in copying the details: $e");
    }
  }

  @override
  void onClose() {
    ordersSubscription.cancel();
    super.onClose();
  }
}
