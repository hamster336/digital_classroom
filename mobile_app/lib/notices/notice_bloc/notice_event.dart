part of 'notice_bloc.dart';

sealed class NoticeEvent {}

final class LoadNotices extends NoticeEvent {
  final NoticeFilter currentFilter;
  LoadNotices({required this.currentFilter});
}

final class RefreshNotices extends NoticeEvent {
  final NoticeFilter currentFilter;
  RefreshNotices({required this.currentFilter});
}

final class FilterNotices extends NoticeEvent {
  final NoticeFilter filter;
  FilterNotices({required this.filter});
}

final class UpdateLastNoticeChecked extends NoticeEvent {
  final String id;
  final UserRoles role;
  final DateTime time;
  UpdateLastNoticeChecked({
    required this.role,
    required this.time,
    required this.id,
  });
}
