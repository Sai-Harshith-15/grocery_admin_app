import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';
import '../../../../data/models/user_model.dart';
import '../../../widgets/mytext.dart';

class SingleUserDetailsScreen extends StatefulWidget {
  final UserModel? user;
  const SingleUserDetailsScreen({super.key, this.user});

  @override
  State<SingleUserDetailsScreen> createState() =>
      _SingleUserDetailsScreenState();
}

class _SingleUserDetailsScreenState extends State<SingleUserDetailsScreen> {
  // final AllUsersController allUsersController = Get.find<AllUsersController>();
  // String? userId;

/*   @override
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
  } */

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    /* return  SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(title: 'User Details'),
        body: 
          // Show loading indicator
          if (allUsersController.isLoading.value) {
            return const Center(child: CupertinoActivityIndicator());
          }

          // Check if the user is null
          final user = allUsersController.selectedUser.value;
          if (user == null) {
            return const Center(child: HeadText(text: 'No user data found.'));
          } */

    // Display the user details
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadText(text: 'Full Name: ${widget.user!.fullName}'),
              const SizedBox(height: 10),
              HeadText(text: 'Email: ${widget.user!.email}'),
              const SizedBox(height: 10),
              HeadText(text: 'Phone: ${widget.user!.phoneNumber}'),
              const SizedBox(height: 10),
              HeadText(text: 'isActive: ${widget.user!.isActive}'),
              const SizedBox(height: 10),
              HeadText(
                  text:
                      'Role: ${widget.user!.role.toString().split('.').last}'),
              const SizedBox(height: 10),
              HeadText(
                  text:
                      'Created At: ${formatTimestamp(widget.user!.createdAt)}'),
              const SizedBox(height: 10),
              HeadText(
                  text:
                      'Updated At: ${formatTimestamp(widget.user!.updatedAt)}'),
            ],
          ),
        ),
      ),
    );
    /*   
      ),
    ); */
  }
}
