import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/classroom/bloc/classroom_bloc.dart';
import 'package:mobile_app/shared/custom_widgets.dart';

class ClassroomGate extends StatelessWidget {
  final Widget Function(String classId) destinationBuilder;
  const ClassroomGate({super.key, required this.destinationBuilder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Select a class')),
      body: BlocBuilder<ClassroomBloc, ClassroomState>(
        builder: (context, state) {
          if (state is! ClassesLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final classes = state.classes;

          if (classes.isEmpty) {
            return const Center(
              child: Text(
                'No classes available',
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final cls = classes[index];
              return CustomWidgets.classCards(
                cls,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => destinationBuilder(cls.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
