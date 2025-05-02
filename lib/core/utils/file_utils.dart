import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtils {
  /// Check if storage permission is granted
  static Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.storage.request();
    return result.isGranted;
  }

  /// Get the app's document directory
  static Future<Directory?> getAppDirectory() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      print('Error getting app directory: $e');
      return null;
    }
  }

  /// Get the app's external storage directory
  static Future<Directory?> getExternalDirectory() async {
    try {
      return await getExternalStorageDirectory();
    } catch (e) {
      print('Error getting external directory: $e');
      return null;
    }
  }

  /// Create a temporary file with the given extension
  static Future<File?> createTempFile(String extension) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.$extension');
      return tempFile;
    } catch (e) {
      print('Error creating temp file: $e');
      return null;
    }
  }
}
