import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/notes/bloc/notes_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/subject/view/subject_selection_dialog.dart';
import 'package:mobile_app/user/models/teacher.dart';

class TeacherNotesView extends StatefulWidget {
  final Teacher teacher;
  final String classId;
  const TeacherNotesView({
    super.key,
    required this.teacher,
    required this.classId,
  });

  @override
  State<TeacherNotesView> createState() => _TeacherNotesViewState();
}

class _TeacherNotesViewState extends State<TeacherNotesView> {
  final scrollController = ScrollController();
  late List<Subject> subjects = [];
  Subject? subject;

  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(
      LoadNotesForTeacher(
        teacherId: widget.teacher.id,
        classId: widget.classId,
      ),
    );
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<NotesBloc>().state;
    if (state is NotesLoaded && state.isLoadingMore) return;
    if (state is NotesLoaded && state.hasReachedMax) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      context.read<NotesBloc>().add(
        LoadNotesForTeacher(
          classId: widget.classId,
          teacherId: widget.teacher.id,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Notes")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocListener<NotesBloc, NotesState>(
          listener: (context, state) {
            if (state is NotesLoadingError) {
              CustomWidgets.customAltertBox(context, state.message, () {});
            }

            if (state is UploadNoteError) {
              CustomWidgets.customAltertBox(context, state.message, () {});
            }

            if (state is DeleteNoteError) {
              CustomWidgets.customAltertBox(context, state.message, () {});
            }

            if (state is DeleteNoteSuccess) {
              context.read<NotesBloc>().add(
                RefreshNotesForTeacher(
                  teacherId: widget.teacher.id,
                  classId: widget.classId,
                ),
              );
              CustomWidgets.customAltertBox(
                context,
                'Delete successful.',
                () {},
              );
            }

            if (state is UploadNoteSuccess) {
              context.read<NotesBloc>().add(
                RefreshNotesForTeacher(
                  teacherId: widget.teacher.id,
                  classId: widget.classId,
                ),
              );
              CustomWidgets.customAltertBox(
                context,
                'Upload successful.',
                () {},
              );
            }
          },
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // upload notes
              BlocBuilder<SubjectBloc, SubjectState>(
                builder: (context, state) {
                  subjects = (state is SubjectLoaded) ? state.subjects : [];

                  final classSubjects = subjects
                      .where((s) => s.classId == widget.classId)
                      .toList();

                  return ElevatedButton(
                    onPressed: () async => _uploadFile(classSubjects),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      backgroundColor: Color(0xFF2AB3AA),
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        const Icon(Icons.upload),
                        const SizedBox(width: 5),
                        const Text(
                          'Upload Notes',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<NotesBloc>();
                    bloc.add(
                      RefreshNotesForTeacher(
                        teacherId: widget.teacher.id,
                        classId: widget.classId,
                      ),
                    );

                    await bloc.stream.firstWhere(
                      (state) =>
                          state is NotesLoaded || state is NotesLoadingError,
                    );
                  },
                  child: BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) {
                      if (state is NotesLoading) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 300),
                            CustomWidgets.customLoader(),
                          ],
                        );
                      }

                      if (state is NotesLoaded) {
                        final notes = state.notes;
                        if (notes.isEmpty) {
                          return CustomWidgets.customScrollableText(
                            context,
                            'No notes available :(',
                          );
                        }

                        return ListView.builder(
                          controller: scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount:
                              notes.length + (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == notes.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: CustomWidgets.customLoader(),
                              );
                            }

                            final note = notes[index];

                            final sub = subjects.firstWhere(
                              (s) => s.id == notes[index].ownerId,
                            );

                            return CustomWidgets.teacherNotesCard(
                              note: notes[index],
                              subjectName: sub.name,

                              onDelete: () async =>
                                  _onDelete(note.id!, note.filePath),
                            );
                          },
                        );
                      }

                      return CustomWidgets.customScrollableText(
                        context,
                        'Error occured :(\nSwipe down to refresh.',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // onPressed of upload button
  Future<void> _uploadFile(List<Subject> classSubjects) async {
    subject = await showDialog<Subject>(
      context: context,
      builder: (context) => SubjectSelectionDialog(subjects: classSubjects),
    );

    if (subject == null) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result == null) {
      subject = null;
      return;
    }

    final files = result.files;

    _addEvent(subject!.id, files);

    subject = null;
  }

  // add the bloc event
  void _addEvent(String subjectId, List<PlatformFile> files) {
    context.read<NotesBloc>().add(
      UploadNotes(
        notes: files,
        teacherId: widget.teacher.id,
        classId: widget.classId,
        subjectId: subjectId,
      ),
    );
  }

  // delete assignment
  Future<void> _onDelete(String noteId, String filePath) async {
    final bloc = context.read<NotesBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return CustomWidgets.customConformationBox(
          context: context,
          title: 'Delete Note',
          content: 'Are you sure you want to delete this file?',
          onConfirm: () async {
            bloc.add(DeleteNote(noteId: noteId, filePath: filePath));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
