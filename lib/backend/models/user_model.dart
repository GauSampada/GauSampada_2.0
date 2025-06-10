import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gausampada/backend/enums/user_type.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phonenumber;
  final String? photoURL;
  final String? location;
  final UserType userType;
  final Map<String, dynamic>? doctorDetails;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phonenumber,
    this.photoURL =
        "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg?semt=ais_hybrid&w=740",
    this.location = "Bhimavaram",
    required this.userType,
    this.doctorDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phonenumber': phonenumber,
      'photoURL': photoURL,
      'location': location,
      'userType': userType.name,
      'doctorDetails': doctorDetails,
    };
  }

  static UserModel fromSnapshot(DocumentSnapshot documentSnapshot) {
    var map = documentSnapshot.data() as Map<String, dynamic>?;

    if (map == null) {
      throw Exception("Document snapshot data is null");
    }

    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phonenumber: map['phonenumber'] ?? '',
      photoURL: map['photoURL'] ?? '',
      location: map['location'] ?? '',
      userType: fromStringToEnum(map['userType'] as String),
      doctorDetails: map['doctorDetails'] as Map<String, dynamic>?,
    );
  }

  static UserType fromStringToEnum(String userType) {
    return UserType.values.firstWhere(
      (type) => type.name.toLowerCase() == userType.toLowerCase(),
      orElse: () => UserType.farmer,
    );
  }
}
