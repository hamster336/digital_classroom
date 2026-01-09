part of 'notice_bloc.dart';

sealed class NoticeState {}

final class NoticeLoading extends NoticeState {}

final class NoticeLoaded extends NoticeState {
  final List<Notice> notices;
  final NoticeFilter filter;

  NoticeLoaded({required this.notices, this.filter = NoticeFilter.all});

  // return notices based on priority
  List<Notice> get displayNotices {
    switch (filter) {
      case NoticeFilter.urgent:
        final list = notices
            .where((n) => n.priority == NoticePriority.urgent)
            .toList();
        return list;
      case NoticeFilter.important:
        final list = notices
            .where((n) => n.priority == NoticePriority.important)
            .toList();
        return list;
      case NoticeFilter.all:
        return notices;
    }
  }

  int get noticeLength => notices.length;

  NoticeLoaded copyWith({List<Notice>? notices, NoticeFilter? filter}) {
    return NoticeLoaded(
      notices: notices ?? this.notices,
      filter: filter ?? this.filter,
    );
  }
}

final class NoticeError extends NoticeState {
  final String message;
  NoticeError({required this.message});
}
