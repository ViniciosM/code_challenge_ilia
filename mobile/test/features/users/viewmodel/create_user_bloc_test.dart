import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_users/core/network/response/app_exception.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_bloc.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_event.dart';
import 'package:ilia_users/features/users/viewmodel/create_user_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ilia_users/features/users/data/models/user_model.dart';
import 'package:ilia_users/features/users/data/repositories/user_repository.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository repository;

  setUpAll(() {
    registerFallbackValue(UserModel(name: '', email: ''));
  });

  setUp(() {
    repository = MockUserRepository();
  });

  group('CreateUserBloc Tests', () {
    final tUser = UserModel(name: 'Ilia User', email: 'user@ilia.com');

    blocTest<CreateUserBloc, CreateUserState>(
      'should emit [loading, success] when user is saved successfully',
      build: () {
        // Arrange
        when(
          () => repository.saveUser(user: any(named: 'user')),
        ).thenAnswer((_) async => const Right(unit));
        return CreateUserBloc(repository);
      },
      // Act
      act: (bloc) => bloc.add(SubmitUser(tUser)),
      // Assert
      expect: () => [
        const CreateUserState(status: CreateUserStatus.loading),
        const CreateUserState(status: CreateUserStatus.success),
      ],
    );

    blocTest<CreateUserBloc, CreateUserState>(
      'should emit [loading, failed] with specific message when email already exists',
      build: () {
        // Arrange
        when(
          () => repository.saveUser(user: any(named: 'user')),
        ).thenAnswer((_) async => Left(EmailAlreadyExistsFailure()));
        return CreateUserBloc(repository);
      },
      // Act
      act: (bloc) => bloc.add(SubmitUser(tUser)),
      // Assert
      expect: () => [
        const CreateUserState(status: CreateUserStatus.loading),
        const CreateUserState(
          status: CreateUserStatus.failed,
          errorMessage: 'Esse email já está cadastrado.',
        ),
      ],
    );
  });
}
