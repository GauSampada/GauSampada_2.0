import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/models/user_model.dart';
import 'package:uuid/uuid.dart';

Future<void> addDoctorsToFirestore(BuildContext context) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  const Uuid uuid = Uuid();

  // List of doctors with required fields for details screen
  final List<Map<String, dynamic>> doctorsData = [
    {
      'uid': uuid.v4(),
      'name': 'Dr. John Smith',
      'email': 'john.smith@example.com',
      'phonenumber': '+919876543210',
      'photoURL': 'https://via.placeholder.com/150',
      'location': 'Hyderabad',
      'userType': UserType.doctor,
      'doctorDetails': {
        'specialization': 'Veterinary Medicine',
        'yearsOfExperience': 10,
        'availability': ['Monday', 'Wednesday', 'Friday'],
        'qualification': 'MVSc',
        'consultationFee': 500,
      },
    },
    {
      'uid': uuid.v4(),
      'name': 'Dr. Priya Sharma',
      'email': 'priya.sharma@example.com',
      'phonenumber': '+919876543211',
      'photoURL': 'https://via.placeholder.com/150',
      'location': 'Bhimavaram',
      'userType': UserType.doctor,
      'doctorDetails': {
        'specialization': 'Animal Nutrition',
        'yearsOfExperience': 7,
        'availability': ['Tuesday', 'Thursday', 'Saturday'],
        'qualification': 'BVSc & AH',
        'consultationFee': 400,
      },
    },
    {
      'uid': uuid.v4(),
      'name': 'Dr. Anil Kumar',
      'email': 'anil.kumar@example.com',
      'phonenumber': '+919876543212',
      'photoURL': 'https://via.placeholder.com/150',
      'location': 'Vijayawada',
      'userType': UserType.doctor,
      'doctorDetails': {
        'specialization': 'Livestock Surgery',
        'yearsOfExperience': 12,
        'availability': ['Monday', 'Thursday', 'Sunday'],
        'qualification': 'MVSc (Surgery)',
        'consultationFee': 600,
      },
    },
  ];

  try {
    // Add each doctor to Firestore
    for (var doctorData in doctorsData) {
      final userModel = UserModel(
        uid: doctorData['uid'],
        name: doctorData['name'],
        email: doctorData['email'],
        phonenumber: doctorData['phonenumber'],
        photoURL: doctorData['photoURL'],
        location: doctorData['location'],
        userType: doctorData['userType'],
        doctorDetails: doctorData['doctorDetails'],
      );

      await firestore
          .collection('users')
          .doc(doctorData['uid'])
          .set(userModel.toMap());
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Doctors added to Firestore successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding doctors: $e')),
    );
  }
}
