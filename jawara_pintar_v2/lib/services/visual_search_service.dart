import 'dart:io';
// import 'dart:convert';
import 'package:http/http.dart' as http;

class VisualSearchService {
  static const String apiUrl =
      "https://tamadio-batiknitik-classifier-dioandika.hf.space/predict";

  static Future<String?> predictBatik(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Karena server kirim HTML, kita cari teks di antara icon 🎨 dan </div>
        // Contoh isi responseBody: <div class="result"> 🎨 Motif Nitik </div>

        if (responseBody.contains('🎨')) {
          final start =
              responseBody.indexOf('🎨') + 2; // +2 untuk skip emoji dan spasi
          final end = responseBody.indexOf('</div>', start);
          String result = responseBody.substring(start, end).trim();
          return result;
        }
      }
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
