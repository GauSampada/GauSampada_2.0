// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gausampada/backend/models/service_booking.dart';
import '../models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user id
  String? get currentUserId => _auth.currentUser?.uid;

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    if (currentUserId == null) return null;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUserId).get();
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Get all doctors
  Future<List<UserModel>> getAllDoctors() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('userType', isEqualTo: 'doctor')
          .get();
      print("all users: $querySnapshot");
      return querySnapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error getting doctors: $e');
      return [];
    }
  }

  // Get appointments for current user (either doctor or farmer)
  Future<List<Appointment>> getCurrentAppointments(String userType) async {
    if (currentUserId == null) return [];

    try {
      Query query = _firestore
          .collection('appointments')
          .where(userType == 'farmer' ? 'farmerId' : 'doctorId',
              isEqualTo: currentUserId)
          .where('status', isEqualTo: 'scheduled')
          .orderBy('appointmentDate');

      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) =>
              Appointment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting current appointments: $e');
      return [];
    }
  }

  // Get previous appointments for current user (either doctor or farmer)
  Future<List<Appointment>> getPreviousAppointments(String userType) async {
    if (currentUserId == null) return [];

    try {
      Query query = _firestore
          .collection('appointments')
          .where(userType == 'farmer' ? 'farmerId' : 'doctorId',
              isEqualTo: currentUserId)
          .where('status', whereIn: ['completed', 'cancelled']).orderBy(
              'appointmentDate',
              descending: true);

      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) =>
              Appointment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting previous appointments: $e');
      return [];
    }
  }

  // Create a new appointment
  Future<bool> createAppointment({
    required String doctorId,
    required String doctorName,
    required DateTime appointmentDate,
    String notes = '',
  }) async {
    if (currentUserId == null) return false;

    try {
      // Get farmer details
      DocumentSnapshot farmerDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      if (!farmerDoc.exists) return false;

      String farmerName =
          (farmerDoc.data() as Map<String, dynamic>)['name'] ?? '';

      // Create appointment
      await _firestore.collection('appointments').add({
        'doctorId': doctorId,
        'farmerId': currentUserId,
        'doctorName': doctorName,
        'farmerName': farmerName,
        'appointmentDate': Timestamp.fromDate(appointmentDate),
        'status': 'scheduled',
        'notes': notes,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });

      return true;
    } catch (e) {
      print('Error creating appointment: $e');
      return false;
    }
  }

  // Update appointment status
  Future<bool> updateAppointmentStatus(
      String appointmentId, String status) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
      });
      return true;
    } catch (e) {
      print('Error updating appointment status: $e');
      return false;
    }
  }
}
