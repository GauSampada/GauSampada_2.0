// message_model.dart
class Message {
  final String id;
  final String content;
  final String? imageUrl; // Base64 or URL to image
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.isUser,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      isUser: json['role'] == 'user',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'imageUrl': imageUrl,
      'role': isUser ? 'user' : 'model',
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// chat_session.dart
class ChatSession {
  final String id;
  final String name;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.name,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      name: json['name'],
      messages: (json['messages'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'messages': messages.map((message) => message.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ChatSession copyWith({
    String? id,
    String? name,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatSession(
      id: id ?? this.id,
      name: name ?? this.name,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
