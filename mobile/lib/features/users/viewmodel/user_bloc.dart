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

    try {
      final users = await _repository.getUsers();
      emit(state.copyWith(status: UserStatus.success, users: users));
    } catch (e, s) {
      log('[BLOC - OnGetUsers] Error: $e | Stacktrace $s');
      emit(
        state.copyWith(status: UserStatus.failed, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      await _repository.saveUser(user: event.user);

      final updatedUsers = await _repository.getUsers();

      emit(state.copyWith(status: UserStatus.success, users: updatedUsers));
    } catch (e, s) {
      log('[BLOC - OnAddUsers] Error: $e | Stacktrace $s');
      emit(
        state.copyWith(status: UserStatus.failed, errorMessage: e.toString()),
      );
    }
  }
}
