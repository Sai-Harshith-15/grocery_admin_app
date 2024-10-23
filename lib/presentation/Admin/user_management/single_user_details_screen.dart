// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/all_users_controller.dart';
import '../../../../data/models/user_model.dart';
import '../../../constants/app_colors.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/mytext.dart';

class SingleUserDetailsScreen extends StatefulWidget {
  @override
  State<SingleUserDetailsScreen> createState() =>
      _SingleUserDetailsScreenState();
}

class _SingleUserDetailsScreenState extends State<SingleUserDetailsScreen> {
  final AllUsersController allUsersController = Get.find<AllUsersController>();
  String? userId;

  @override
  void initState() {
    super.initState();
    // Get userId from arguments
    userId = (Get.arguments as UserModel?)?.userId;

    // Fetch the user by userId safely within initState
    if (userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        allUsersController.fetchUserById(userId!);
      });
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(title: 'User Details'),
        body: Obx(() {
          // Show loading indicator
          if (allUsersController.isLoading.value) {
            return const Center(child: CupertinoActivityIndicator());
          }

          // Check if the user is null
          final user = allUsersController.selectedUser.value;
          if (user == null) {
            return const Center(child: HeadText(text: 'No user data found.'));
          }

          // Display the user details
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadText(text: 'Full Name: ${user.fullName}'),
                    const SizedBox(height: 10),
                    HeadText(text: 'Email: ${user.email}'),
                    const SizedBox(height: 10),
                    HeadText(text: 'Phone: ${user.phoneNumber}'),
                    const SizedBox(height: 10),
                    HeadText(text: 'isActive: ${user.isActive}'),
                    const SizedBox(height: 10),
                    HeadText(
                        text: 'Role: ${user.role.toString().split('.').last}'),
                    const SizedBox(height: 10),
                    HeadText(
                        text: 'Created At: ${formatTimestamp(user.createdAt)}'),
                    const SizedBox(height: 10),
                    HeadText(
                        text: 'Updated At: ${formatTimestamp(user.updatedAt)}'),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
