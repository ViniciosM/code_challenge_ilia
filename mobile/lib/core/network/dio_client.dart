import 'dart:developer';

import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  DioClient({Dio? dio}) {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: 'http://localhost:3000', // ajustar depois
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
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
      throw Exception(
        'Network error: ${e.response?.data ?? e.message} | Stacktrace: $stackTrace',
      );
    } catch (e) {
      rethrow;
    }
  }
}
