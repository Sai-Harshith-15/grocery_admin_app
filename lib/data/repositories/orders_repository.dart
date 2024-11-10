import '../interfaces/orders_interfaces.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_address_model.dart';
import '../models/user_model.dart';

class OrdersRepository {
  final OrdersInterfaces interfaces;

  OrdersRepository({required this.interfaces});

  Stream<List<OrderModel>> fetchOrdersFromFirebase() {
    return interfaces.fetchOrdersFromFirebase();
  }

  Future<OrderModel?> fetchsingleOrderFromFirebase(String orderId) async {
    return interfaces.fetchsingleOrderFromFirebase(orderId);
  }

  Future<ProductModel?> getProductById(String productId) async {
    return interfaces.getProductById(productId);
  }

  Future<UserModel?> getUserById(String userId) async {
    return interfaces.getUserById(userId);
  }

  Future<UserAddressModel?> getAddressById(
      String addressId, String userId) async {
    return interfaces.getAddressById(addressId, userId);
  }

  Future<void> deleteOrderFromFirebase(String orderId, String userId) async {
    return interfaces.deleteOrderFromFirebase(orderId, userId);
  }

  Future<void> updateOrderFromFirebase(
      String orderId, String userId, OrderStatus status) async {
    return interfaces.updateOrderFromFirebase(orderId, userId, status);
  }

  Future<void> toggleIsActiveUser(bool isActive, String userId) async {
    return interfaces.toggleIsActiveUser(isActive, userId);
  }

  Future<String?> fetchUsersEmailFromFirebase(
    String userId,
  ) async {
    return interfaces.fetchUsersEmailFromFirebase(userId);
  }
}
