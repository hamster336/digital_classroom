class Schedule {
  final String id;
  final String name;
  final String classId;
  final String filePath;
  final DateTime createdAt;

  bool isDownloaded;

  Schedule({
    required this.id,
    required this.name,
    required this.classId,
    required this.filePath,
    required this.createdAt,
    this.isDownloaded = false,
  });

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      name: map['name'],
      classId: map['class_id'],
      filePath: map['file_path'],
      createdAt: DateTime.parse(map['created_at']).toLocal(),
    );
  }
}
