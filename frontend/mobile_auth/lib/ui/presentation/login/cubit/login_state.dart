part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitState extends LoginState {}

class LoginInProgressState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginState {
  LoginFailureState({required this.msg});

  final String msg;
}
