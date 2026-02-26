import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_users/core/network/response/app_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ilia_users/features/users/viewmodel/user_bloc.dart';
import 'package:ilia_users/features/users/viewmodel/user_event.dart';
import 'package:ilia_users/features/users/viewmodel/user_state.dart';
import 'package:ilia_users/features/users/data/models/user_model.dart';
import 'package:ilia_users/features/users/data/repositories/user_repository.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late MockUserRepository mockRepository;
  late UserBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockRepository = MockUserRepository();
    bloc = UserBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('GetUsers', () {
    blocTest<UserBloc, UserState>(
      'emits [loading, success] when repository returns Right(users)',

      build: () {
        when(() => mockRepository.getUsers()).thenAnswer(
          (_) async => Right([
            UserModel(id: 1, name: 'Vinicios', email: 'vinicios@email.com'),
          ]),
        );
        return bloc;
      },

      act: (bloc) => bloc.add(GetUsers()),

      expect: () => [
        const UserState(status: UserStatus.loading),
        UserState(
          status: UserStatus.success,
          users: [
            UserModel(id: 1, name: 'Vinicios', email: 'vinicios@email.com'),
          ],
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [loading, failed] when repository returns Left',

      build: () {
        when(
          () => mockRepository.getUsers(),
        ).thenAnswer((_) async => Left(ServerFailure('Server error')));
        return bloc;
      },

      act: (bloc) => bloc.add(GetUsers()),

      expect: () => [
        const UserState(status: UserStatus.loading),
        UserState(status: UserStatus.failed, errorMessage: 'Server error'),
      ],
    );
  });

  group('AddUser', () {
    blocTest<UserBloc, UserState>(
      'emits [loading, success] when add succeeds',

      build: () {
        when(
          () => mockRepository.saveUser(user: any(named: 'user')),
        ).thenAnswer((_) async => const Right(unit));

        when(() => mockRepository.getUsers()).thenAnswer(
          (_) async => Right([
            UserModel(id: 1, name: 'Vinicios', email: 'vinicios@email.com'),
          ]),
        );

        return bloc;
      },

      act: (bloc) => bloc.add(
        AddUser(UserModel(name: 'Vinicios', email: 'vinicios@email.com')),
      ),

      expect: () => [
        const UserState(status: UserStatus.loading),
        UserState(
          status: UserStatus.success,
          users: [
            UserModel(id: 1, name: 'Vinicios', email: 'vinicios@email.com'),
          ],
        ),
      ],
    );
  });

  blocTest<UserBloc, UserState>(
    'emits [loading, failed] when save returns Left',

    build: () {
      when(
        () => mockRepository.saveUser(user: any(named: 'user')),
      ).thenAnswer((_) async => Left(ServerFailure('Server error')));
      return bloc;
    },

    act: (bloc) => bloc.add(
      AddUser(UserModel(name: 'Vinicios', email: 'vinicios@email.com')),
    ),

    expect: () => [
      const UserState(status: UserStatus.loading),
      UserState(status: UserStatus.failed, errorMessage: 'Server error'),
    ],
  );
}
