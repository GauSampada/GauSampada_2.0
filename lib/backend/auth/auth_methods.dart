import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gausampada/backend/enums/user_type.dart';
import 'package:gausampada/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gausampada/backend/models/user_model.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Signup with Email
  Future<String> handleSignUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required UserType userType,
    String photoURL = "",
  }) async {
    String res = "";
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;
      await prefs.setString('user_id', user.uid);
      UserModel data = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          phonenumber: phoneNumber,
          photoURL: photoURL,
          userType: userType);
      await firestore.collection('users').doc(user.uid).set(data.toMap());
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else if (e.code == "invalid-email") {
        res = "Email is badly formatted.";
      } else {
        res = e.message.toString();
      }
    } catch (e) {
      res = "Error creating user: ${e.toString()}";
    }
    return res;
  }

  // Login with Email
  Future<String> handleLoginWithEmail({
    required String email,
    required String password,
  }) async {
    String res = "";
    try {
      // await FirebaseAppCheck.instance.activate();
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User? user = result.user;
      await prefs.setString('user_id', user?.uid ?? "id----");
      if (user != null) {
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Incorrect password.';
      } else {
        res = e.message.toString();
      }
    } catch (e) {
      res = "Error signing in: ${e.toString()}";
    }
    return res;
  }

  // Signup with Google
  Future<Map<String, dynamic>> handleSignUpWithGoogle({
    required UserType userType,
  }) async {
    try {
      print("📥 Starting Google Sign-In...");
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print("⚠️ Google Sign-In aborted by user");
        return {"res": "Google sign-in aborted.", "user": null};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User user = userCredential.user!;
      print("✅ Google Sign-In successful for user: ${user.uid}");

      await prefs.setString('user_id', user.uid);

      final DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();
      UserModel data;

      if (!userDoc.exists) {
        print("📝 Creating new user document in Firestore...");
        data = UserModel(
          uid: user.uid,
          name: user.displayName ?? "Unknown",
          email: user.email ?? "No email",
          phonenumber: user.phoneNumber ?? "",
          photoURL: user.photoURL ?? "",
          userType: userType,
          location: '',
        );
        await firestore.collection('users').doc(user.uid).set(data.toMap());
        print("✅ New user document created");
      } else {
        print("📖 Existing user found, updating last sign-in...");
        data = UserModel.fromSnapshot(userDoc);
        await firestore.collection('users').doc(user.uid).update({
          'lastSignIn': FieldValue.serverTimestamp(),
        });
      }

      return {"res": "success", "user": data};
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'An account already exists with a different sign-in method.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid Google credentials.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not enabled.';
          break;
        default:
          errorMessage = 'Error signing in with Google: ${e.message}';
      }
      print('❌ FirebaseAuthException: $errorMessage');
      return {"res": errorMessage, "user": null};
    } catch (e) {
      final errorMessage = "Error signing in with Google: ${e.toString()}";
      print('❌ Unexpected Error: $errorMessage');
      return {"res": errorMessage, "user": null};
    }
  }

  // Forgot Password
  Future<String> resetPassword(String email) async {
    String res = '';
    try {
      await auth.sendPasswordResetEmail(email: email);
      res = 'Password Reset Email Sent to $email';
    } on FirebaseAuthException catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Save Doctor Details
  Future<String> saveDoctorDetails({
    required String uid,
    required String specialization,
    required int yearsOfExperience,
    required List<String> availability,
    required String qualification,
    required int consultationFee,
  }) async {
    try {
      final doctorDetails = {
        'specialization': specialization,
        'yearsOfExperience': yearsOfExperience,
        'availability': availability,
        'qualification': qualification,
        'consultationFee': consultationFee,
      };
      await firestore.collection('users').doc(uid).update({
        'doctorDetails': doctorDetails,
      });
      return "success";
    } catch (e) {
      return "Error saving doctor details: $e";
    }
  }

  // Logout
  Future<String> logout() async {
    try {
      print("📴 Starting logout...");
      await GoogleSignIn().signOut();
      await auth.signOut();
      await prefs.clear(); // Clear all SharedPreferences data
      print("✅ Logout successful, all local data cleared");
      return "success";
    } catch (e) {
      final errorMessage = "Error during logout: ${e.toString()}";
      print('❌ Logout Error: $errorMessage');
      return errorMessage;
    }
  }
}
