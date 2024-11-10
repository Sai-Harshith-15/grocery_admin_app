import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/all_orders_controller.dart';
import '../../../../controllers/sidebar_controller.dart';
import '../../../../globals/globals.dart';
import '../../../../routes/routes.dart';
import '../../../widgets/mytext.dart';
import '../../../widgets/rounded_textfield.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  final AllOrdersController allOrdersController =
      Get.find<AllOrdersController>();
  final SidebarController sidebarController = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (allOrdersController.isLoading.value) {
        return const Center(child: CupertinoActivityIndicator());
      } else if (allOrdersController.ordersList == null) {
        return const Center(
          child: HeadText(text: 'No orders found'),
        );
      }
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                //Orders
                const Align(
                  alignment: Alignment.topLeft,
                  child: HeadText(
                    text: 'Dashboard / Orders',
                    textSize: 20,
                    textWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // orders data
                Card(
                  elevation: 5,
                  color: AppColors.background,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: RoundedTextField(
                                controller:
                                    allOrdersController.searchController,
                                hintText: "Search order id's here...",
                                prefixIcon: Icons.search,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        //order details

                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: HeadText(
                                  text: "Order ID",
                                  textSize: 16,
                                  textWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    HeadText(
                                      text: "Date",
                                      textSize: 16,
                                      textWeight: FontWeight.w500,
                                    ),
                                    Icon(
                                      Icons.arrow_downward,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: HeadText(
                                  text: "Items",
                                  textSize: 16,
                                  textWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: HeadText(
                                  text: "Status",
                                  textSize: 16,
                                  textWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: HeadText(
                                  text: "Amount",
                                  textSize: 16,
                                  textWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: HeadText(
                                  text: "Action",
                                  textSize: 16,
                                  textWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        //listview builder

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .9,
                          width: MediaQuery.of(context).size.width,
                          child: allOrdersController.isLoading.value
                              ? Center(
                                  child: CupertinoActivityIndicator(
                                    color: AppColors.primaryGreen,
                                  ),
                                )
                              : allOrdersController.filterOrderList == null
                                  ? const Center(
                                      child: HeadText(text: "No Orders Found"),
                                    )
                                  : ListView.builder(
                                      itemCount: allOrdersController
                                          .filterOrderList.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final order = allOrdersController
                                            .filterOrderList[index];

                                        final int totalAmount =
                                            order.totalPrice['totalAmount'] ??
                                                0;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: HeadText(
                                                  text: order.orderId,
                                                  textSize: 16,
                                                  textWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: HeadText(
                                                  text: Globals.formatTimestamp(
                                                      order.createdAt),
                                                  textSize: 16,
                                                  textWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: HeadText(
                                                  text: order.items.length
                                                      .toString(),
                                                  textSize: 16,
                                                  textWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: HeadText(
                                                  text: order.orderStatus
                                                      .toString()
                                                      .split('.')
                                                      .last,
                                                  textSize: 16,
                                                  textWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: HeadText(
                                                  text:
                                                      "\$${totalAmount.toString()}",
                                                  textSize: 16,
                                                  textWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Tooltip(
                                                        message: 'view details',
                                                        child: IconButton(
                                                          onPressed: () {
                                                            sidebarController
                                                                .setPageByRoute(
                                                                    AppRoutes
                                                                        .singleOrderDetailsScreen,
                                                                    arguments:
                                                                        order);
                                                          },
                                                          icon: const Icon(
                                                            Icons.visibility,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                      Tooltip(
                                                        message:
                                                            'Delete ${order.orderId}',
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            await allOrdersController
                                                                .deleteOrderFromFirebase(
                                                                    order
                                                                        .orderId,
                                                                    order
                                                                        .userId);
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .delete_outline_rounded,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
