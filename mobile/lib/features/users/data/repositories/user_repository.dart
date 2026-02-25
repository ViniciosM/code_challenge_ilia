import 'dart:developer';

import 'package:ilia_users/core/network/dio_client.dart';
import 'package:ilia_users/features/users/data/models/user_model.dart';

abstract interface class IUserRepository {
  Future<List<UserModel>?> getUsers();
  Future<void> saveUser({required UserModel user});
}

class UserRepository implements IUserRepository {
  final DioClient dioClient;

  UserRepository(this.dioClient);

  @override
  Future<List<UserModel>?> getUsers() async {
    try {
      final response = await dioClient.get('/users');

      final data = response.data as List?;

      return data?.map((json) => UserModel.fromJson(json)).toList();
    } catch (e, s) {
      log('[REPO - GetUsers] Error: $e | Stacktrace $s');
      return [];
    }
  }

  @override
  Future<void> saveUser({required UserModel user}) async {
    try {
      await dioClient.post('/users', data: user.toJson());
    } catch (e, s) {
      log('[REPO - SaveUser] Error: $e | Stacktrace $s');
    }
  }
}
