import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_auth/data/adapter/firebase_adapter.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState()) {
    FirebaseAdapter.auth.then((value) {
      auth = value;
    });
  }

  late FirebaseAuth auth;

  final email = TextEditingController();
  final password = TextEditingController();
  final storage = GetStorage();
  final alertKey = GlobalKey();

  Future<void> signInWithEmail(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailureState(msg: 'Verifique o campo em branco'));
    } else {
      emit(LoginInProgressState());
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await storage.write('logged', true);
          emit(LoginSuccessState());
        });
      } on FirebaseAuthException catch (e) {
        if (e.code.contains('invalid-credential')) {
          await _createUserWithEmail(email, password);
        } else {
          emit(LoginFailureState(msg: e.code.replaceAll("-", " ")));
        }
      }
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LoginInProgressState());
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential).then((value) async {
          await storage.writeIfNull('logged', true);
          emit(LoginSuccessState());
        });
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFailureState(msg: e.code.replaceAll("-", " ")));
    }
  }

  Future<void> _createUserWithEmail(
    String email,
    String password,
  ) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await storage.write('logged', true);
        emit(LoginSuccessState());
      });
    } on FirebaseAuthException catch (e) {
      emit(LoginFailureState(msg: e.code.replaceAll("-", " ")));
    }
  }
}
