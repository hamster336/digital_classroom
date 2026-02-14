import 'package:mobile_app/shared/required_enums.dart';

class AppFile {
  final String? id;
  final String uploaderId;

  final String classId;
  final String subjectId;
  final FileContext context;

  final String filePath;
  final String fileName;
  final String mimeType;
  final int fileSize;
  final DateTime createdAt;

  AppFile({
    this.id,
    required this.uploaderId,
    required this.classId,
    required this.subjectId,
    required this.context,
    required this.filePath,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uploader_id': uploaderId,
      'class_id': classId,
      'subject_id': subjectId,
      'file_context': setFileContext(context),
      'file_path': filePath,
      'file_name': fileName,
      'mime_type': mimeType,
      'file_size': fileSize,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AppFile.fromMap(Map<String, dynamic> map) {
    return AppFile(
      id: map['id'],
      uploaderId: map['uploader_id'],
      classId: map['class_id'],
      subjectId: map['subject_id'],
      context: getFileContext(map['file_context']),
      filePath: map['file_path'],
      fileName: map['file_name'],
      mimeType: map['mime_type'],
      fileSize: map['file_size'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  static FileContext getFileContext(String con) {
    if (con == 'notes') {
      return FileContext.notes;
    } else {
      return FileContext.assignments;
    }
  }

  static String setFileContext(FileContext con) {
    if (con == FileContext.notes) return 'notes';
    return 'assignment';
  }
}
