import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PublicDirectory {
  static Future<String?> getPublicDirectoryPath() async {
    try {
      if (Platform.isAndroid) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          
          List<String> folders = directory.path.split('/');
          String rootPath = '';
          for (int i = 1; i < folders.length; i++) {
            if (folders[i] == 'Android') break;
            rootPath += '/${folders[i]}';
          }
          return '$rootPath/Download';
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          return directory.path;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}