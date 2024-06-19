part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeInProgressState extends HomeState {}

class HomeSuccessState extends HomeState {}

class HomeSignOutState extends HomeState {}

class HomeFailureState extends HomeState {}
