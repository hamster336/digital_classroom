import 'package:flutter/material.dart';
import 'package:mobile_app/model/custom_widgets.dart';
import 'package:mobile_app/model/notice.dart';
import 'package:mobile_app/model/required_enums.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<Notice> notices = [
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notices',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),

      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: Column(
          children: [
            // notice filter buttons
            Row(
              children: [
                CustomWidgets.noticeFilterButton(
                  'All',
                  NoticeFilter.all,
                  NoticeFilter.all,
                ),
                const SizedBox(width: 5),
                CustomWidgets.noticeFilterButton(
                  'Important',
                  NoticeFilter.important,
                  NoticeFilter.all,
                ),
                const SizedBox(width: 5),
                CustomWidgets.noticeFilterButton(
                  'Urgent',
                  NoticeFilter.urgent,
                  NoticeFilter.all,
                ),
              ],
            ),

            SizedBox(height: size.height * 0.01),

            // view notices
            Expanded(
              child: (notices.isEmpty)
                  ? Center(
                      child: const Text(
                        'No notices available',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        return CustomWidgets.noticeCard(notices[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
