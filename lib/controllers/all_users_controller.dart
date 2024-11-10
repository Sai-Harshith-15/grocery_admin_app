// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/users_repository.dart';

class AllUsersController extends GetxController {
  final UsersRepository usersRepository;
  AllUsersController({required this.usersRepository});

  var isLoading = true.obs;
  final usersList = <UserModel>[].obs;

  final filterUsersList = <UserModel>[].obs;

  //adding for to select single user
  Rx<UserModel?> selectedUser = Rx<UserModel?>(null);
  Rx<UserRole> selectedRole = UserRole.Admin.obs;

  TextEditingController userFullName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhoneNumber = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  //search

  TextEditingController searchUsersContoller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsersFromFirebase();
    searchUsersContoller.addListener(() {
      searchUsersContoller.addListener(() {
        filterUsers(searchUsersContoller.text);
      });
    });
  }

  @override
  void onClose() {
    // Dispose the controllers when the controller is removed from memory
    userFullName.dispose();
    userEmail.dispose();
    userPhoneNumber.dispose();
    userPassword.dispose();
    super.onClose();
  }

  Future<void> fetchUsersFromFirebase() async {
    try {
      isLoading(true);

      final fetchedUsers = await usersRepository.fetchUsersFromFirebase();
      if (fetchedUsers.isNotEmpty) {
        usersList.value = fetchedUsers;
        filterUsersList.value = fetchedUsers;
      } else {
        print("No users fetched");
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterUsers(String data) {
    if (data.isEmpty) {
      filterUsersList.value = usersList;
    } else {
      filterUsersList.value = usersList
          .where((user) =>
              user.fullName.toLowerCase().contains(data.toLowerCase()))
          .toList();
    }
  }

  Future<void> fetchUserById(String userId) async {
    try {
      isLoading(true);

      UserModel? user =
          await usersRepository.fetchsingleUserFromFirebase(userId);
      if (user != null) {
        selectedUser.value = user;
        userFullName.text = user.fullName;
        userEmail.text = user.email;
        userPhoneNumber.text = user.phoneNumber;
        userPassword.text = user.password ?? '';
        selectedRole.value = user.role ?? UserRole.Admin;
      }
    } catch (e) {
      print("Error fetching user: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addUsersToFirebase({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      usersList.value = await usersRepository.addUsersToFirebase(
        userFullName.text.trim(),
        userEmail.text.trim(),
        userPhoneNumber.text.trim(),
        userPassword.text.trim(),
        selectedRole.value,
      );

      Get.snackbar('Success', 'Added user successfully');

      userFullName.clear();
      userEmail.clear();
      userPhoneNumber.clear();
      userPassword.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed while adding the user $e");
      print("Error adding user: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserFromFirebase(
    String fullName,
    String email,
    String phoneNumber,
    String password,
    UserRole role,
  ) async {
    try {
      isLoading.value = true;

      if (fullName.isEmpty ||
          email.isEmpty ||
          phoneNumber.isEmpty ||
          selectedUser.value == null) {
        // Check if selectedUser is null
        throw Exception('Fields cannot be empty');
      }

      // Pass the selected user's ID to the repository
      await usersRepository.updateUserFromFirebase(
        selectedUser.value!.userId, // Use the selected user's ID
        fullName,
        email,
        phoneNumber,
        password,
        role,
      );

      Get.snackbar('Success', 'Updated user details successfully');
    } catch (e) {
      Get.snackbar("Error", "Failed while updating the user $e");
      print("Error while updating the user: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUserFromFirebase(String userId) async {
    try {
      isLoading.value = true;

      // Call the repository to delete the user
      usersList.value = await usersRepository.deleteUserFromFirebase(userId);

      Get.snackbar('Success', 'User deleted successfully');
    } catch (e) {
      Get.snackbar("Error", "Failed to delete the user: $e");
      print("Error deleting user: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
}
