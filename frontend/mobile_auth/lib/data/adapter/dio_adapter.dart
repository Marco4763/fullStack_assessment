import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mobile_auth/data/entities/response_entity.dart';

class DioAdapter {
  late Dio dio;

  DioAdapter() : super() {
    dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8080'));
  }

  Future<IResponseEntity> get({
    required String path,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.get(path, options: Options(headers: headers));

      if (response.statusCode == 200) {
        return ResponseEntity(
          success: true,
          data: response.data,
        );
      } else {
        return ResponseEntity(
          success: false,
        );
      }
    } on DioException catch (e) {
      return ResponseEntity(
        success: false,
        message: e.message,
      );
    }
  }

  Future<IResponseEntity> postFile({
    required String path,
    required Map<String, dynamic> map,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final formData = FormData.fromMap(map);
      final response = await dio.post(
        path,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return ResponseEntity(
          success: true,
          data: response.data,
        );
      } else {
        return ResponseEntity(
          success: false,
        );
      }
    } on DioException catch (e) {
      return ResponseEntity(
        success: false,
        message: e.message,
      );
    }
  }

  Future<IResponseEntity> putFile({
    required String path,
    required Map<String, dynamic> map,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final formData = FormData.fromMap(map);
      final response = await dio.put(
        path,
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return ResponseEntity(
          success: true,
          data: response.data,
        );
      } else {
        return ResponseEntity(
          success: false,
        );
      }
    } on DioException catch (e) {
      return ResponseEntity(
        success: false,
        message: e.message,
      );
    }
  }
}
