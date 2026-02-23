part of 'notice_bloc.dart';

sealed class NoticeState {}

final class NoticeLoading extends NoticeState {}

final class NoticeLoaded extends NoticeState {
  final List<Notice> notices;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final NoticeFilter filter;

  NoticeLoaded({
    required this.notices,
    this.filter = NoticeFilter.all,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });

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

  NoticeLoaded copyWith({
    List<Notice>? notices,
    bool? hasReachedMax,
    NoticeFilter? filter,
  }) {
    return NoticeLoaded(
      notices: notices ?? this.notices,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      filter: filter ?? this.filter,
    );
  }
}

final class NoticeLoadingError extends NoticeState {
  final String message;
  NoticeLoadingError({required this.message});
}

final class LastCheckedNoticeUpdateError extends NoticeState {
  final String message;
  LastCheckedNoticeUpdateError({required this.message});
}

final class LastCheckedNoticeUpdateSuccess extends NoticeState {}
