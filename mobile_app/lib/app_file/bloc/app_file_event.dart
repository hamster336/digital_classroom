part of 'app_file_bloc.dart';

sealed class AppFilesEvent {}

// common events for teachers and students
final class LoadFiles extends AppFilesEvent {}

final class ViewFile extends AppFilesEvent {}

final class UploadFile extends AppFilesEvent {}

final class DownloadFile extends AppFilesEvent {}
