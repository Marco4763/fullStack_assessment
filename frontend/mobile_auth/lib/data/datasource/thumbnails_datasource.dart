import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile_auth/data/adapter/dio_adapter.dart';
import 'package:mobile_auth/data/entities/response_entity.dart';

class ThumbnailsDatasource {
  final DioAdapter adapter;

  ThumbnailsDatasource({required this.adapter});

  Future<IResponseEntity> getThumbnails(String start, String end) async {
    print('/allResults/$start/$end');
    return await adapter.get(path: '/allResults/$start/$end');
  }

  Future<IResponseEntity> uploadImage(File file) async {
    final body = {'image': await MultipartFile.fromFile(file.path)};
    return await adapter.postFile(
      path: '/upload',
      map: body,
    );
  }

  Future<IResponseEntity> updateThumbnail(File file, String id) async {
    final body = {'image': await MultipartFile.fromFile(file.path)};
    return await adapter.putFile(
      path: '/upload/$id',
      map: body,
    );
  }
}
