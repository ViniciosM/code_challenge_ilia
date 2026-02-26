import 'package:equatable/equatable.dart';
import 'package:ilia_users/features/users/data/models/user_model.dart';

abstract class CreateUserEvent extends Equatable {
  const CreateUserEvent();

  @override
  List<Object?> get props => [];
}

class SubmitUser extends CreateUserEvent {
  final UserModel user;

  const SubmitUser(this.user);

  @override
  List<Object?> get props => [user];
}
