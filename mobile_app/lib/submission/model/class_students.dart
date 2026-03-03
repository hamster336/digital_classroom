class ClassStudents {
  final String id;
  final String name;
  final String email;
  final String rollNumber;
  final List<String> subjectIds;
  final String classId;

  ClassStudents({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.subjectIds,
    required this.classId, required this.email,
  });

  factory ClassStudents.fromMap(Map<String, dynamic> map) {
    return ClassStudents(
      id: map['id'],
      name: map['full_name'],
      email: map['email'],
      rollNumber: map['roll_number'],
      subjectIds: List<String>.from(map['subject_ids']),
      classId: map['class_id'],
    );
  }
}
