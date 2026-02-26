import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilia_users/features/users/data/repositories/user_repository.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_event.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  final IUserRepository _repository;

  CreateUserBloc(this._repository) : super(const CreateUserState()) {
    on<SubmitUser>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitUser event,
    Emitter<CreateUserState> emit,
  ) async {
    emit(state.copyWith(status: CreateUserStatus.loading, errorMessage: null));

    final result = await _repository.saveUser(user: event.user);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreateUserStatus.failed,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: CreateUserStatus.success)),
    );
  }
}
