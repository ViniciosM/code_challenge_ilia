import 'package:ilia_users/features/users/data/models/user_model.dart';

abstract interface class IUserRepository {
  Future<List<UserModel>?> getUsers();
  Future<void> saveUser({required UserModel user});
}

class UserRepository implements IUserRepository {
  @override
  Future<List<UserModel>?> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser({required UserModel user}) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }
}
