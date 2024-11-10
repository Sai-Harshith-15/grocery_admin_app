import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../controllers/all_orders_controller.dart';
import '../../../../../data/models/order_model.dart';
import '../../../../../data/models/product_model.dart';
import '../../../../widgets/mytext.dart';

class OrderItemsCard extends StatefulWidget {
  final OrderModel? order;

  const OrderItemsCard({super.key, this.order});

  @override
  State<OrderItemsCard> createState() => _OrderItemsCardState();
}

class _OrderItemsCardState extends State<OrderItemsCard> {
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
            const HeadText(
              textSize: 16,
              textWeight: FontWeight.w700,
              text: "Items",
            ),
            const SizedBox(
              height: 30,
            ),

            //products

            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.order!.items.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> orderItem =
                        widget.order!.items[index];
                    // Access properties from each order item

                    final double price = orderItem['price']?.toDouble() ?? 0.0;
                    final String productId =
                        orderItem['productId'] ?? 'Unknown ID';
                    final int quantity = orderItem['quantity'] ?? 1;
                    return FutureBuilder<ProductModel?>(
                        future: allOrdersController.getProductById(productId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Card(
                                elevation: 5,
                                color: AppColors.background,
                                child: ListTile(
                                  leading: const Icon(Icons.error,
                                      color: Colors.red),
                                  title: const HeadText(
                                    text: "Product not found",
                                    textSize: 16,
                                  ),
                                  subtitle:
                                      HeadText(text: "Product ID: $productId"),
                                ),
                              ),
                            );
                          } else {
                            final product = snapshot.data;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              child: Column(
                                children: [
                                  //products
                                  Card(
                                    elevation: 5,
                                    color: AppColors.background,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //list of product items
                                          Row(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: CachedNetworkImage(
                                                    height: 50,
                                                    width: 50,
                                                    imageUrl: product!.coverImg,
                                                    placeholder:
                                                        (context, url) =>
                                                            Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              HeadText(
                                                text: product.productName,
                                                textSize: 16,
                                                textWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              HeadText(
                                                text:
                                                    "Price: \$${product.productPrice.toString()}",
                                                textSize: 14,
                                                textWeight: FontWeight.w500,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              HeadText(
                                                text:
                                                    "Qty: ${quantity.toString()}",
                                                textSize: 14,
                                                textWeight: FontWeight.w500,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              //sale price
                                              HeadText(
                                                text:
                                                    "total Price: \$${price.toString()}",
                                                textSize: 14,
                                                textWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            );
                          }
                        });
                  }),
            ),
            //total amount
            const SizedBox(
              height: 20,
            ),
            Card(
              color: Colors.grey[200],
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: [
                    //sub total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text: "SubTotal",
                        ),
                        HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text:
                              "\$${widget.order!.totalPrice['cartAmount'].toString()}" ??
                                  "\$0.00",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //Discount
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text: "Discount",
                        ),
                        HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text: "\$0.00",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //Shipping
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text: "ShippingCost",
                        ),
                        HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text:
                              "\$${widget.order!.totalPrice['deliveryHanding'].toString()}" ??
                                  "\$0.00",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text: "expressDelivery",
                        ),
                        HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text:
                              "\$${widget.order!.totalPrice['expressDelivery'].toString()}" ??
                                  "\$0.00",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //Tax
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text: "tax",
                        ),
                        HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text:
                              "\$${widget.order!.totalPrice['taxes'].toString()}" ??
                                  "\$0.00",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text: "Tip Amount",
                        ),
                        HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text:
                              "\$${widget.order!.totalPrice['tipAmount'].toString()}" ??
                                  "\$0.00",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //underline
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text: "Total",
                        ),
                        HeadText(
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          text:
                              "\$${widget.order!.totalPrice['totalAmount'].toString()}" ??
                                  "\$0.00",
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
