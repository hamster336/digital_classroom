class Classroom {
  final String id;
  final String name;
  final String? section;
  final String? faculty;
  final int startYear;
  final int endYear;
  final DateTime createdAt;
  final bool isActive;

  Classroom({
    required this.id,
    required this.name,
    this.section,
    this.faculty,
    required this.startYear,
    required this.endYear,
    required this.createdAt,
    required this.isActive,
  });
}
