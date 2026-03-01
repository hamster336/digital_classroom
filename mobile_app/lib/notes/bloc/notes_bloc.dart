import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/notes/repository/notes_repository_impl.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepositoryImpl repository;
  NotesBloc(this.repository) : super(NotesInitial()) {
    on<LoadNotesForTeacher>(_loadNotesForTeacher);
    on<RefreshNotesForTeacher>(_refreshNotesForTeacher);
    on<LoadNotesForStudent>(_loadNotesForStudent);
    on<RefreshNotesForStudent>(_refreshNotesForStudent);
    on<UploadNotes>(_uploadNote);
    on<DownloadNote>(_downloadNote);
    on<DeleteNote>(_deleteNote);
  }

  static const int pageSize = 10;

  /// FOR TEACHER

  // to temporarily cache loaded data for teacher
  Map<String, List<AppFile>> cachedNotesForTeacher = {};
  Map<String, bool> cachedReachedMaxForTeacher = {};

  // refresh on scroll down
  Future<void> _refreshNotesForTeacher(
    RefreshNotesForTeacher event,
    Emitter<NotesState> emit,
  ) async {
    final key = '${event.teacherId}-${event.classId}';

    try {
      int from = 0;
      final notes = await repository.loadNotesForTeacher(
        classId: event.classId,
        teacherId: event.teacherId,
        from: from,
        limit: pageSize,
      );

      cachedNotesForTeacher[key] = notes;
      cachedReachedMaxForTeacher[key] = notes.length < pageSize;

      emit(
        NotesLoaded(
          notes: notes,
          hasReachedMax: notes.length < pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }

  // load notes with pagination
  Future<void> _loadNotesForTeacher(
    LoadNotesForTeacher event,
    Emitter<NotesState> emit,
  ) async {
    if (state is NotesLoaded && (state as NotesLoaded).hasReachedMax) return;

    final key = '${event.teacherId}-${event.classId}';

    if (cachedNotesForTeacher.containsKey(key) &&
        cachedReachedMaxForTeacher.containsKey(key)) {
      emit(
        NotesLoaded(
          notes: cachedNotesForTeacher[key]!,
          hasReachedMax: cachedReachedMaxForTeacher[key]!,
          isLoadingMore: false,
        ),
      );
    }

    try {
      final currentState = state;

      List<AppFile> oldNotes = [];
      int from = 0;

      if (currentState is NotesLoaded) {
        oldNotes = currentState.notes;
        from = oldNotes.length;
      }

      if (oldNotes.isEmpty) {
        emit(NotesLoading());
      } else {
        emit(
          NotesLoaded(
            notes: oldNotes,
            hasReachedMax: false,
            isLoadingMore: true,
          ),
        );
      }

      final newNotes = await repository.loadNotesForTeacher(
        classId: event.classId,
        teacherId: event.teacherId,
        from: from,
        limit: pageSize,
      );

      cachedNotesForTeacher[key] = oldNotes + newNotes;
      cachedReachedMaxForTeacher[key] = newNotes.length < pageSize;

      emit(
        NotesLoaded(
          notes: oldNotes + newNotes,
          hasReachedMax: newNotes.length < pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }

  // upload notes
  Future<void> _uploadNote(UploadNotes event, Emitter<NotesState> emit) async {
    if (state is! NotesLoaded) return;

    emit(NotesLoading());

    try {
      await repository.uploadNotes(
        files: event.notes,
        teacherId: event.teacherId,
        classId: event.classId,
        subjectId: event.subjectId,
      );
      emit(UploadNoteSuccess());
    } catch (e) {
      emit(UploadNoteError(message: e.toString()));
    }
  }

  // delete note
  Future<void> _deleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    if (state is! NotesLoaded) return;

    final currentState = state;

    emit(NotesLoading());

    try {
      await repository.deleteNote(event.noteId, event.filePath);
      emit(DeleteNoteSuccess());
      emit(currentState);
    } catch (e) {
      emit(DeleteNoteError(message: e.toString()));
    }
  }

  /// FOR STUDENTS

  List<AppFile> cachedNotesForStudent = [];
  bool cachedReachedMaxForStudent = false;

  // download notes
  Future<void> _downloadNote(
    DownloadNote event,
    Emitter<NotesState> emit,
  ) async {
    final currentState = state;
    try {
      await repository.downloadNote(event.note);
      emit(DownloadNoteSuccess());
    } catch (e) {
      emit(DownloadNoteError(message: e.toString()));
      emit(currentState);
    }
  }

  // refresh on scroll down
  Future<void> _refreshNotesForStudent(
    RefreshNotesForStudent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      int from = 0;
      final notes = await repository.loadNotesForStudent(
        classId: event.classId,
        subjectIds: event.subjectIds,
        from: from,
        limit: pageSize,
      );

      cachedNotesForStudent = notes;
      cachedReachedMaxForStudent = notes.length < pageSize;

      emit(
        NotesLoaded(
          notes: notes,
          hasReachedMax: notes.length < pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }

  // load notes with pagination
  Future<void> _loadNotesForStudent(
    LoadNotesForStudent event,
    Emitter<NotesState> emit,
  ) async {
    if (state is NotesLoaded && (state as NotesLoaded).hasReachedMax) return;

    if (cachedNotesForStudent.isEmpty) {
      emit(
        NotesLoaded(
          notes: cachedNotesForStudent,
          hasReachedMax: cachedReachedMaxForStudent,
          isLoadingMore: false,
        ),
      );
    }

    try {
      final currentState = state;

      List<AppFile> oldNotes = [];
      int from = 0;

      if (currentState is NotesLoaded) {
        oldNotes = currentState.notes;
        from = oldNotes.length;
      }

      if (oldNotes.isEmpty) {
        emit(NotesLoading());
      } else {
        emit(
          NotesLoaded(
            notes: oldNotes,
            hasReachedMax: false,
            isLoadingMore: true,
          ),
        );
      }

      final newNotes = await repository.loadNotesForStudent(
        classId: event.classId,
        subjectIds: event.subjectId,
        from: from,
        limit: pageSize,
      );

      cachedNotesForStudent = oldNotes + newNotes;
      cachedReachedMaxForStudent = newNotes.length < pageSize;

      emit(
        NotesLoaded(
          notes: oldNotes + newNotes,
          hasReachedMax: newNotes.length < pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }
}
