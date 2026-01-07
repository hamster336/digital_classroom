import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mobile_app/notices/models/notice.dart';
import 'package:mobile_app/shared/required_enums.dart';

part 'notice_event.dart';
part 'notice_state.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  NoticeBloc() : super(NoticeLoading()) {
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
      final notices = [
        Notice(
          title: 'Winter Holidays',
          publishedAt: DateTime(2026, 1, 5, 14, 12, 22),
          description:
              'This year, the winter vacation starts from 25th of Poush until 9th of Magh. The administration will remain open during the holidays.',
          priority: NoticePriority.info,
        ),
        Notice(
          title: 'Proposal Defense',
          publishedAt: DateTime(2026, 1, 5, 08, 56, 01),
          description:
              'All the 6th sem students are notified to prepare for their proposal defense this Saturday starting from 10:00 am.',
          priority: NoticePriority.urgent,
        ),
        Notice(
          title: 'FU cup team selection',
          publishedAt: DateTime(2026, 1, 2, 23, 55, 12),
          description:
              'The sports week will start from 13th of Magh so the department of Engineering notifies all the interested students to enlist their names in the games they are interested in. The selection will start soon.',
          priority: NoticePriority.important,
        ),
        Notice(
          title: 'Winter Holidays',
          publishedAt: DateTime(2025, 12, 31, 14, 12, 22),
          description:
              'This year, the winter vacation starts from 25th of Poush until 9th of Magh. The administration will remain open during the holidays.',
          priority: NoticePriority.info,
        ),
        Notice(
          title: 'Proposal Defense',
          publishedAt: DateTime(2025, 12, 23, 08, 56, 01),
          description:
              'All the 6th sem students are notified to prepare for their proposal defense this Saturday starting from 10:00 am.',
          priority: NoticePriority.urgent,
        ),
      ];
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
