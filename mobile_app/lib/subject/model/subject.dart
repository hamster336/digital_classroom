class Subject {
  final String id;
  final String name;
  final String classId;
  final String teacherId;

  Subject({
    required this.id,
    required this.name,
    required this.classId,
    required this.teacherId,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      classId: map['class_id'],
      teacherId: map['teacher_id'],
    );
  }
}
