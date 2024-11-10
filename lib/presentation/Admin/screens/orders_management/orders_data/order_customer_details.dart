import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../controllers/all_orders_controller.dart';
import '../../../../../data/models/order_model.dart';
import '../../../../../data/models/user_model.dart';
import '../../../../../globals/globals.dart';
import '../../../../widgets/mytext.dart';
import '../../../../widgets/responsive.dart';

class OrderCustomerDetailsCard extends StatefulWidget {
  final OrderModel? order;

  const OrderCustomerDetailsCard({super.key, this.order});

  @override
  State<OrderCustomerDetailsCard> createState() =>
      _OrderCustomerDetailsCardState();
}

class _OrderCustomerDetailsCardState extends State<OrderCustomerDetailsCard> {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeadText(
              textSize: 16,
              textWeight: FontWeight.w700,
              text: "Customer",
            ),
            const SizedBox(
              height: 30,
            ),
            //user details
            SizedBox(
              height: MediaQuery.of(context).size.height * .45,
              child: FutureBuilder<UserModel?>(
                  future: allOrdersController.getUserById(widget.order!.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Card(
                          elevation: 5,
                          color: AppColors.background,
                          child: Column(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const HeadText(
                                text: "user not found",
                                textSize: 16,
                              ),
                              HeadText(
                                  text: "user ID: ${widget.order!.userId}"),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final user = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: Responsive.isDesktop(context) ||
                                    Responsive.isDesktopLarge(context)
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  height: 100,
                                  width: 100,
                                  imageUrl: user.userImg,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CachedNetworkImage(
                                    height: 100,
                                    width: 100,
                                    imageUrl:
                                        "https://e7.pngegg.com/pngimages/348/800/png-clipart-man-wearing-blue-shirt-illustration-computer-icons-avatar-user-login-avatar-blue-child.png",
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),

                                  /* const Icon(Icons.error), */
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HeadText(
                                    text: user.fullName,
                                    textWeight: FontWeight.bold,
                                    textSize: 16,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  HeadText(
                                    text: user.email,
                                    textWeight: FontWeight.w500,
                                    textSize: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //all user details
                          const HeadText(
                            text: "All Details",
                            textWeight: FontWeight.bold,
                            textSize: 16,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //user id
                          HeadText(
                            text: "User ID: ${user.userId}",
                            textSize: 14,
                            textColor: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //name
                          HeadText(
                            text: "Name: ${user.fullName}",
                            textSize: 14,
                            textColor: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //email
                          HeadText(
                            text: "Email: ${user.email}",
                            textSize: 14,
                            textColor: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //conatct
                          HeadText(
                            text: user.phoneNumber == ""
                                ? "Contact: Not Given"
                                : "Contact: ${user.phoneNumber}",
                            textSize: 14,
                            textColor: Colors.grey,
                          ),

                          //isActive
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HeadText(
                                text:
                                    'Active User : ${user.isActive.toString()}',
                                textSize: 14,
                                textColor: Colors.grey,
                              ),
                              Obx(
                                () => Switch(
                                  value:
                                      allOrdersController.toggleIsActive.value,
                                  onChanged: (value) {
                                    allOrdersController.toggleIsActiveUser(
                                      value,
                                      user.userId,
                                    );
                                  },
                                  activeColor: AppColors.TertiaryGreen,
                                ),
                              ),
                            ],
                          ),
                          //user created at
                          HeadText(
                            text:
                                "Created on: ${Globals.formatTimestamp(user.createdAt)}",
                            textSize: 14,
                            textColor: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
