import 'package:mobile_app/shared/required_enums.dart';

class AppFile {
  final String? id;
  final String uploaderId;
  final String classId;
  final String
  ownerId; // subjectId for notes, and assignmentId for assignment submissions
  final FileContext context;

  final String filePath;
  final String fileName;
  final String mimeType;
  final int fileSize;
  final DateTime createdAt;
  double? score;
  String? remarks;

  bool isDownloaded;

  AppFile({
    this.id,
    required this.uploaderId,
    required this.classId,
    required this.ownerId,
    required this.context,
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
    required this.createdAt,
    this.score,
    this.remarks,
    this.isDownloaded = false,
  });

  Map<String, dynamic> toMap({String? id}) {
    final map = {
      'uploader_id': uploaderId,
      'class_id': classId,
      'owner_id': ownerId,
      'file_context': setFileContext(context),
      'file_path': filePath,
      'file_name': fileName,
      'mime_type': mimeType,
      'file_size': fileSize,
      'created_at': createdAt.toUtc().toIso8601String(),
    };

    if (id != null) map['id'] = id;

    return map;
  }

  factory AppFile.fromMap(Map<String, dynamic> map) {
    return AppFile(
      id: map['id'],
      uploaderId: map['uploader_id'],
      classId: map['class_id'],
      ownerId: map['owner_id'],
      context: getFileContext(map['file_context']),
      filePath: map['file_path'],
      fileName: map['file_name'],
      mimeType: map['mime_type'],
      fileSize: map['file_size'],
      createdAt: DateTime.parse(map['created_at']).toLocal(),
      score: map['score'],
      remarks: map['remarks'],
    );
  }

  static FileContext getFileContext(String con) {
    if (con == 'notes') return FileContext.notes;
    return FileContext.assignments;
  }

  static String setFileContext(FileContext con) {
    if (con == FileContext.notes) return 'notes';
    return 'assignment';
  }

  AppFile copyWith({
    required String filePath,
    required String fileName,
    required String mimeType,
    required int fileSize,
    required DateTime createdAt,
    bool? isDownloaded,
  }) {
    return AppFile(
      id: id,
      uploaderId: uploaderId,
      classId: classId,
      ownerId: ownerId,
      context: context,
      filePath: filePath,
      fileName: fileName,
      mimeType: mimeType,
      fileSize: fileSize,
      createdAt: createdAt,
      isDownloaded: isDownloaded ?? this.isDownloaded
    );
  }
}
