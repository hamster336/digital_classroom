import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/notices/bloc/notice_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/shared/required_enums.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Notices')),

      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: Column(
          children: [
            // notice filter buttons
            BlocBuilder<NoticeBloc, NoticeState>(
              builder: (context, state) {
                if (state is! NoticeLoaded) return const SizedBox.shrink();

                final currentFilter = state.filter;

                return Row(
                  children: [
                    CustomWidgets.noticeFilterButton(
                      label: 'All',
                      isSelected: currentFilter == NoticeFilter.all,
                      onTap: () => context.read<NoticeBloc>().add(
                        FilterNotices(filter: NoticeFilter.all),
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomWidgets.noticeFilterButton(
                      label: 'Important',
                      isSelected: currentFilter == NoticeFilter.important,
                      onTap: () => context.read<NoticeBloc>().add(
                        FilterNotices(filter: NoticeFilter.important),
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomWidgets.noticeFilterButton(
                      label: 'Urgent',
                      isSelected: currentFilter == NoticeFilter.urgent,
                      onTap: () => context.read<NoticeBloc>().add(
                        FilterNotices(filter: NoticeFilter.urgent),
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: size.height * 0.01),

            // view notices
            Expanded(
              child: BlocBuilder<NoticeBloc, NoticeState>(
                builder: (context, state) {
                  if (state is NoticeLoading) return const SizedBox.shrink();

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

                    return ListView.builder(
                      itemCount: notices.length,
                      itemBuilder: (_, index) {
                        return CustomWidgets.noticeCard(notices[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
