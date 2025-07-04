import 'package:http/http.dart' as http;
import 'dart:convert';

class RasaService {
  static const String _baseUrl = "http://10.0.2.2:5005"; // For Android emulator

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/webhooks/rest/webhook"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sender': 'user1', 'message': message}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.isNotEmpty ? data[0]['text'] : "I didn't understand that.";
      } else {
        return "Error: Could not connect to chatbot.";
      }
    } catch (e) {
      return "Error: Failed to fetch response.";
    }
  }
}