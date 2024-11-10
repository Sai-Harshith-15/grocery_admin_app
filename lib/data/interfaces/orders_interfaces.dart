import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_address_model.dart';
import '../models/user_model.dart';

abstract class OrdersInterfaces {
  //fetch the all orders
  Stream<List<OrderModel>> fetchOrdersFromFirebase();
  //fetch the single order
  Future<OrderModel?> fetchsingleOrderFromFirebase(String orderId);
  //user Data
  Future<UserModel?> getUserById(String userId);
  //Product Data
  Future<ProductModel?> getProductById(String productId);

  //adrress data
  Future<UserAddressModel?> getAddressById(String addressId, String userId);

  //delete order
  Future<void> deleteOrderFromFirebase(String orderId, String userId);

  //update order
  Future<void> updateOrderFromFirebase(
      String orderId, String userId, OrderStatus status);

  Future<void> toggleIsActiveUser(bool isActive, String userId);

  //fetch the all user's email
  Future<String?> fetchUsersEmailFromFirebase(
    String userId,
  );
}
