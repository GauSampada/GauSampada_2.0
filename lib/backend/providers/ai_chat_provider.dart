// chat_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gausampada/backend/models/message.dart';
import 'package:gausampada/backend/services/chat_services.dart';
import 'package:gausampada/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class BreedChatProvider extends ChangeNotifier {
  late ChatServices _chatServices;
  BreedChatProvider() {
    _init();
  }
  _init() async {
    _chatServices = ChatServices(userId: prefs.getString('user_id') ?? "id__");
  }

  final uuid = const Uuid();

  String _currentSessionId = '';
  final List<ChatSession> _sessions = [];
  List<Message> _currentMessages = [];
  bool _isLoading = false;

  List<Message> get messages => _currentMessages;
  bool get isLoading => _isLoading;
  List<ChatSession> get sessions => _sessions;
  String get currentSessionId => _currentSessionId;

  // Initialize a new chat session
  Future<void> createNewChat() async {
    try {
      _isLoading = true;
      notifyListeners();

      final sessionId = await _chatServices.createNewChat();
      _currentSessionId = sessionId;
      _currentMessages = [];

      // Create a new session
      final newSession = ChatSession(
        id: sessionId,
        name: 'Chat ${_sessions.length + 1}',
        messages: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _sessions.add(newSession);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Switch to existing chat session
  Future<void> switchChat(String sessionId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentSessionId = sessionId;
      final history = await _chatServices.getChatHistory(sessionId);
      _currentMessages = history;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Send text message
  Future<void> sendTextMessage(String content) async {
    if (content.trim().isEmpty) return;

    if (_currentSessionId.isEmpty) {
      await createNewChat();
    }

    try {
      // Add user message to UI immediately
      final userMessage = Message(
        id: uuid.v4(),
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
      );

      _currentMessages.add(userMessage);
      _updateSessionMessages();
      notifyListeners();

      _isLoading = true;
      notifyListeners();

      // Send to API
      final response = await _chatServices.sendMessage(
        sessionId: _currentSessionId,
        message: content,
      );

      // Add response to UI
      final botMessage = Message(
        id: uuid.v4(),
        content: response['response'],
        isUser: false,
        timestamp: DateTime.now(),
      );

      _currentMessages.add(botMessage);
      _updateSessionMessages();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Send image message
  Future<void> sendImageMessage(File image, [String? caption]) async {
    if (_currentSessionId.isEmpty) {
      await createNewChat();
    }

    try {
      // Convert image to base64
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Create user message with image
      final userMessage = Message(
        id: uuid.v4(),
        content: caption ?? 'Image',
        imageUrl: base64Image,
        isUser: true,
        timestamp: DateTime.now(),
      );

      _currentMessages.add(userMessage);
      _updateSessionMessages();
      notifyListeners();

      _isLoading = true;
      notifyListeners();

      // Send to API
      final response = await _chatServices.sendMessage(
        sessionId: _currentSessionId,
        message: caption ?? 'What breed of cow is in this image?',
        imageBase64: base64Image,
      );

      // Add response to UI
      final botMessage = Message(
        id: uuid.v4(),
        content: response['response'],
        isUser: false,
        timestamp: DateTime.now(),
      );

      _currentMessages.add(botMessage);
      _updateSessionMessages();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery([String? caption]) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await sendImageMessage(File(image.path), caption);
    }
  }

  // Take picture from camera
  Future<void> takePhoto([String? caption]) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      await sendImageMessage(File(image.path), caption);
    }
  }

  // Update session messages
  void _updateSessionMessages() {
    final index =
        _sessions.indexWhere((session) => session.id == _currentSessionId);
    if (index != -1) {
      _sessions[index] = _sessions[index].copyWith(
        messages: _currentMessages,
        updatedAt: DateTime.now(),
      );
    }
  }
}
