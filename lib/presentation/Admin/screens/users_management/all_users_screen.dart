import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/all_users_controller.dart';
import '../../../../controllers/sidebar_controller.dart';
import '../../../../routes/routes.dart';
import '../../../widgets/my_app_bar.dart';
import '../../../widgets/mytext.dart';
import '../../../widgets/responsive.dart';
import '../../../widgets/textfield.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});
  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final AllUsersController allUsersController = Get.find<AllUsersController>();
  final SidebarController sidebarController = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // drawer: const MyDrawer(),
      backgroundColor: AppColors.background,
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        title: 'All Users Screen',
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ||
                    Responsive.isDesktopLarge(context)
                ? MediaQuery.of(context).size.width * .5
                : Responsive.isTablet(context)
                    ? MediaQuery.of(context).size.width * .8
                    : Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 1
                        : MediaQuery.of(context).size.width * .9,
          ),
          child: Obx(() {
            if (allUsersController.isLoading.value) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (allUsersController.usersList.isEmpty) {
              return const Center(
                child: HeadText(text: 'No users found'),
              );
            }

            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: allUsersController.searchUsersContoller,
                  hintText: "Search users here...",
                  labelText: HeadText(
                    text: "Search here",
                    textSize: Responsive.isDesktop(context) ||
                            Responsive.isDesktopLarge(context)
                        ? 14
                        : 16,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.primaryBlack, width: 1),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.primaryBlack, width: 1),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: allUsersController.filterUsersList.isEmpty
                      ? const Center(
                          child: HeadText(
                              text: "No User Available with This Name"),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: allUsersController.filterUsersList.length,
                          itemBuilder: (context, index) {
                            final user =
                                allUsersController.filterUsersList[index];
                            return Dismissible(
                              movementDuration: const Duration(seconds: 2),
                              key: Key(user.userId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) async {
                                await allUsersController
                                    .deleteUserFromFirebase(user.userId);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: Card(
                                  color: AppColors.background,
                                  elevation: 5,
                                  child: ListTile(
                                    onTap: () async {
                                      // allUsersController.selectUser(user);
                                      // await allUsersController.fetchUserById(user.userId);
                                      /* Get.toNamed(AppRoutes.singleUserDetailsScreen,
                                    arguments: user); */

                                      sidebarController.setPageByRoute(
                                        AppRoutes.singleUserDetailsScreen,
                                        arguments: user,
                                      );
                                    },
                                    title: HeadText(
                                      text: user.fullName,
                                      textSize: Responsive.isDesktop(context) ||
                                              Responsive.isDesktopLarge(context)
                                          ? 16
                                          : 14,
                                    ),
                                    subtitle: HeadText(
                                      text: user.email,
                                      textSize: Responsive.isDesktop(context) ||
                                              Responsive.isDesktopLarge(context)
                                          ? 16
                                          : 14,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: AppColors.secondaryGreen,
                                      child: HeadText(
                                        text: user.fullName.isNotEmpty
                                            ? user.fullName[0].toUpperCase()
                                            : '',
                                        textSize:
                                            Responsive.isDesktop(context) ||
                                                    Responsive.isDesktopLarge(
                                                        context)
                                                ? 16
                                                : 14,
                                        textColor: AppColors.background,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        HeadText(
                                          text: user.role
                                              .toString()
                                              .split('.')
                                              .last,
                                          textColor: AppColors.primaryBlack,
                                          textSize:
                                              Responsive.isDesktop(context) ||
                                                      Responsive.isDesktopLarge(
                                                          context)
                                                  ? 16
                                                  : 14,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            /*   Get.toNamed(
                                        AppRoutes.editUserDetailsScreen,
                                        arguments: user,
                                      ); */
                                            sidebarController.setPageByRoute(
                                              AppRoutes.editUserDetailsScreen,
                                              arguments: user,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: AppColors.primaryBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    ));
  }
}
