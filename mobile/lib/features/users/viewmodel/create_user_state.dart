import 'package:equatable/equatable.dart';

enum CreateUserStatus { initial, loading, success, failed }

class CreateUserState extends Equatable {
  final CreateUserStatus status;
  final String? errorMessage;

  const CreateUserState({
    this.status = CreateUserStatus.initial,
    this.errorMessage,
  });

  CreateUserState copyWith({CreateUserStatus? status, String? errorMessage}) {
    return CreateUserState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
