import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/assignments/bloc/assignment_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/shared/required_enums.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: const Text('Assignments')),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // total and pending assignments count
            BlocBuilder<AssignmentBloc, AssignmentState>(
              builder: (context, state) {
                if (state is! AssignmentLoaded) return const SizedBox.shrink();

                return Text(
                  'Pending ${state.pendingCount} . Total ${state.totalCount}',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                );
              },
            ),

            SizedBox(height: size.height * 0.01),

            // filter buttons
            BlocBuilder<AssignmentBloc, AssignmentState>(
              builder: (context, state) {
                if (state is! AssignmentLoaded) return const SizedBox.shrink();

                final currentFilter = state.filter;

                return Row(
                  children: [
                    CustomWidgets.assignmentFilterButton(
                      label: 'Pending',
                      isSelected: currentFilter == AssignmentFilter.pending,
                      onTap: () => context.read<AssignmentBloc>().add(
                        FilterAssignments(filter: AssignmentFilter.pending),
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomWidgets.assignmentFilterButton(
                      label: 'Overdue',
                      isSelected: currentFilter == AssignmentFilter.overdue,
                      onTap: () => context.read<AssignmentBloc>().add(
                        FilterAssignments(filter: AssignmentFilter.overdue),
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomWidgets.assignmentFilterButton(
                      label: 'Completed',
                      isSelected: currentFilter == AssignmentFilter.completed,
                      onTap: () => context.read<AssignmentBloc>().add(
                        FilterAssignments(filter: AssignmentFilter.completed),
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: size.height * 0.01),

            // show the assignments
            Expanded(
              child: BlocBuilder<AssignmentBloc, AssignmentState>(
                builder: (context, state) {
                  if (state is AssignmentLoading) {
                    return const SizedBox.shrink();
                  }

                  if (state is AssignmentLoaded) {
                    final assignments = state.displayAssignments;
                    if (assignments.isEmpty) {
                      return Center(
                        child: const Text(
                          'No assingments available',
                          style: TextStyle(fontSize: 17),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: assignments.length,
                      itemBuilder: (_, index) {
                        return CustomWidgets.assignmentCards(
                          context,
                          assignments[index],
                        );
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
