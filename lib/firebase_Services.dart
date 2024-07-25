// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   FirebaseAuthService() {}

//   Future<User?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("Failed to sign in: ${e.message}");
//       return null;
//     } catch (e) {
//       print("Unexpected error during sign in: $e");
//       return null;
//     }
//   }

//   Future<User?> signUpWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("Failed to sign up: ${e.message}");
//       return null;
//     } catch (e) {
//       print("Unexpected error during sign up: $e");
//       return null;
//     }
//   }
// }
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   FirebaseAuthService() {}

//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }
//   Future<User?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("Failed to sign in: ${e.message}");
//       return null;
//     } catch (e) {
//       print("Unexpected error during sign in: $e");
//       return null;
//     }
//   }

//   Future<User?> signUpWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("Failed to sign up: ${e.message}");
//       return null;
//     } catch (e) {
//       print("Unexpected error during sign up: $e");
//       return null;
//     }
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseAuthService {
//   //instance of auth and firestore
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   //get current user
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   //sign in
//   Future<UserCredential> signInWithEmailPassword(String email, password) async {
//     try{
//       //sign user in
//       UserCredential userCredential =
//       await _auth.signInWithEmailAndPassword(
//         email: email, password: password
//         );
//         //save user info in a separate doc

//         _firestore.collection("users").doc(userCredential.user!.uid).set(
//           {
//             'uid': userCredential.user!.uid, 'phoneNo':email,
//           }
//         );
//         return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);

//     }
//   }

//   // sign up
//   Future<UserCredential> signUpWithEmailPassword(String email,password) async{
//     try{
//       //create user
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password);

//         //save user info in a separate doc
//         _firestore.collection("users").doc(userCredential.user!.uid).set(
//           {
//             'uid': userCredential.user!.uid, 'phoneNo':email,
//           }
//         );

//         return userCredential;

//     }on FirebaseAuthException catch (e) {
//       throw Exception(e.code);

//     }
//   }

//   // sign out
//   Future<void> signOut() async{
//     return await _auth.signOut();
//   }

//   //errors

// }

// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   // Other functions like signInWithCredential and signUpWithEmailAndPassword remain unchanged

//   Future<User?> signInWithCredential(
//       String email, String password) async {
//     // Implement your email/password authentication logic here
//   }

//   Future<User?> signUpWithEmailAndPassword(
//       String email, String password) async {
//     // Implement your email/password registration logic here
//   }

//   // Add a new function to check if the user is signed in via phone number authentication
//   Future<User?> signInWithPhoneNumber(String phoneNumber, String verificationId, String smsCode) async {
//     try {
//       // Create PhoneAuthCredential using the verificationId and smsCode
//       final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );

//       // Sign in with the credential
//       final UserCredential userCredential = await _auth.signInWithCredential(credential);

//       // Return the signed-in user
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("Failed to sign in with phone number: ${e.message}");
//       return null;
//     } catch (e) {
//       print("Unexpected error during phone number sign in: $e");
//       return null;
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> signInWithPhoneNumber(
      String phoneNumber, String verificationId, String smsCode) async {
    try {
      // Create PhoneAuthCredential using the verificationId and smsCode
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in with the credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Return the signed-in user
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Failed to sign in with phone number: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error during phone number sign in: $e");
      return null;
    }
  }
}
