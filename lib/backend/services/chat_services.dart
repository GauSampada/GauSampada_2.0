// api_service.dart
import 'dart:convert';
import 'package:gausampada/backend/models/message.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ChatServices {
  // final String baseUrl;
  final uuid = const Uuid();
  final String userId;

  ChatServices({
    // required this.baseUrl,
    required this.userId,
  });
  final String baseUrl = "http://10.0.42.125:5000";
  Future<Map<String, dynamic>> sendMessage({
    required String sessionId,
    required String message,
    String? imageBase64,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/chatBreed'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'session_id': sessionId,
        'message': message,
        'image': imageBase64,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  Future<String> createNewChat() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/new_chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['session_id'];
    } else {
      throw Exception('Failed to create new chat: ${response.body}');
    }
  }

  Future<List<Message>> getChatHistory(String sessionId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/chat_history?user_id=$userId&session_id=$sessionId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final history = data['history'] as List;

      return history.map((message) {
        return Message(
          id: uuid.v4(),
          content: message['content'],
          isUser: message['role'] == 'user',
          timestamp: DateTime.now(),
        );
      }).toList();
    } else {
      throw Exception('Failed to get chat history: ${response.body}');
    }
  }
}
