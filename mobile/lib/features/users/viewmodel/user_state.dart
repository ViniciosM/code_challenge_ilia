import 'package:equatable/equatable.dart';
import '../data/models/user_model.dart';

enum UserStatus { initial, loading, success, failed }

class UserState extends Equatable {
  final UserStatus status;
  final List<UserModel> users;
  final String? errorMessage;

  const UserState({
    this.status = UserStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  UserState copyWith({
    UserStatus? status,
    List<UserModel>? users,
    String? errorMessage,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage];
}
