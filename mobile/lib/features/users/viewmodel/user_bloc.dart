import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilia_users/features/users/data/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository _repository;

  UserBloc(this._repository) : super(const UserState()) {
    on<GetUsers>(_onGetUsers);
  }

  Future<void> _onGetUsers(GetUsers event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));

    final result = await _repository.getUsers();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: UserStatus.failed,
            errorMessage: failure.message,
          ),
        );
      },
      (users) {
        emit(
          state.copyWith(
            status: UserStatus.success,
            users: users,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
