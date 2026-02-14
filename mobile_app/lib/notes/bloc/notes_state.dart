part of 'notes_bloc.dart';

sealed class NotesState {}

final class NotesInitial extends NotesState {}

final class NotesLoading extends NotesState {}

final class NotesLoaded extends NotesState {
  final List<AppFile> notes;
  final bool hasReachedMax;
  final bool isLoadingMore;

  NotesLoaded({required this.notes, required this.hasReachedMax, required this.isLoadingMore});
}

final class NotesLoadingError extends NotesState{
  final String message;

  NotesLoadingError({required this.message});
}

final class UploadNoteSuccess extends NotesState{}

final class DownloadNoteSuccess extends NotesState {}

final class DeleteNoteSuccess extends NotesState {}

final class UploadNoteError extends NotesState {
  final String message;

  UploadNoteError({required this.message});
}

final class DeleteNoteError extends NotesState {
  final String message;

  DeleteNoteError({required this.message});
}

final class DownloadNoteError extends NotesState{
  final String message;

  DownloadNoteError({required this.message});
}