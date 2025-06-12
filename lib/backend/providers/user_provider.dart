import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/backend/models/user_model.dart';
import 'package:gausampada/const/profile_image_picker.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _user;
  UserModel get user => _user!;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  File? _profileImage;
  File? get profileImage => _profileImage;

  String? _photoURL;
  String? get photoURL => _photoURL;

  Future<void> fetchUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (uid.isEmpty) {
      print("⚠️ No user ID available, skipping fetch");
      _user = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      print("📥 Fetching user data for UID: $uid");
      final snap = await _firestore.collection('users').doc(uid).get();
      if (snap.exists) {
        _user = UserModel.fromSnapshot(snap);
        _photoURL = _user?.photoURL;
        print(
            "✅ User data fetched: ${_user?.name}, ${_user?.email}, ${_user?.userType}, ${_user?.photoURL}");
      } else {
        print("⚠️ No user document found for UID: $uid");
        _user = null;
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectImage(ImageSource source) async {
    _isLoading = true;
    notifyListeners();
    try {
      //print("📷 Selecting image...");
      File? image = await CustomImagePicker(isReport: false).pickImage(source);
      _profileImage = image;
      notifyListeners();

      if (image != null) {
        await generateProfileUrl();
      }
    } catch (e) {
      //print("❌ Error selecting image: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateProfileUrl() async {
    try {
      //print("⏳ Uploading image...");
      String? imageUrl = await CustomImagePicker(isReport: false)
          .uploadToCloudinary(imageFile: profileImage);
      //print("✅ Image uploaded to Cloudinary successfully: $imageUrl");

      if (imageUrl != null && imageUrl.isNotEmpty) {
        _photoURL = imageUrl;
        await _firestore.collection('users').doc(uid).update({
          'photoURL': imageUrl,
        });
        await fetchUser();
        //print("✅ Photo URL updated in Firestore");
      }
    } catch (e) {
      //print("❌ Error uploading image: $e");
    }
  }

  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  Future<String> updateUserDetails({
    required String name,
    required String email,
    required String phonenumber,
    required String location,
    required UserType userType,
    Map<String, dynamic>? doctorDetails,
  }) async {
    String res = '';

    try {
      final updatedUser = UserModel(
        uid: uid,
        name: name,
        email: email,
        phonenumber: phonenumber,
        photoURL: _photoURL ?? user.photoURL ?? "",
        location: location,
        userType: userType,
        doctorDetails: doctorDetails,
      );

      _isUpdate = true;
      notifyListeners();
      //print("✍️ Updating user details in Firestore...");

      await _firestore.collection('users').doc(uid).update(updatedUser.toMap());
      _isUpdate = false;
      res = 'update';
      //print("✅ User details and photo URL updated successfully!");

      await fetchUser();
      notifyListeners();
    } catch (error) {
      res = error.toString();
      //print("❌ Error updating user details: $error");
      _isUpdate = false;
      notifyListeners();
      throw Exception(error.toString());
    }

    return res;
  }

  void clearUserData() {
    _user = null;
    _photoURL = null;
    _profileImage = null;
    _isLoading = true;
    _isUpdate = false;
    print("🧹 Cleared cached user data");
    notifyListeners();
  }
}
