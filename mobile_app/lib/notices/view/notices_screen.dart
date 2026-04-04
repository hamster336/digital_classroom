import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/notices/notice_bloc/notice_bloc.dart';
import 'package:mobile_app/notices/unread_count_bloc/unread_count_bloc.dart';
import 'package:mobile_app/notices/view/notice_list.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  final _scrollController = ScrollController();
  var filter = NoticeFilter.all;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<NoticeBloc>().state;
    if (state is NoticeLoaded && state.isLoadingMore) return;
    if (state is NoticeLoaded && state.hasReachedMax) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<NoticeBloc>().add(LoadNotices(currentFilter: filter));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Notices')),

      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: BlocListener<NoticeBloc, NoticeState>(
          listener: (context, state) {
            if (state is NoticeLoadingError) {
              CustomWidgets.customAltertBox(
                context,
                state.message,
                () => context.read<NoticeBloc>().add(
                  LoadNotices(currentFilter: filter),
                ),
              );
            }

            if (state is LastCheckedNoticeUpdateError) {
              CustomWidgets.customAltertBox(
                context,
                state.message,
                () => context.read<NoticeBloc>().add(
                  LoadNotices(currentFilter: filter),
                ),
              );
            }

            if (state is LastCheckedNoticeUpdateSuccess) {
              context.read<UnreadCountBloc>().add(ClearCount());
            }
          },

          child: Column(
            children: [
              // notice filter buttons
              BlocBuilder<NoticeBloc, NoticeState>(
                builder: (context, state) {
                  final currentFilter = (state is NoticeLoaded)
                      ? state.filter
                      : filter;

                  return Row(
                    children: [
                      CustomWidgets.noticeFilterButton(
                        label: 'All',
                        isSelected: currentFilter == NoticeFilter.all,
                        onTap: () {
                          setState(() {
                            filter = NoticeFilter.all;
                          });
                          context.read<NoticeBloc>().add(
                            FilterNotices(filter: NoticeFilter.all),
                          );
                        },
                      ),
                      const SizedBox(width: 5),
                      CustomWidgets.noticeFilterButton(
                        label: 'Important',
                        isSelected: currentFilter == NoticeFilter.important,
                        onTap: () {
                          setState(() {
                            filter = NoticeFilter.important;
                          });
                          context.read<NoticeBloc>().add(
                            FilterNotices(filter: NoticeFilter.important),
                          );
                        },
                      ),
                      const SizedBox(width: 5),
                      CustomWidgets.noticeFilterButton(
                        label: 'Urgent',
                        isSelected: currentFilter == NoticeFilter.urgent,
                        onTap: () {
                          setState(() {
                            filter = NoticeFilter.urgent;
                          });
                          context.read<NoticeBloc>().add(
                            FilterNotices(filter: NoticeFilter.urgent),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: size.height * 0.01),

              // view notices
              Expanded(
                child: BlocBuilder<SubjectBloc, SubjectState>(
                  builder: (context, state) {
                    if (state is SubjectsLoading) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 300),
                          CustomWidgets.customLoader(),
                        ],
                      );
                    }

                    List<String> subjectIds = (state is SubjectLoaded)
                        ? state.subjects.map((s) => s.id).toList()
                        : [];

                    return RefreshIndicator(
                      onRefresh: () async {
                        final noticeBloc = context.read<NoticeBloc>();
                        final upcomingBloc = context.read<UpcomingBloc>();
                        noticeBloc.add(RefreshNotices(currentFilter: filter));

                        upcomingBloc.add(RefreshEvents(subjectIds: subjectIds));

                        await noticeBloc.stream.firstWhere(
                          (state) =>
                              state is NoticeLoaded ||
                              state is NoticeLoadingError,
                        );
                      },

                      child: BlocBuilder<NoticeBloc, NoticeState>(
                        builder: (context, state) {
                          if (state is NoticeLoading) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: 300),
                                CustomWidgets.customLoader(),
                              ],
                            );
                          }

                          if (state is NoticeLoaded) {
                            final notices = state.displayNotices;
                            if (notices.isEmpty) {
                              return Center(
                                child: const Text(
                                  'No notices available',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            }

                            return NoticeList(
                              notices: notices,
                              scrollController: _scrollController,
                              showBottomLoader: state.isLoadingMore,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
