import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_users/core/network/response/app_exception.dart';
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

  group('DioClient - Exceptions', () {
    test(
      'should throw ServerFailure when a generic DioException occurs',
      () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users'),
          type: DioExceptionType.connectionTimeout,
        );

        when(() => mockDio.get(any())).thenThrow(dioException);

        // Act
        final call = dioClient.get('/users');

        // Assert
        // Usamos isA<AppException> ou isA<ServerFailure> porque elas não herdam de Exception
        await expectLater(call, throwsA(isA<ServerFailure>()));

        verify(() => mockDio.get('/users')).called(1);
      },
    );

    test(
      'should throw EmailAlreadyExistsFailure when status code is 409',
      () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users'),
          response: Response(
            requestOptions: RequestOptions(path: '/users'),
            statusCode: 409,
          ),
        );

        when(
          () => mockDio.post(any(), data: any(named: 'data')),
        ).thenThrow(dioException);

        // Act
        final call = dioClient.post('/users', data: {});

        // Assert
        await expectLater(call, throwsA(isA<EmailAlreadyExistsFailure>()));

        verify(
          () => mockDio.post('/users', data: any(named: 'data')),
        ).called(1);
      },
    );
  });
}
