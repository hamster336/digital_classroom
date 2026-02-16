part of 'subject_bloc.dart';

sealed class SubjectState {}

final class SubjectInitial extends SubjectState {}

final class SubjectsLoading extends SubjectState {}

final class SubjectLoaded extends SubjectState {
  final List<Subject> subjects;
  
  SubjectLoaded({required this.subjects});
}

final class SubjectError extends SubjectState {
  final String message;
  SubjectError({required this.message});
}
