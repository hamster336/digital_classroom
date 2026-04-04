import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/assignments/models/assignment.dart';
import 'package:mobile_app/assignments/teacher_assignments/bloc/teacher.assignment_bloc.dart';
import 'package:mobile_app/classroom/model/classroom.dart';
import 'package:mobile_app/home/bloc/teachers_dashboard_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/upcoming/bloc/upcoming_bloc.dart';
import 'package:mobile_app/user/models/teacher.dart';

class AssignmentForm extends StatefulWidget {
  final Assignment? initialAssignment;
  final Classroom cls;
  final Teacher teacher;

  const AssignmentForm({
    super.key,
    this.initialAssignment,
    required this.cls,
    required this.teacher,
  });

  @override
  State<AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final subjectController = TextEditingController();
  final dateController = TextEditingController();
  final priorityController = TextEditingController();

  String? selectedSubjectId;
  DateTime? dueDate;
  AssignmentPriority? priority;

  BuildContext? dialogContext;
  final titleFocus = FocusNode();
  final descriptionFocus = FocusNode();

  @override
  void initState() {
    if (widget.initialAssignment != null) {
      titleController.text = widget.initialAssignment!.title;
      descriptionController.text = widget.initialAssignment!.description;

      selectedSubjectId = widget.initialAssignment!.subjectId;

      dueDate = widget.initialAssignment!.dueDate;

      dateController.text = DateFormat('hh:mm a, dd MMM y').format(dueDate!);

      priority = widget.initialAssignment!.priority;
      priorityController.text = _getPriority(priority!);
    }

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    subjectController.dispose();
    dateController.dispose();
    priorityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          (widget.initialAssignment == null)
              ? 'Create a new Assignment'
              : 'Upadate Assignment',
        ),
      ),

      body: GestureDetector(
        onTap: () => _clearKeyboard(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: BlocListener<TeacherAssignmentBloc, TeacherAssignmentState>(
            listener: (context, state) {
              if (state is CreateAssignmentError) {
                CustomWidgets.customAltertBox(context, state.message, () {});
              }

              if (state is UpdateAssignmentError) {
                CustomWidgets.customAltertBox(context, state.message, () {});
              }

              if (state is CreateAssignmentSuccess) {
                // refresh active assignment count
                context.read<DashboardBloc>().add(
                  LoadActiveAssignmentCount(teacherId: widget.teacher.id),
                );
                // refresh assignments
                context.read<TeacherAssignmentBloc>().add(
                  RefreshAssignments(
                    teacherId: widget.teacher.id,
                    classId: widget.cls.id,
                  ),
                );
                // refresh events
                context.read<UpcomingBloc>().add(
                  RefreshEvents(subjectIds: widget.teacher.subjectIds),
                );

                CustomWidgets.customAltertBox(
                  context,
                  'Assignment issued successfully.',
                  () => Navigator.pop(context),
                );
              }

              if (state is UpdateAssignmentSuccess) {
                // refresh active assignment count
                context.read<DashboardBloc>().add(
                  LoadActiveAssignmentCount(teacherId: widget.teacher.id),
                );
                // refresh assignments
                context.read<TeacherAssignmentBloc>().add(
                  RefreshAssignments(
                    teacherId: widget.teacher.id,
                    classId: widget.cls.id,
                  ),
                );
                // refresh upcoming events
                context.read<UpcomingBloc>().add(
                  RefreshEvents(subjectIds: widget.teacher.subjectIds),
                );

                CustomWidgets.customAltertBox(
                  context,
                  'Assignment updated successfully.',
                  () => Navigator.pop(context),
                );
              }
            },
            child: BlocBuilder<TeacherAssignmentBloc, TeacherAssignmentState>(
              builder: (context, state) {
                if (state is TeacherAssignmentLoading) {
                  return CustomWidgets.customLoader();
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .center,
                    children: [
                      SizedBox(height: size.height * 0.02),

                      // title field
                      CustomWidgets.customTextField(
                        controller: titleController,
                        label: 'Title',
                        obscureText: false,
                        cap: .sentences,
                        focusNode: titleFocus,
                      ),

                      SizedBox(height: size.height * 0.015),

                      // description field
                      CustomWidgets.customTextField(
                        controller: descriptionController,
                        label: 'Description',
                        obscureText: false,
                        cap: .sentences,
                        focusNode: descriptionFocus,
                        maxLines: null,
                      ),

                      SizedBox(height: size.height * 0.015),

                      // class field
                      CustomWidgets.customTextField(
                        controller: TextEditingController(
                          text: widget.cls.name,
                        ),
                        label: 'Class',
                        obscureText: false,
                        enabled: false,
                      ),

                      SizedBox(height: size.height * 0.015),

                      // subject picker
                      BlocBuilder<SubjectBloc, SubjectState>(
                        builder: (context, state) {
                          List<Subject> subjectList = (state is SubjectLoaded)
                              ? state.subjects
                              : [];
                          final classSubjects = subjectList
                              .where((s) => s.classId == widget.cls.id)
                              .toList();
                          if (selectedSubjectId != null) {
                            final subject = subjectList.firstWhere(
                              (s) => s.id == selectedSubjectId,
                            );
                            subjectController.text = subject.name;
                          }
                          return CustomWidgets.customMenuItemPicker(
                            subjectController,
                            'Subject',
                            _subjectPicker(classSubjects),
                          );
                        },
                      ),

                      SizedBox(height: size.height * 0.015),

                      // due date picker
                      CustomWidgets.customMenuItemPicker(
                        dateController,
                        'Due Date',
                        _datePicker(),
                      ),

                      SizedBox(height: size.height * 0.015),

                      // assignment priority picker
                      CustomWidgets.customMenuItemPicker(
                        priorityController,
                        'Priority',
                        _priorityPicker(),
                      ),

                      SizedBox(height: size.height * 0.03),

                      CustomWidgets.customButton(
                        size,
                        (widget.initialAssignment == null)
                            ? 'Add Assignment'
                            : 'Update Assignment',
                        () => (widget.initialAssignment == null)
                            ? _createAssignment()
                            : _updateAssignment(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // unfocus textfields
  void _clearKeyboard() {
    titleFocus.unfocus();
    descriptionFocus.unfocus();
  }

  // pop up menu button for subject picker
  Widget _subjectPicker(List<Subject> subs) {
    return PopupMenuButton<Subject>(
      offset: Offset(-10, 60),
      child: Icon(Icons.arrow_drop_down_outlined),
      itemBuilder: (context) {
        return subs.map((subject) {
          return PopupMenuItem<Subject>(
            value: subject,
            child: Text(subject.name, style: TextStyle(fontSize: 17)),
          );
        }).toList();
      },
      onOpened: () => _clearKeyboard(),
      onSelected: (subject) {
        setState(() {
          selectedSubjectId = subject.id;
          subjectController.text = subject.name;
        });
      },
    );
  }

  // show date and time picker
  Widget _datePicker() {
    return IconButton(
      onPressed: () async {
        _clearKeyboard();
        final date = await showDatePicker(
          context: context,
          initialDate: (widget.initialAssignment?.dueDate),
          firstDate: DateTime.now(),
          lastDate: DateTime(
            widget.cls.endYear + 1,
            00,
            01,
          ).subtract(const Duration(minutes: 1)),
        );

        if (date == null) return;

        if (!mounted) return;

        final time = await showTimePicker(
          initialEntryMode: .inputOnly,
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (time == null) return;

        setState(() {
          dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
        dateController.text = DateFormat('hh:mm a, dd MMM y').format(dueDate!);
      },
      icon: Icon(Icons.calendar_month),
    );
  }

  // priority picker
  Widget _priorityPicker() {
    return PopupMenuButton(
      offset: Offset(-10, 60),
      child: Icon(Icons.arrow_drop_down_outlined),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: 'urgent', child: Text('Urgent')),
        PopupMenuItem<String>(value: 'medium', child: Text('Medium')),
        PopupMenuItem<String>(value: 'normal', child: Text('Normal')),
      ],
      onOpened: () => _clearKeyboard(),
      onSelected: (value) {
        switch (value) {
          case 'urgent':
            setState(() {
              priority = AssignmentPriority.urgent;
              priorityController.text = 'Urgent';
            });
            break;
          case 'medium':
            setState(() {
              priority = AssignmentPriority.medium;
              priorityController.text = 'Medium';
            });
            break;
          case 'normal':
            setState(() {
              priority = AssignmentPriority.normal;
              priorityController.text = 'Normal';
            });
            break;
        }
      },
    );
  }

  // create assignment
  void _createAssignment() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final date = dateController.text.trim();
    final subject = subjectController.text.trim();
    final assignPriority = priorityController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        date.isEmpty ||
        subject.isEmpty ||
        assignPriority.isEmpty) {
      CustomWidgets.customAltertBox(
        context,
        'Fields cannot be left empty.',
        () {},
      );
      return;
    }

    final assignment = Assignment(
      title: title,
      description: description,
      issuedAt: DateTime.now(),
      dueDate: dueDate!,
      classId: widget.cls.id,
      subjectId: selectedSubjectId!,
      teacherId: widget.teacher.id,
      priority: priority!,
    );

    context.read<TeacherAssignmentBloc>().add(
      CreateAssignment(assignment: assignment),
    );
  }

  // update assignment
  void _updateAssignment() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final date = dateController.text.trim();
    final subject = subjectController.text.trim();
    final assignPriority = priorityController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        date.isEmpty ||
        subject.isEmpty ||
        assignPriority.isEmpty) {
      CustomWidgets.customAltertBox(
        context,
        'Fields cannot be left empty.',
        () {},
      );
      return;
    }

    final assignment = widget.initialAssignment!.copyWith(
      title: title,
      description: description,
      dueDate: dueDate!,
      subjectId: selectedSubjectId!,
      priority: priority!,
    );

    context.read<TeacherAssignmentBloc>().add(
      UpdateAssignment(assignment: assignment),
    );
  }

  // get priority
  String _getPriority(AssignmentPriority p) {
    if (p == AssignmentPriority.urgent) return 'Urgent';
    if (p == AssignmentPriority.medium) return 'Medium';
    return 'Normal';
  }
}
