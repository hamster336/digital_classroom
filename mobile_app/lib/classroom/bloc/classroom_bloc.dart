import 'package:bloc/bloc.dart';
import 'package:mobile_app/classroom/model/classroom.dart';

import 'package:mobile_app/classroom/repository/classroom_repo.dart';

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  final ClassroomRepo repository;
  ClassroomBloc(this.repository) : super(ClassroomInitial()) {
    on<ClassroomEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
