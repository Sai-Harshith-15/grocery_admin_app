import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../globals/globals.dart';
import '../interfaces/orders_interfaces.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_address_model.dart';
import '../models/user_model.dart';

class OrdersServices implements OrdersInterfaces {
  @override
  Stream<List<OrderModel>> fetchOrdersFromFirebase() {
    // Create a StreamController to emit combined order updates
    final StreamController<List<OrderModel>> controller = StreamController();
    try {
      // Initialize an empty list to accumulate all orders from all users
      List<OrderModel> allOrders = [];

      // Fetch all user documents from the 'users' collection to get each userId
      Globals.firestore.collection("users").get().then((usersSnapshot) {
        for (var userDoc in usersSnapshot.docs) {
          String userId = userDoc.id;

          // Listen to each user's orders collection
          Globals.firestore
              .collection("users")
              .doc(userId)
              .collection("userOrders")
              .snapshots()
              .listen((snapshot) {
            // Update `allOrders` by replacing the user's orders with the latest data
            allOrders.removeWhere((order) => order.userId == userId);
            allOrders.addAll(snapshot.docs
                .map((doc) =>
                    OrderModel.fromMap(doc.data() as Map<String, dynamic>))
                .toList());

            // Sort orders by `createdAt` in descending order (newest to oldest)
            allOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            // Emit the updated list of all orders
            controller.add(List<OrderModel>.from(allOrders));
          });
        }
      }).catchError((error) {
        // Handle errors by adding them to the stream
        controller.addError("Failed to fetch orders: $error");
      });

      // Close the controller when the stream is no longer being listened to
      controller.onCancel = () {
        controller.close();
      };
    } catch (e) {
      print("Error fetching orders: $e");
    }

    return controller.stream;
  }

  @override
  Future<OrderModel?> fetchsingleOrderFromFirebase(String orderId) async {
    try {
      final String? userId = Globals.userId;
      if (userId == null) {
        print("User ID is null");
        return null;
      }
      DocumentSnapshot orderDoc = await Globals.firestore
          .collection("users")
          .doc(userId)
          .collection("userOrders")
          .doc(orderId)
          .get();
      if (orderDoc.exists) {
        return OrderModel.fromMap(orderDoc.data() as Map<String, dynamic>);
      } else {
        print("Order not found");
      }
    } catch (e) {
      print("Error fetching single order: $e");
    }
    return null;
  }

  //fetch the products

  @override
  Future<ProductModel?> getProductById(String productId) async {
    try {
      DocumentSnapshot productDoc =
          await Globals.firestore.collection("products").doc(productId).get();
      if (productDoc.exists) {
        return ProductModel.fromMap(productDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
    return null;
  }

  //fetch user

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await Globals.firestore.collection("users").doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
    return null;
  }

  //fetch user address

  @override
  Future<UserAddressModel?> getAddressById(
      String addressId, String userId) async {
    try {
      DocumentSnapshot addressDoc = await Globals.firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .get();
      if (addressDoc.exists) {
        return UserAddressModel.fromMap(
            addressDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching UserAdress: $e");
    }
    return null;
  }

  //delete order

  // Updated deleteOrderFromFirebase function
  @override
  Future<void> deleteOrderFromFirebase(String orderId, String userId) async {
    try {
      await Globals.firestore
          .collection("users")
          .doc(userId)
          .collection("userOrders")
          .doc(orderId)
          .delete();

      print("Order with ID $orderId has been deleted successfully.");
    } catch (e) {
      print("Error deleting order: $e");
      rethrow; // Optional: rethrow the error to handle it further upstream
    }
  }

  @override
  Future<void> updateOrderFromFirebase(
      String orderId, String userId, OrderStatus status) async {
    try {
      final DocumentReference orderdoc = Globals.firestore
          .collection("users")
          .doc(userId)
          .collection("userOrders")
          .doc(orderId);

      DocumentSnapshot existingOrderDetails = await orderdoc.get();

      if (!existingOrderDetails.exists) {
        throw Exception("Order does not exist.");
      }
      await orderdoc.update({
        'orderStatus': orderStatusToString(status),
        'updatedAt': Timestamp.now(),
      });

      print("Order with ID $orderId has been updated successfully.");
    } catch (e) {
      print("Error updating order: $e");
      rethrow;
    }
  }

  @override
  Future<void> toggleIsActiveUser(bool isActive, String userId) async {
    try {
      final DocumentReference userdoc =
          Globals.firestore.collection("users").doc(userId);

      DocumentSnapshot existingUserDetails = await userdoc.get();

      if (!existingUserDetails.exists) {
        throw Exception("User does not exist.");
      }
      await userdoc.update({
        "isActive": isActive,
        "updatedAt": Timestamp.now(),
      });
      print("isActive updated successfully.");
    } catch (e) {
      print("Error updating while toggling isActive: $e");
      rethrow;
    }
  }
}
