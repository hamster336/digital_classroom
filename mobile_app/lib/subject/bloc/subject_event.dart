part of 'subject_bloc.dart';

sealed class SubjectEvent {}

final class LoadSubjects extends SubjectEvent {
  final List<String> subjectIds;

  LoadSubjects({required this.subjectIds});
}
