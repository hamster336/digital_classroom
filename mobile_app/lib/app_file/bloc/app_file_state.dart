part of 'app_file_bloc.dart';

sealed class AppFileState {}

final class FilesLoading extends AppFileState {}

final class FilesLoaded extends AppFileState {}

final class FilesError extends AppFileState {}
