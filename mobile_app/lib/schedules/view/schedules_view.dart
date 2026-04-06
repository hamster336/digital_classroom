import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/schedules/bloc/schedule_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class SchedulesView extends StatefulWidget {
  final String classId;
  const SchedulesView({super.key, required this.classId});

  @override
  State<SchedulesView> createState() => _SchedulesViewState();
}

class _SchedulesViewState extends State<SchedulesView> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(LoadSchedules(classId: widget.classId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Schedules')),
      body: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleLoadingError) {
            CustomWidgets.customAltertBox(context, state.message, () {});
          }

          if (state is DownloadScheduleError) {
            CustomWidgets.customAltertBox(context, state.message, () {});
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            final bloc = context.read<ScheduleBloc>();
            bloc.add(RefreshSchedules(classId: widget.classId));

            await bloc.stream.firstWhere(
              (state) =>
                  state is SchedulesLoaded || state is ScheduleLoadingError,
            );
          },
          child: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleLoading) {
                return CustomWidgets.customLoader();
              }

              if (state is SchedulesLoaded) {
                final schedules = state.schedules;

                if (schedules.isEmpty) {
                  return CustomWidgets.customScrollableText(
                    context,
                    'No schedules available',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];

                    final isDownloaded = schedule.isDownloaded;

                    final isDownloading =
                        state.downloadProgress.containsKey(schedule.id) &&
                        !isDownloaded;

                    return CustomWidgets.scheduleCard(
                      schedule: schedule,
                      onDownload: () {
                        context.read<ScheduleBloc>().add(
                          DownloadSchedule(schedule: schedule),
                        );
                      },
                      isDownloaded: isDownloaded,
                      downlaoding: isDownloading,
                    );
                  },
                );
              }

              return CustomWidgets.customScrollableText(
                context,
                'Error occured :(\nPull down to refresh',
              );
            },
          ),
        ),
      ),
    );
  }
}
