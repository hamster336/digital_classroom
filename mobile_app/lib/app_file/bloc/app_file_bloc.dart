import 'package:bloc/bloc.dart';

part 'app_file_event.dart';
part 'app_file_state.dart';

class AppFileBloc extends Bloc<AppFilesEvent, AppFileState> {
  AppFileBloc() : super(FilesLoading()) {
    on<AppFilesEvent>((event, emit) {});
  }
}
