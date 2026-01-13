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
}
