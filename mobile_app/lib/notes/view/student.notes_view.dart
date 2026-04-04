import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/notes/bloc/notes_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';
import 'package:mobile_app/shared/public_directory.dart';
import 'package:mobile_app/subject/bloc/subject_bloc.dart';
import 'package:mobile_app/subject/model/subject.dart';
import 'package:mobile_app/user/models/student.dart';

class StudentNotesView extends StatefulWidget {
  final Student student;
  const StudentNotesView({super.key, required this.student});

  @override
  State<StudentNotesView> createState() => _StudentNotesViewState();
}

class _StudentNotesViewState extends State<StudentNotesView> {
  final scrollController = ScrollController();
  String? dir;

  @override
  void initState() {
    scrollController.addListener(_onScroll);
    // load notes
    context.read<NotesBloc>().add(
      LoadNotesForStudent(
        classId: widget.student.classId,
        subjectId: widget.student.subjectIds,
      ),
    );
    getDirectoryPath();
    super.initState();
  }

  void getDirectoryPath() async {
    dir = await PublicDirectory.getPublicDirectoryPath();
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
        LoadNotesForStudent(
          classId: widget.student.classId,
          subjectId: widget.student.subjectIds,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Notes')),

      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: BlocListener<NotesBloc, NotesState>(
          listener: (context, state) {
            if (state is NotesLoadingError) {
              CustomWidgets.customAltertBox(context, state.message, () {});
            }

            if (state is DownloadNoteError) {
              CustomWidgets.customAltertBox(context, state.message, () {});
            }

            if (state is DownloadNoteSuccess) {
              context.read<NotesBloc>().add(
                RefreshNotesForStudent(
                  classId: widget.student.classId,
                  subjectIds: widget.student.subjectIds,
                ),
              );
            }
          },

          child: RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<NotesBloc>();
              bloc.add(
                RefreshNotesForStudent(
                  classId: widget.student.classId,
                  subjectIds: widget.student.subjectIds,
                ),
              );

              await bloc.stream.firstWhere(
                (state) => state is NotesLoaded || state is NotesLoadingError,
              );
            },
            child: BlocBuilder<SubjectBloc, SubjectState>(
              builder: (context, state) {
                if (state is SubjectsLoading) {
                  return CustomWidgets.customLoader();
                }

                List<Subject> subjects = (state is SubjectLoaded)
                    ? state.subjects
                    : [];

                return BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) {
                    if (state is NotesLoading || state is DownloadNoteSuccess) {
                      return CustomWidgets.customLoader();
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
                        itemCount: notes.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == notes.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: CustomWidgets.customLoader(),
                            );
                          }

                          final note = notes[index];

                          final isDownloaded = note.isDownloaded;

                          final sub = subjects.firstWhereOrNull(
                            (s) => s.id == notes[index].ownerId,
                          );

                          final isDownloading =
                              state.downloadProgress.containsKey(note.id!) &&
                              !isDownloaded;

                          final progress = state.downloadProgress[note.id!];

                          return CustomWidgets.studentNotesCard(
                            note: note,
                            subjectName: (sub == null) ? '' : sub.name,

                            onDownload: () => context.read<NotesBloc>().add(
                              DownloadNote(note: note),
                            ),

                            isDownloaded: isDownloaded,
                            downlaoding: isDownloading,
                            progress: (isDownloading) ? progress : null,
                          );
                        },
                      );
                    }
                    return CustomWidgets.customScrollableText(
                      context,
                      'Error occured :(\nSwipe down to refresh.',
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
