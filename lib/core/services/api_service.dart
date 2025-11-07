import 'dart:async';

import 'package:dio/dio.dart';

import '../config/env.dart';

class ApiService {
  late Dio _dio;

  ApiService({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? Env.baseUrl,
        headers: {'Accept': 'application/json'},
      ),
    );
  }

  Future<T> request<T>(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    T Function(dynamic data)? parser,
  }) async {
    try {
      Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _dio.get(path, queryParameters: query);
          break;
        case 'POST':
          response = await _dio.post(path, data: data);
          break;
        case 'PUT':
          response = await _dio.put(path, data: data);
          break;
        case 'DELETE':
          response = await _dio.delete(path, data: data);
          break;
        default:
          throw Exception('Unsupported method $method');
      }

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        return parser != null ? parser(response.data) : response.data as T;
      } else if (statusCode >= 500) {
        throw Exception('Server error: $statusCode');
      } else {
        throw Exception('Failed with status code $statusCode');
      }
    } on DioException catch (e) {
      throw Exception('Terjadi Kesalahan $e');
    }
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic data)? parser,
  }) => request('GET', path, query: query, parser: parser);
}
