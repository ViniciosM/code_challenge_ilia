import 'dart:developer';

import 'package:ilia_users/core/network/dio_client.dart';
import 'package:ilia_users/features/users/data/models/user_model.dart';
import 'package:ilia_users/core/network/response/app_exception.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  Future<Either<AppException, List<UserModel>>> getUsers();
  Future<Either<AppException, Unit>> saveUser({required UserModel user});
}

class UserRepository implements IUserRepository {
  final DioClient dioClient;

  UserRepository(this.dioClient);

  @override
  Future<Either<AppException, List<UserModel>>> getUsers() async {
    try {
      final response = await dioClient.get('/users');
      final data = response.data as List;

      final users = data.map((json) => UserModel.fromJson(json)).toList();

      return Right(users);
    } catch (e, s) {
      log('[REPO - GetUsers] Error: $e | Stacktrace $s');

      if (e is AppException) {
        return Left(e);
      }

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppException, Unit>> saveUser({required UserModel user}) async {
    try {
      await dioClient.post('/users', data: user.toJson());
      return const Right(unit);
    } catch (e, s) {
      log('[REPO - SaveUser] Error: $e | Stacktrace $s');
      if (e is AppException) {
        return Left(e);
      }

      return Left(ServerFailure(e.toString()));
    }
  }
}
