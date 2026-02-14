import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:mime/mime.dart';
import 'package:mobile_app/app_file/models/app_file.dart';
import 'package:mobile_app/shared/required_enums.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesServices {
  final SupabaseClient client;

  NotesServices({required this.client});

  // for student
  Future<List<Map<String, dynamic>>> fetchStudentNotes({
    required String classId,
    required List<String> subjectIds,
    required int from,
    required int limit,
  }) async {
    final to = from + limit - 1;

    return await client
        .from('app_files')
        .select()
        .eq('class_id', classId)
        .eq('file_context', 'notes')
        .inFilter('subject_id', subjectIds)
        .order('created_at', ascending: false)
        .range(from, to);
  }

  // for teacher
  Future<List<Map<String, dynamic>>> fetchTeacherNotes({
    required String classId,
    required String teacherId,
    required int from,
    required int limit,
  }) async {
    final to = from + limit - 1;

    return await client
        .from('app_files')
        .select()
        .eq('class_id', classId)
        .eq('uploader_id', teacherId)
        .eq('file_context', 'notes')
        .order('created_at', ascending: false)
        .range(from, to);
  }

  // upload note to db
  Future<void> addNotes({
    required List<PlatformFile> files,
    required String teacherId,
    required String classId,
    required String subjectId,
  }) async {
    await Future.wait(
      files.map((file) async {
        final path = file.path!;
        final bytes = await File(path).readAsBytes();

        final mimeType =
            lookupMimeType(path, headerBytes: bytes) ??
            'application/octet_stream';

        final storagePath = '$classId/${file.name}';

        // first upload the file to storage
        await client.storage
            .from('classroom_materials')
            .upload(storagePath, File(path));

        // create domain object for the file
        final note = AppFile(
          uploaderId: teacherId,
          classId: classId,
          subjectId: subjectId,
          context: FileContext.notes,
          fileName: file.name,
          filePath: storagePath,
          mimeType: mimeType,
          fileSize: file.size,
          createdAt: DateTime.now(),
        );

        await client.from('app_files').insert(note.toMap());
      }),
    );
  }

  // delete note
  Future<void> deleteNote(String noteId, String filePath) async {
    // first delete the file from storage
    await client.storage.from('classroom_materials').remove([filePath]);

    // delete the row from the table
    await client.from('app_files').delete().eq('id', noteId);
  }

  // download note
  Future<void> downloadNote(AppFile note) async {
    try {
      final bytes = await client.storage
          .from('classroom_materials')
          .download(note.filePath);

      // final directory = await getDownloadsDirectory();
      // final file = File('${directory!.path}/${note.fileName}');

      // await file.writeAsBytes(bytes);

      await FileSaver.instance.saveFile(
        name: note.fileName,
        bytes: bytes,
        mimeType: .other,
      );
    } catch (e) {
      throw Exception(e.toString);
    }
  }
}
