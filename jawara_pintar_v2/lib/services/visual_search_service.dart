import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VisualSearchService {
  static const String apiUrl =
      "https://rafiody16-flutter-api-integration.hf.space/predict";

  static Future<String?> predictBatik(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (data['status'] == 'success') {
        return data['prediction'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
