import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ilia_users/core/network/dio_client.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DioClient dioClient;

  setUp(() {
    mockDio = MockDio();

    when(() => mockDio.interceptors).thenReturn(Interceptors());

    dioClient = DioClient(dio: mockDio);
  });

  group('DioClient - GET', () {
    test('should return response when request succeeds', () async {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(path: '/users'),
        data: [
          {'id': 1, 'name': 'Vinicios', 'email': 'vinicios@email.com'},
        ],
        statusCode: 200,
      );

      when(() => mockDio.get('/users')).thenAnswer((_) async => response);

      // Act
      final result = await dioClient.get('/users');

      // Assert
      expect(result, equals(response));
      verify(() => mockDio.get('/users')).called(1);
    });
  });

  test('should throw formatted exception when DioException occurs', () async {
    // Arrange
    final dioException = DioException(
      requestOptions: RequestOptions(path: '/users'),
      error: 'Server error',
    );

    when(() => mockDio.get('/users')).thenThrow(dioException);

    // Act
    final call = dioClient.get('/users');

    // Assert
    await expectLater(call, throwsA(isA<Exception>()));

    verify(() => mockDio.get('/users')).called(1);
  });
}
