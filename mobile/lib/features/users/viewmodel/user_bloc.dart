import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilia_users/features/users/data/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository _repository;

  UserBloc(this._repository) : super(const UserState()) {
    on<GetUsers>(_onGetUsers);
    on<AddUser>(_onAddUser);
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
        emit(state.copyWith(status: UserStatus.success, users: users));
      },
    );
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));

    final saveResult = await _repository.saveUser(user: event.user);

    if (saveResult.isLeft()) {
      final failure = saveResult.fold(
        (failure) => failure,
        (_) => throw Exception(),
      );

      emit(
        state.copyWith(
          status: UserStatus.failed,
          errorMessage: failure.message,
        ),
      );
      return;
    }

    final getResult = await _repository.getUsers();

    getResult.fold(
      (failure) => emit(
        state.copyWith(
          status: UserStatus.failed,
          errorMessage: failure.message,
        ),
      ),
      (users) => emit(state.copyWith(status: UserStatus.success, users: users)),
    );
  }
}
