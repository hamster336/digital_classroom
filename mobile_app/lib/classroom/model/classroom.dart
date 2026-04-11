class Classroom {
  final String id;
  final String name;
  final String? faculty;
  final int startYear;
  final int endYear;
  final DateTime createdAt;
  final int studentCount;
  final bool isActive;

  Classroom({
    required this.id,
    required this.name,
    this.faculty,
    required this.startYear,
    required this.endYear,
    required this.createdAt,
    required this.studentCount,
    required this.isActive,
  });

  factory Classroom.fromMap(Map<String, dynamic> map) {
    return Classroom(
      id: map['id'],
      name: map['name'],
      faculty: map['faculty'] ?? '',
      startYear: (map['start_year']),
      endYear: map['end_year'],
      createdAt: DateTime.parse(map['created_at']).toLocal(),
      studentCount: map['student_count'],
      isActive: map['is_active'],
    );
  }
}
