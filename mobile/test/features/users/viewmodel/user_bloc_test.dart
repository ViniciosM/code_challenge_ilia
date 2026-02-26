import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_users/core/network/response/app_exception.dart';
import 'package:ilia_users/features/users/viewmodel/user_event.dart';
import 'package:ilia_users/features/users/viewmodel/user_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ilia_users/features/users/data/models/user_model.dart';
import 'package:ilia_users/features/users/data/repositories/user_repository.dart';
import 'package:ilia_users/features/users/viewmodel/user_bloc.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository repository;

  setUpAll(() {
    registerFallbackValue(UserModel(name: '', email: ''));
  });

  setUp(() {
    repository = MockUserRepository();
  });

  group('UserBloc Tests', () {
    final tUsers = [UserModel(name: 'John Doe', email: 'john@ilia.com')];

    blocTest<UserBloc, UserState>(
      'should emit [loading, success] when users are fetched successfully',
      build: () {
        // Arrange
        when(
          () => repository.getUsers(),
        ).thenAnswer((_) async => Right(tUsers));
        return UserBloc(repository);
      },
      // Act
      act: (bloc) => bloc.add(GetUsers()),
      // Assert
      expect: () => [
        const UserState(status: UserStatus.loading),
        UserState(status: UserStatus.success, users: tUsers),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should emit [loading, failed] when fetching users fails',
      build: () {
        // Arrange
        when(
          () => repository.getUsers(),
        ).thenAnswer((_) async => Left(ServerFailure('Error')));
        return UserBloc(repository);
      },
      // Act
      act: (bloc) => bloc.add(GetUsers()),
      // Assert
      expect: () => [
        const UserState(status: UserStatus.loading),
        const UserState(status: UserStatus.failed, errorMessage: 'Error'),
      ],
    );
  });
}
