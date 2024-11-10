/* import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  Pending,
  Processing,
  OrderConfirmed,
  OutForDelivery,
  Delivered,
  Cancelled,
}

class OrderModel {
  final String orderId;
  final String userId;
  final List<Map<String, dynamic>> items;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String addressId;
  OrderStatus orderStatus;
  final bool applyCoupon;
  final double deliveryTip;
  final String deliveryInstructions;
  final double totalAmount;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    required this.addressId,
    required this.orderStatus,
    required this.applyCoupon,
    required this.deliveryTip,
    required this.deliveryInstructions,
    required this.totalAmount,
  });

  // Method to convert the OrderModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'addressId': addressId,
      'orderStatus': orderStatus.toString().split('.').last,
      'applyCoupon': applyCoupon,
      'deliveryTip': deliveryTip,
      'deliveryInstructions': deliveryInstructions,
      'totalAmount': totalAmount,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      createdAt: map['createdAt'] ?? Timestamp.now(),
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
      addressId: map['addressId'] ?? '',
      orderStatus: OrderStatus.values.firstWhere(
        (status) => status.toString().split('.').last == map['orderStatus'],
        orElse: () => OrderStatus.OrderConfirmed,
      ),
      applyCoupon: map['applyCoupon'] ?? false,
      deliveryTip: map['deliveryTip'] ?? 0.0,
      deliveryInstructions: map['deliveryInstructions'] ?? '',
      totalAmount: map['totalAmount'] ?? 0.0,
    );
  }
}

// Helper function to convert OrderStatus enum to a string
String orderStatusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.Pending:
      return 'Pending';
    case OrderStatus.Processing:
      return 'Processing';
    case OrderStatus.OrderConfirmed:
      return 'OrderConfirmed';
    case OrderStatus.OutForDelivery:
      return 'OutForDelivery';
    case OrderStatus.Delivered:
      return 'Delivered';
    case OrderStatus.Cancelled:
      return 'Cancelled';
    default:
      return 'failed';
  }
}
 */

import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  orderConfirmed,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderModel {
  final String orderId;
  final String userId;
  final List<Map<String, dynamic>> items;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String addressId;
  OrderStatus orderStatus;
  final bool applyCoupon;
  final String deliveryInstructions;
  final Map<String, dynamic> totalPrice;
  final bool express;

  OrderModel(
      {required this.orderId,
      required this.userId,
      required this.items,
      required this.createdAt,
      required this.updatedAt,
      required this.addressId,
      required this.orderStatus,
      required this.applyCoupon,
      required this.deliveryInstructions,
      required this.totalPrice,
      required this.express});

  // Method to convert the OrderModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'addressId': addressId,
      'orderStatus': orderStatus.toString().split('.').last,
      'applyCoupon': applyCoupon,
      'deliveryInstructions': deliveryInstructions,
      'totalPrice': totalPrice,
      'express': express
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        orderId: map['orderId'] ?? '',
        userId: map['userId'] ?? '',
        items: List<Map<String, dynamic>>.from(map['items'] ?? []),
        createdAt: map['createdAt'] ?? Timestamp.now(),
        updatedAt: map['updatedAt'] ?? Timestamp.now(),
        addressId: map['addressId'] ?? '',
        orderStatus: OrderStatus.values.firstWhere(
          (status) => status.toString().split('.').last == map['orderStatus'],
        ),
        applyCoupon: map['applyCoupon'] ?? '',
        deliveryInstructions: map['deliveryInstructions'] ?? '',
        totalPrice: Map<String, dynamic>.from(map['totalPrice'] ?? {}),
        express: map['express'] ?? false);
  }
}

String orderStatusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.orderConfirmed:
      return 'orderConfirmed';
    case OrderStatus.outForDelivery:
      return 'outForDelivery';
    case OrderStatus.delivered:
      return 'delivered';
    case OrderStatus.cancelled:
      return 'cancelled';
    default:
      return 'unknown';
  }
}
