import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/all_users_controller.dart';
import '../../../../data/models/user_model.dart';
import '../../../../routes/routes.dart';
import '../../../widgets/my_app_bar.dart';
import '../../../widgets/mytext.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/textfield.dart';

class EditUserDetailsScreen extends StatefulWidget {
  final UserModel? user;
  const EditUserDetailsScreen({super.key, this.user});

  @override
  State<EditUserDetailsScreen> createState() => _EditUserDetailsScreenState();
}

class _EditUserDetailsScreenState extends State<EditUserDetailsScreen> {
  final AllUsersController allUsersController = Get.find<AllUsersController>();

  @override
  void initState() {
    super.initState();

    // Initialize controller with passed user data
    if (widget.user != null) {
      allUsersController.fetchUserById(widget.user!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Display loading indicator when fetching or updating
      if (allUsersController.isLoading.value) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: MyAppBar(title: 'User Details'),
          body: const Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      }

      final user = allUsersController.selectedUser.value;
      if (user == null) {
        return Scaffold(
          appBar: MyAppBar(title: 'User Details'),
          body: const Center(
            child: HeadText(text: 'No user data found.'),
          ),
        );
      }
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: MyAppBar(
          title: 'Edit ${widget.user!.fullName} Details',
        ),
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.isDesktop(context) ||
                        Responsive.isDesktopLarge(context)
                    ? MediaQuery.of(context).size.width * .4
                    : Responsive.isTablet(context)
                        ? MediaQuery.of(context).size.width * .7
                        : Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width * 1
                            : MediaQuery.of(context).size.width * .9,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: allUsersController.userFullName,
                      hintText: 'Full Name',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: allUsersController.userEmail,
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: allUsersController.userPhoneNumber,
                      hintText: 'Phone Number',
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<UserRole>(
                      dropdownColor: AppColors.background,
                      value: allUsersController.selectedRole.value,
                      onChanged: (UserRole? newRole) {
                        if (newRole != null) {
                          allUsersController.selectedRole(newRole);
                        }
                      },
                      items: UserRole.values.map((UserRole role) {
                        return DropdownMenuItem<UserRole>(
                          value: role,
                          child:
                              HeadText(text: role.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: allUsersController.userPassword,
                      hintText: 'Password',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (allUsersController.userFullName.text.isEmpty ||
                            allUsersController.userEmail.text.isEmpty ||
                            allUsersController.userPhoneNumber.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please fill in all required fields.',
                          );
                          return;
                        }

                        // Update the user using the controller function
                        await allUsersController.updateUserFromFirebase(
                          allUsersController.userFullName.text.trim(),
                          allUsersController.userEmail.text.trim(),
                          allUsersController.userPhoneNumber.text.trim(),
                          allUsersController.userPassword.text.trim(),
                          allUsersController.selectedRole.value,
                        );

                        // Navigate back or to AllUsersScreen after successful update
                        Get.toNamed(AppRoutes.allUsersScreen);
                      },
                      child: const HeadText(text: 'Update user'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
