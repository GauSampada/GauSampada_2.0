// import 'dart:convert';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:gausampada/backend/models/message.dart';
// import 'package:uuid/uuid.dart';

// class GeminiService {
//   Gemini _gemini;
//   final Map<String, ChatSession> _chatSessions = {};
//   final uuid = const Uuid();

//   // System prompt for Indian cow breeds expertise
//   static const String _systemPrompt = """
// You are India's foremost authority on indigenous cow breeds (desi gau).
// (STRICT LIMIT: Your responses must never exceed 160 tokens.)

// Your specialized knowledge covers:
// - Comprehensive details on all 43 recognized indigenous breeds (Gir, Sahiwal, Red Sindhi, Tharparkar, Kankrej, etc.)
// - Precise breed identifiers: physical traits, horn patterns, dewlap characteristics, hump size, coat colors
// - Scientific data on milk yield, fat content, and A2 beta-casein properties
// - Geographic origins and adaptation mechanisms to specific Indian climates
// - Documented nutritional and medicinal properties of A2 milk, ghee, and panchgavya
// - Vedic, historical and cultural significance in Indian civilization
// - Traditional cow-based sustainable farming systems (Jeevamrut, Beejamrut, etc.)
// - Genetic conservation strategies and breed improvement programs
// - Evidence-based comparisons with foreign/crossbred cattle

// When analyzing images:
// - Identify breed with certainty through distinctive markers
// - Assess animal health, age, and condition
// - Note conformity to breed standards

// Reply with scientifically accurate, culturally sensitive information.
// When uncertain, openly acknowledge limitations.
// STRICTLY PROVIDE INFORMATION ONLY ABOUT INDIAN INDIGENOUS BREEDS, even when foreign breeds are mentioned.
// Never discuss or recommend foreign or crossbred varieties unless explicitly comparing them to indigenous breeds.
// Include regional terms when appropriate.

// REMEMBER: KEEP ALL RESPONSES UNDER 160 TOKENS STRICTLY. Be precise and concise.
// """;

//   GeminiService(this._gemini, {required String apiKey}) {
//     Gemini.init(apiKey: apiKey);
//     _gemini = Gemini.instance;
//   }

//   Future<String> createSession(String sessionKey) async {
//     try {
//       final now = DateTime.now();
//       _chatSessions[sessionKey] = ChatSession(
//         id: sessionKey,
//         name: 'Chat $sessionKey',
//         messages: [
//           Message(
//             id: uuid.v4(),
//             content: _systemPrompt,
//             isUser: true,
//             timestamp: now,
//           ),
//         ],
//         createdAt: now,
//         updatedAt: now,
//       );
//       return sessionKey;
//     } catch (e) {
//       throw Exception('Failed to create Gemini session: $e');
//     }
//   }

//   Future<String> sendMessage(String sessionKey, String message,
//       {String? imageBase64}) async {
//     try {
//       if (!_chatSessions.containsKey(sessionKey)) {
//         throw Exception('Session not found');
//       }

//       final session = _chatSessions[sessionKey]!;
//       final now = DateTime.now();

//       // Build parts list, including history and system prompt
//       final parts = <Part>[];

//       // Add system prompt as the first part (if needed by the API)
//       parts.add(TextPart(_systemPrompt));

//       // Add conversation history
//       for (var msg
//           in session.messages.where((m) => m.content != _systemPrompt)) {
//         parts.add(
//             TextPart('${msg.isUser ? "User" : "Assistant"}: ${msg.content}'));
//       }

//       // Add current user message
//       final userMessage = Message(
//         id: uuid.v4(),
//         content: message,
//         isUser: true,
//         timestamp: now,
//       );
//       session.messages.add(userMessage);
//       parts.add(TextPart('User: $message'));

//       // Add image if provided
//       if (imageBase64 != null) {
//         final imageBytes = base64Decode(imageBase64);
//         final fileData = FileDataPart(
//           mimeType:
//               'image/jpeg', // Adjust MIME type as needed (e.g., 'image/png')
//           data: imageBytes,
//         );
//         // Add FilePart with FileDataPart
//         parts.add(FilePart(fileData: fileData));

//         // Add image message to session
//         session.messages.add(Message(
//           id: uuid.v4(),
//           content: 'image',
//           isUser: true,
//           timestamp: now,
//         ));
//       }

//       // Send request to Gemini
//       final response = await _gemini.prompt(
//         parts: parts,
//       );

//       // Extract text from response (adjust based on actual Candidates structure)
//       final responseText = response?.content?.parts?.first.toString() ??
//           "No response text received from Gemini";

//       // Add model response to session
//       final modelMessage = Message(
//         id: uuid.v4(),
//         content: responseText,
//         isUser: false,
//         timestamp: now,
//       );
//       session.messages.add(modelMessage);

//       // Update session timestamp
//       _chatSessions[sessionKey] = ChatSession(
//         id: session.id,
//         name: session.name,
//         messages: session.messages,
//         createdAt: session.createdAt,
//         updatedAt: now,
//       );

//       return responseText;
//     } catch (e) {
//       throw Exception('Failed to send message: $e');
//     }
//   }

//   Future<List<Map<String, dynamic>>> getHistory(String sessionKey) async {
//     try {
//       if (!_chatSessions.containsKey(sessionKey)) {
//         throw Exception('Session not found');
//       }

//       final session = _chatSessions[sessionKey]!;
//       return session.messages
//           .where((message) => message.content != _systemPrompt)
//           .map((message) => {
//                 'role': message.isUser ? 'user' : 'model',
//                 'content': message.content,
//               })
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to get history: $e');
//     }
//   }
// }
