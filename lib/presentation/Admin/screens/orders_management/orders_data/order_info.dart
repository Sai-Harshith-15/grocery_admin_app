import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../controllers/all_orders_controller.dart';
import '../../../../../data/models/order_model.dart';
import '../../../../../globals/globals.dart';
import '../../../../widgets/mytext.dart';

class OrderInformationCard extends StatefulWidget {
  final OrderModel? order;
  const OrderInformationCard({super.key, this.order});

  @override
  State<OrderInformationCard> createState() => _OrderInformationCardState();
}

class _OrderInformationCardState extends State<OrderInformationCard> {
  final AllOrdersController allOrdersController =
      Get.find<AllOrdersController>();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: AppColors.background,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //order information
            const HeadText(
              textSize: 16,
              textWeight: FontWeight.w700,
              text: "Order Information",
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //date
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeadText(
                        text: "Date",
                        textColor: Colors.grey,
                        textSize: 16,
                        textWeight: FontWeight.w400,
                      ),
                      HeadText(
                        text: Globals.formatTimestamp(widget.order!.createdAt),
                        textSize: 16,
                        textWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                //items
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeadText(
                        text: "Ordered Items",
                        textColor: Colors.grey,
                        textSize: 16,
                        textWeight: FontWeight.w400,
                      ),
                      HeadText(
                        text: widget.order!.items.length.toString(),
                        textSize: 16,
                        textWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                //Status
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeadText(
                        text: "Status",
                        textColor: Colors.grey,
                        textSize: 16,
                        textWeight: FontWeight.w400,
                      ),
                      DropdownButton<OrderStatus>(
                        dropdownColor: AppColors.background,
                        value:
                            widget.order!.orderStatus, // Current order status
                        onChanged: (OrderStatus? newStatus) async {
                          if (newStatus != null) {
                            setState(() {
                              widget.order!.orderStatus =
                                  newStatus; // Update UI
                            });
                            // Call function to update Firebase
                            await allOrdersController.updateOrderFromFirebase(
                              widget.order!.orderId,
                              widget.order!.userId,
                              newStatus,
                            );
                          }
                        },
                        items: OrderStatus.values.map((OrderStatus status) {
                          return DropdownMenuItem<OrderStatus>(
                            value: status,
                            child: HeadText(
                              text: orderStatusToString(
                                  status), // Convert enum to readable string
                              textSize: 16,
                              textWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                //total
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeadText(
                        text: "Total Amount",
                        textColor: Colors.grey,
                        textSize: 16,
                        textWeight: FontWeight.w400,
                      ),
                      HeadText(
                        text:
                            "\$${widget.order!.totalPrice['totalAmount'].toString()}",
                        textSize: 16,
                        textWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
