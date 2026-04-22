import 'dart:convert';
import 'package:http/http.dart' as http;

class DyslexiaService {
  static const String baseUrl = "https://your-app.up.railway.app";

  static Future<Map<String, dynamic>> analyzeAudio({
    required String filePath,
    required String reference,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/dyslexia/analyze-audio"),
    );

    request.fields['reference_text'] = reference;
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    var response = await request.send();
    var resBody = await response.stream.bytesToString();

    return jsonDecode(resBody);
  }
}