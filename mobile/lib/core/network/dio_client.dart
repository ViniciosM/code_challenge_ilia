import 'dart:developer';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:ilia_users/core/network/response/app_exception.dart';

String get baseUrl {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:3000';
  }
  return 'http://localhost:3000';
}

class DioClient {
  late final Dio _dio;

  DioClient({Dio? dio}) {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
            sendTimeout: const Duration(seconds: 5),
            headers: {'Content-Type': 'application/json'},
          ),
        );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          log('ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path) async {
    return _execute(() => _dio.get(path));
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _execute(() => _dio.post(path, data: data));
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _execute(() => _dio.put(path, data: data));
  }

  Future<Response> delete(String path) async {
    return _execute(() => _dio.delete(path));
  }

  Future<Response> _execute(Future<Response> Function() request) async {
    try {
      return await request();
    } on DioException catch (e, stackTrace) {
      log('[DIO CLIENT] Error: $e | Stacktrace $stackTrace');

      if (e.response?.statusCode == 409) {
        throw EmailAlreadyExistsFailure();
      }

      throw ServerFailure('Erro inesperado');
    } catch (e) {
      rethrow;
    }
  }
}
