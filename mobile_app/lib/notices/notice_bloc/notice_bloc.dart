import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/notices/repository/notice_repo_impl.dart';
import 'package:mobile_app/shared/required_enums.dart';

part 'notice_event.dart';
part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepoImpl repository;
  NoticeBloc(this.repository) : super(NoticeLoading()) {
    on<LoadNotices>(_loadNotices);
    on<RefreshNotices>(_refreshNotices);
    on<FilterNotices>(_filterNotices);
    on<UpdateLastNoticeChecked>(_updateLastNoticeChecked);
  }

  static const int pageSize = 10;

  // refresh notices
  Future<void> _refreshNotices(
    RefreshNotices event,
    Emitter<NoticeState> emit,
  ) async {
    try {
      int from = 0;

      final newNotices = await repository.loadNotices(
        from: from,
        limit: pageSize,
      );

      emit(
        NoticeLoaded(
          notices: newNotices,
          filter: event.currentFilter,
          hasReachedMax: newNotices.length < pageSize,
        ),
      );
    } catch (e) {
      emit(NoticeLoadingError(message: e.toString()));
    }
  }

  // load notices
  Future<void> _loadNotices(
    LoadNotices event,
    Emitter<NoticeState> emit,
  ) async {
    if (state is NoticeLoaded && (state as NoticeLoaded).hasReachedMax) return;

    try {
      final currentState = state;

      List<Notice> oldNotices = [];
      int from = 0;

      if (currentState is NoticeLoaded) {
        oldNotices = currentState.notices;
        from = oldNotices.length;
      }

      if (oldNotices.isEmpty) {
        // true for firstLoad only
        emit(NoticeLoading());
      } else {
        // for first load, do not emit empty list instead emit loading state
        emit(
          NoticeLoaded(
            notices: oldNotices,
            hasReachedMax: false,
            isLoadingMore: true,
          ),
        );
      }

      final newNotices = await repository.loadNotices(
        from: from,
        limit: pageSize,
      );

      emit(
        NoticeLoaded(
          notices: oldNotices + newNotices,
          hasReachedMax: newNotices.length < pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(NoticeLoadingError(message: e.toString()));
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

  Future<void> _updateLastNoticeChecked(
    UpdateLastNoticeChecked event,
    Emitter<NoticeState> emit,
  ) async {
    try {
      final currentState = state;

      await repository.updateLastNoticeChecked(
        id: event.id,
        role: event.role,
        time: event.time,
      );

      emit(LastCheckedNoticeUpdateSuccess());
      emit(currentState);
    } catch (e) {
      emit(LastCheckedNoticeUpdateError(message: e.toString()));
    }
  }
}
