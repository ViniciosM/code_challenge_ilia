import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:ilia_users/features/users/data/repositories/user_repository.dart';
import 'package:ilia_users/features/users/data/models/user_model.dart';
import 'package:ilia_users/core/network/dio_client.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MockDioClient mockDioClient;
  late UserRepository repository;

  setUp(() {
    mockDioClient = MockDioClient();
    repository = UserRepository(mockDioClient);
  });

  test('should return Right(List<UserModel>) when request succeeds', () async {
    // Arrange
    final response = Response(
      requestOptions: RequestOptions(path: '/users'),
      data: [
        {'id': 1, 'name': 'Vinicios', 'email': 'vinicios@email.com'},
      ],
      statusCode: 200,
    );

    when(() => mockDioClient.get('/users')).thenAnswer((_) async => response);

    // Act
    final result = await repository.getUsers();

    // Assert
    expect(result.isRight(), true);

    result.fold((_) => fail('Expected Right but got Left'), (users) {
      expect(users.length, 1);
      expect(users.first.name, 'Vinicios');
    });

    verify(() => mockDioClient.get('/users')).called(1);
  });

  test('should return Left(Failure) when Dio throws', () async {
    // Arrange
    when(
      () => mockDioClient.get('/users'),
    ).thenThrow(Exception('Server error'));

    // Act
    final result = await repository.getUsers();

    // Assert
    expect(result.isLeft(), true);

    result.fold((failure) {
      expect(failure.message, contains('Server error'));
    }, (_) => fail('Expected Left but got Right'));
  });

  test('should return Right(Unit) when save succeeds', () async {
    // Arrange
    final user = UserModel(name: 'Vinicios', email: 'vinicios@email.com');

    when(() => mockDioClient.post('/users', data: user.toJson())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/users'),
        statusCode: 201,
      ),
    );

    // Act
    final result = await repository.saveUser(user: user);

    // Assert
    expect(result.isRight(), true);
  });

  test('should return Left(Failure) when save fails', () async {
    // Arrange
    final user = UserModel(name: 'Vinicios', email: 'vinicios@email.com');

    when(
      () => mockDioClient.post('/users', data: user.toJson()),
    ).thenThrow(Exception('Server error'));

    // Act
    final result = await repository.saveUser(user: user);

    // Assert
    expect(result.isLeft(), true);
  });
}
