part of 'results_cubit.dart';

abstract class ResultsState {}

class ResultsInitState extends ResultsState {}

class ResultsInProgressState extends ResultsState {}

class ResultsSuccessState extends ResultsState {}

class ResultsDownloadMessageState extends ResultsState {
  ResultsDownloadMessageState({
    required this.message,
    this.isError = false,
  });

  final String message;
  final bool isError;
}

class ResultsFailureState extends ResultsState {}
