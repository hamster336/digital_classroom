import 'package:bloc/bloc.dart';
import 'package:mobile_app/submission/model/submission.dart';
import 'package:mobile_app/submission/repository/submission_repo.dart';

part 'submission_event.dart';
part 'submission_state.dart';

class SubmissionBloc extends Bloc<SubmissionEvent, SubmissionState> {
  final SubmissionRepo repository;
  SubmissionBloc(this.repository) : super(SubmissionsLoading()) {
    on<SubmissionEvent>((event, emit) {
      
    });
  }
}
