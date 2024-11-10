import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/all_orders_controller.dart';
import '../../../../controllers/sidebar_controller.dart';
import '../../../../data/models/order_model.dart';
import '../../../../globals/globals.dart';
import '../../../../routes/routes.dart';
import '../../../widgets/mytext.dart';
import '../../../widgets/responsive.dart';
import 'orders_data/order_customer_details.dart';
import 'orders_data/order_info.dart';
import 'orders_data/order_items_card.dart';

class SingleOrderDetailsScreen extends StatefulWidget {
  final OrderModel? order;
  const SingleOrderDetailsScreen({super.key, this.order});

  @override
  State<SingleOrderDetailsScreen> createState() =>
      _SingleOrderDetailsScreenState();
}

class _SingleOrderDetailsScreenState extends State<SingleOrderDetailsScreen> {
  final AllOrdersController allOrdersController =
      Get.find<AllOrdersController>();

  final SidebarController sidebarController = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: HeadText(
                      text: "Dashboard / Order / Details",
                      textSize: 20,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            sidebarController
                                .setPageByRoute(AppRoutes.allOrdersScreen);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const SizedBox(
                        width: 5,
                      ),
                      widget.order!.orderId != null
                          ? HeadText(
                              text: '${widget.order!.orderId} Order Id',
                              textSize: 16,
                            )
                          : const HeadText(
                              text: "Loading Order Details...",
                              textSize: 16,
                            ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () async {
                          await allOrdersController
                              .copiedDetails(widget.order!.orderId);
                        },
                        icon: Icon(
                          Icons.copy,
                          color: allOrdersController.isCopied.value
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                //firast col
                SizedBox(
                  width: Responsive.isDesktop(context) ||
                          Responsive.isDesktopLarge(context)
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width * 1,
                  child: Column(
                    children: [
                      //order info

                      OrderInformationCard(
                        order: widget.order,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      //items

                      OrderItemsCard(
                        order: widget.order,
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      //transaction
                      Card(
                        elevation: 5,
                        color: AppColors.background,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HeadText(
                                textSize: 16,
                                textWeight: FontWeight.w700,
                                text: "Transactions",
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                            height: 60,
                                            width: 60,
                                            imageUrl:
                                                "https://images.ctfassets.net/kftzwdyauwt9/6c20363e-30c0-486d-2e9bfa611583/b15f2e43a5a525763c966ab4562a31b2/stripe.jpg?w=3840&q=90&fm=webp"),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const HeadText(
                                            text: "Payment via Stripe",
                                            textWeight: FontWeight.bold,
                                            textSize: 16,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          HeadText(
                                            text:
                                                "\$${allOrdersController.stripeFee.value.toString()}",
                                            textWeight: FontWeight.w500,
                                            textColor: Colors.grey,
                                            textSize: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const HeadText(
                                        text: "Date",
                                        textColor: Colors.grey,
                                        textSize: 16,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      HeadText(
                                        text: Globals.formatTimestamp(
                                            widget.order!.createdAt),
                                        textWeight: FontWeight.bold,
                                        textSize: 16,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const HeadText(
                                        text: "Total",
                                        textColor: Colors.grey,
                                        textSize: 16,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      HeadText(
                                        text:
                                            "\$${(widget.order!.totalPrice['totalAmount'] + allOrdersController.stripeFee.value).toString()}",
                                        textWeight: FontWeight.bold,
                                        textSize: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //2nd column
                SizedBox(
                  width: Responsive.isDesktop(context) ||
                          Responsive.isDesktopLarge(context)
                      ? MediaQuery.of(context).size.width * 0.3
                      : MediaQuery.of(context).size.width * 1,
                  child: Column(
                    children: [
                      //customer

                      OrderCustomerDetailsCard(order: widget.order),

                      const SizedBox(
                        height: 20,
                      ),
                      //shipping address
                      Card(
                        elevation: 5,
                        color: AppColors.background,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const HeadText(
                                  textSize: 16,
                                  textWeight: FontWeight.w700,
                                  text: "Delivery Address",
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                //

                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .4,
                                  child: FutureBuilder(
                                    future: allOrdersController.getAddressById(
                                        widget.order!.addressId,
                                        widget.order!.userId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CupertinoActivityIndicator(),
                                        );
                                      } else if (snapshot.hasError ||
                                          snapshot.data == null) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: Card(
                                            elevation: 5,
                                            color: AppColors.background,
                                            child: Column(
                                              children: [
                                                const Icon(Icons.error,
                                                    color: Colors.red),
                                                const HeadText(
                                                  text: "address not found",
                                                  textSize: 16,
                                                ),
                                                HeadText(
                                                    text:
                                                        "adddress ID: ${widget.order!.addressId}"),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        final address = snapshot.data!;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            HeadText(
                                              text: "User ID: ${address.id}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text:
                                                  "Contact: ${address.contactNo.toString()}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text:
                                                  "Country: ${address.country}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text: "State: ${address.state}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text: "City: ${address.city}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text:
                                                  "District: ${address.district}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text: "street: ${address.street}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text:
                                                  "Zipcode: ${address.zipCode}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text: "PlatNo: ${address.platNo}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text:
                                                  "Landmark: ${address.landmark}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            HeadText(
                                              text:
                                                  "Location: ${address.location}",
                                              textSize: 14,
                                              textColor: Colors.grey,
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      //billing address
                      Card(
                        elevation: 5,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
