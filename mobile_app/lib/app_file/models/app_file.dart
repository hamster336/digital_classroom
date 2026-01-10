import 'package:mobile_app/shared/required_enums.dart';

class AppFile {
  final String id;
  final String uploaderId;
  final String filePath;
  final String fileName;
  final FileType fileType;
  final int fileSize;
  final DateTime createdAt;

  AppFile({
    required this.id,
    required this.uploaderId,
    required this.filePath,
    required this.fileName,
    required this.fileType, 
    required this.fileSize,
    required this.createdAt, 
  });
}
