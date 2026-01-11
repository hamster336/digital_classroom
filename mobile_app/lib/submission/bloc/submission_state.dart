part of 'submission_bloc.dart';

sealed class SubmissionState {}

final class SubmissionsLoading extends SubmissionState {}

final class SubmissionsLoaded extends SubmissionState {
  final List<Submission> submissions;
  SubmissionsLoaded({required this.submissions});
}

final class SubmissionError extends SubmissionState {
  final String message;
  SubmissionError({required this.message});
}
