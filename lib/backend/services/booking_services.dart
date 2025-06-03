import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/models/appoinments_chat_model.dart';
import 'package:gausampada/backend/models/service_booking.dart';
import 'package:gausampada/backend/models/user_model.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudinaryPublic _cloudinary =
      CloudinaryPublic('dvd0mdeon', 'GauSampadha_Appoinmets_Data');

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromSnapshot(doc);
  }

  Future<List<UserModel>> getAllDoctors() async {
    final snapshot = await _firestore
        .collection('users')
        .where('userType', isEqualTo: 'doctor')
        .get();
    return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
  }

  Future<List<Appointment>> getCurrentAppointments(String userType) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    QuerySnapshot snapshot;
    if (userType == 'farmer') {
      snapshot = await _firestore
          .collection('appointments')
          .where('farmerId', isEqualTo: user.uid)
          .where('status', whereIn: ['pending', 'approved', 'scheduled']).get();
    } else {
      snapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: user.uid)
          .where('status', whereIn: ['pending', 'approved', 'scheduled']).get();
    }

    return snapshot.docs
        .map((doc) =>
            Appointment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<Appointment>> getPreviousAppointments(String userType) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    QuerySnapshot snapshot;
    if (userType == 'farmer') {
      snapshot = await _firestore
          .collection('appointments')
          .where('farmerId', isEqualTo: user.uid)
          .where('status', whereIn: ['completed', 'cancelled']).get();
    } else {
      snapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: user.uid)
          .where('status', whereIn: ['completed', 'cancelled']).get();
    }

    return snapshot.docs
        .map((doc) =>
            Appointment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Stream<QuerySnapshot> streamAppointments({
    required String userId,
    required UserType userType,
    required List<String> statusFilter,
  }) {
    return _firestore
        .collection('appointments')
        .where(
          userType == UserType.farmer ? 'farmerId' : 'doctorId',
          isEqualTo: userId,
        )
        .where('status', whereIn: statusFilter)
        .snapshots();
  }

  Future<bool> createAppointment({
    required String doctorId,
    required String doctorName,
    required DateTime appointmentDate,
    String notes = '',
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return false;

      final farmerName = userDoc.data()!['name'] ?? '';

      // Generate deterministic chatId by sorting farmerId and doctorId
      final List<String> participantIds = [user.uid, doctorId]..sort();
      final String chatId = '${participantIds[0]}_${participantIds[1]}';

      // Check if a chat already exists for this pair
      final existingChat =
          await _firestore.collection('chats').doc(chatId).get();
      if (!existingChat.exists) {
        // Create new chat if none exists
        await _firestore.collection('chats').doc(chatId).set({
          'participants': [user.uid, doctorId],
          'createdAt': Timestamp.fromDate(DateTime.now()),
          'lastMessage': '',
          'lastMessageTimestamp': Timestamp.fromDate(DateTime.now()),
        });
      }

      final appointment = Appointment(
        id: _firestore.collection('appointments').doc().id,
        doctorId: doctorId,
        farmerId: user.uid,
        doctorName: doctorName,
        farmerName: farmerName,
        appointmentDate: appointmentDate,
        status: 'pending',
        notes: notes,
        createdAt: DateTime.now(),
        chatId: chatId,
      );

      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(appointment.toMap());

      return true;
    } catch (e) {
      print('Error creating appointment: $e');
      return false;
    }
  }

  Future<bool> updateAppointmentStatus(
      String appointmentId, String status) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': status});
      return true;
    } catch (e) {
      print('Error updating appointment status: $e');
      return false;
    }
  }

  Stream<QuerySnapshot> getChatMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<List<AppoinmentsChatModel>> getChatMessages(String chatId) async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AppoinmentsChatModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    required MessageType type,
  }) async {
    try {
      final message = AppoinmentsChatModel(
        id: _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc()
            .id,
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        content: content,
        type: type,
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toMap());

      // Update last message in chat for sorting/display purposes
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': type == MessageType.text
            ? content
            : '[${type.toString().split('.').last}]',
        'lastMessageTimestamp': Timestamp.fromDate(DateTime.now()),
      });

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  Future<void> markMessageAsRead(String chatId, String messageId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking message as read: $e');
    }
  }

  Future<String?> uploadMedia(String path, MessageType type) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          path,
          resourceType: type == MessageType.image
              ? CloudinaryResourceType.Image
              : CloudinaryResourceType.Video,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading media to Cloudinary: $e');
      return null;
    }
  }
}
