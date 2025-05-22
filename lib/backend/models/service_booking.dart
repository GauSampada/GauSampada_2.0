import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String doctorId;
  final String farmerId;
  final String doctorName;
  final String farmerName;
  final DateTime appointmentDate;
  final String status; // 'scheduled', 'completed', 'cancelled'
  final String notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.farmerId,
    required this.doctorName,
    required this.farmerName,
    required this.appointmentDate,
    required this.status,
    this.notes = '',
    required this.createdAt,
  });

  // Convert from Map (Firebase) to Appointment object
  factory Appointment.fromMap(Map<String, dynamic> map, String docId) {
    return Appointment(
      id: docId,
      doctorId: map['doctorId'] ?? '',
      farmerId: map['farmerId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      farmerName: map['farmerName'] ?? '',
      appointmentDate: (map['appointmentDate'] as Timestamp).toDate(),
      status: map['status'] ?? 'scheduled',
      notes: map['notes'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert from Appointment object to Map (Firebase)
  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'farmerId': farmerId,
      'doctorName': doctorName,
      'farmerName': farmerName,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
