import '../interfaces/users_interfaces.dart';
import '../models/user_model.dart';

class UsersRepository {
  final Interfaces interfaces;

  UsersRepository({required this.interfaces});
  Future<List<UserModel>> fetchUsersFromFirebase() async {
    return await interfaces.fetchUsersFromFirebase();
  }

  Future<UserModel?> fetchsingleUserFromFirebase(String userId) async {
    return await interfaces.fetchsingleUserFromFirebase(userId);
  }

  Future<List<UserModel>> addUsersToFirebase(
    String fullName,
    String email,
    String phoneNumber,
    String password,
    UserRole role,
  ) async {
    return await interfaces.addUsersToFirebase(
      fullName,
      email,
      phoneNumber,
      password,
      role,
    );
  }

  Future<List<UserModel>> updateUserFromFirebase(
    String userId,
    String fullName,
    String email,
    String phoneNumber,
    String password,
    UserRole role,
  ) async {
    return await interfaces.updateUserFromFirebase(
      userId,
      fullName,
      email,
      phoneNumber,
      password,
      role,
    );
  }

  Future<List<UserModel>> deleteUserFromFirebase(String userId) async {
    return await interfaces.deleteUserFromFirebase(userId);
  }
}
