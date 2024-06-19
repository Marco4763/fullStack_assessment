import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auth/data/adapter/dio_adapter.dart';
import 'package:mobile_auth/data/adapter/firebase_adapter.dart';
import 'package:mobile_auth/data/datasource/thumbnails_datasource.dart';
import 'package:mobile_auth/data/entities/thumbnail_entity.dart';
import 'package:mobile_auth/data/repositories/thumbnail_repository.dart';
import 'package:mobile_auth/ui/util/extensions.dart';
import 'package:path_provider/path_provider.dart';

part 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  ResultsCubit() : super(ResultsInitState()) {
    repository = ThumbnailRepository(
        datasource: ThumbnailsDatasource(adapter: DioAdapter()));
    FirebaseAdapter.auth.then((value) {
      auth = value;
    });
  }

  List<IThumbnailEntity> thumbnails = [];
  late ThumbnailRepository repository;
  late FirebaseAuth auth;
  final alertKey = GlobalKey();
  int start = 0;
  int end = 9;

  void getThumbnails() async {
    emit(ResultsInProgressState());
    repository
        .getALlResults(
      start.toString(),
      end.toString(),
    )
        .then((value) {
      if (value.success) {
        final dataList = value.data['data'] as List;
        List<ThumbnailEntity> results = [];
        for (var element in dataList) {
          if (element != null) {
            results.add(ThumbnailEntity.fromJson(element));
          }
        }
        thumbnails = results;
        emit(ResultsSuccessState());
      } else {
        emit(ResultsFailureState());
      }
    }).catchError((e) {
      emit(ResultsFailureState());
    });
  }

  void downloadThumbnail(String url) async {
    var dir = await getDownloadsDirectory();
    final path = (dir?.path ?? '') + url.filename;
    if (!(await File(path).exists())) {
      emit(ResultsInProgressState());
      try {
        final response = await Dio().get(url,
            options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }));

        File file = File(path);
        var raf = file.openSync(mode: FileMode.write);

        raf.writeFromSync(response.data);
        await raf.close();
        emit(ResultsDownloadMessageState(message: 'Download Succeed'));
      } catch (e) {
        emit(ResultsDownloadMessageState(
          message: 'Failed Download',
          isError: true,
        ));
      }
    } else {
      emit(ResultsDownloadMessageState(
        message: 'File Already exists',
        isError: true,
      ));
    }
  }

  void updateImage(File file, String id) async {
    emit(ResultsInProgressState());
    repository.update(file, id).then((value) {
      if (value.success) {
        getThumbnails();
      } else {
        emit(ResultsDownloadMessageState(
          message: 'Failed to Upload',
          isError: true,
        ));
      }
    }).catchError((e) {
      emit(ResultsDownloadMessageState(
        message: 'Failed to Upload',
        isError: true,
      ));
    });
  }
}
