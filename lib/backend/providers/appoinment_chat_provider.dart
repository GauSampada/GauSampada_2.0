import 'package:flutter/material.dart';
import 'package:gausampada/backend/models/appoinments_chat_model.dart';
import 'package:gausampada/backend/services/booking_services.dart';

class AppoinmentChatProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<AppoinmentsChatModel> _messages = [];
  bool _isLoading = false;
  bool _isUploadingMedia = false; // New: Track media upload state
  String _error = '';

  List<AppoinmentsChatModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isUploadingMedia => _isUploadingMedia; // New: Getter
  String get error => _error;

  // Stream for real-time message updates
  Stream<List<AppoinmentsChatModel>> getMessagesStream(String chatId) {
    try {
      return _firebaseService.getChatMessagesStream(chatId).map((snapshot) {
        return snapshot.docs.map((doc) {
          return AppoinmentsChatModel.fromMap(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      _error = 'Failed to stream messages: $e';
      print(_error);
      return Stream.value([]);
    }
  }

  Future<void> loadMessages(String chatId) async {
    _setLoading(true);
    try {
      _messages = await _firebaseService.getChatMessages(chatId);
      _error = '';
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load messages: $e';
      print(_error);
    }
    _setLoading(false);
  }

  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    required MessageType type,
  }) async {
    _setLoading(true);
    bool success = false;
    try {
      success = await _firebaseService.sendMessage(
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        content: content,
        type: type,
      );
      if (success) {
        // Stream will update UI
        _error = '';
      }
    } catch (e) {
      _error = 'Failed to send message: $e';
      print(_error);
    }
    _setLoading(false);
    return success;
  }

  Future<void> markMessageAsRead(String chatId, String messageId) async {
    try {
      await _firebaseService.markMessageAsRead(chatId, messageId);
    } catch (e) {
      _error = 'Failed to mark message as read: $e';
      print(_error);
    }
  }

  Future<String?> uploadMedia(String path, MessageType type) async {
    _isUploadingMedia = true; // New: Set uploading state
    notifyListeners();
    try {
      final url = await _firebaseService.uploadMedia(path, type);
      _error = '';
      return url;
    } catch (e) {
      _error = 'Failed to upload media: $e';
      print(_error);
      return null;
    } finally {
      _isUploadingMedia = false; // New: Reset uploading state
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
