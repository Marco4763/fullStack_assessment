import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auth/data/adapter/dio_adapter.dart';
import 'package:mobile_auth/data/adapter/firebase_adapter.dart';
import 'package:mobile_auth/data/datasource/thumbnails_datasource.dart';
import 'package:mobile_auth/data/repositories/thumbnail_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitState()) {
    repository = ThumbnailRepository(
        datasource: ThumbnailsDatasource(adapter: DioAdapter()));
    FirebaseAdapter.auth.then((value) {
      auth = value;
    });
  }

  late ThumbnailRepository repository;
  late FirebaseAuth auth;
  final alertKey = GlobalKey();

  void uploadImage(File file) async {
    emit(HomeInProgressState());
    repository.upload(file).then((value) {
      if (value.success) {
        emit(HomeSuccessState());
      } else {
        emit(HomeFailureState());
      }
    }).catchError((e) {
      emit(HomeFailureState());
    });
  }

  void signOut() async {
    emit(HomeInProgressState());
    auth.signOut().then((value) {
      emit(HomeSignOutState());
    });
  }
}
