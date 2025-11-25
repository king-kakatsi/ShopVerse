import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AssetService {
  /// Fetch image from URL and save to local directory
  static Future<String?> fetchImageFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = path.basename(imageUrl);
        final filePath = path.join(directory.path, fileName);
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
    return null;
  }

  /// Delete file from local directory
  static Future<void> deleteFromLocalDir(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}
