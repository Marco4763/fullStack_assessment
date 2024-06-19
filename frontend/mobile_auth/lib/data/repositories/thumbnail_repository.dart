import 'dart:io';

import 'package:mobile_auth/data/datasource/thumbnails_datasource.dart';
import 'package:mobile_auth/data/entities/response_entity.dart';

class ThumbnailRepository {
  final ThumbnailsDatasource datasource;
  ThumbnailRepository({required this.datasource});

  Future<IResponseEntity> getALlResults(String start, String end) async {
    return await datasource.getThumbnails(start, end);
  }

  Future<IResponseEntity> upload(File file) async {
    return await datasource.uploadImage(file);
  }

  Future<IResponseEntity> update(File file, String id) async {
    return await datasource.updateThumbnail(file, id);
  }
}