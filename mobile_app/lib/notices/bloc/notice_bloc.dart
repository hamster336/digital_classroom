import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/notices/repository/notice_repo.dart';
import 'package:mobile_app/shared/required_enums.dart';

part 'notice_event.dart';
part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepo repository;
  NoticeBloc(this.repository) : super(NoticeLoading()) {
    // event handlers
    on<LoadNotices>(_loadNotices);
    on<FilterNotices>(_filterNotices);
  }

  // load notices
  Future<void> _loadNotices(
    LoadNotices event,
    Emitter<NoticeState> emit,
  ) async {
    emit(NoticeLoading());

    try {
      final notices = repository.fetchNotices();
      emit(NoticeLoaded(notices: notices));
    } catch (ex) {
      emit(NoticeError(message: 'Failed to load notices!'));
    }
  }

  // filter notices
  Future<void> _filterNotices(
    FilterNotices event,
    Emitter<NoticeState> emit,
  ) async {
    if (state is! NoticeLoaded) return;

    final current = state as NoticeLoaded;
    emit(current.copyWith(filter: event.filter));
  }
}
