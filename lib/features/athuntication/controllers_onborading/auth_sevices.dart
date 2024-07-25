// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthServices {
//   // signInWithGoogle () async {

//   //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//   //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;

//   //   final credential = GoogleAuthProvider.credential(
//   //     accessToken: gAuth.accessToken,
//   //     idToken: gAuth.idToken,
//   //   );

//   //   return await FirebaseAuth.instance.signInWithCredential(credential);
//   // }

//   Future<bool> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//       if (gUser == null) {
//         // User canceled the Google sign-in
//         return false;
//       }

//       final GoogleSignInAuthentication gAuth = await gUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: gAuth.accessToken,
//         idToken: gAuth.idToken,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);

//       // Sign-in with Google was successful
//       return true;
//     } catch (e) {
//       print("Google sign-in error: $e");
//       // Handle errors and return false
//       return false;
//     }
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String verifyId = "";
  // to sent and otp to user
  static Future sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    await _firebaseAuth
        .verifyPhoneNumber(
      timeout: Duration(seconds: 30),
      phoneNumber: "+91$phone",
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        return;
      },
    )
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  // verify the otp code and login
  static Future loginWithOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Error in Otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // to logout the user
  static Future logout() async {
    await _firebaseAuth.signOut();
  }

  // check whether the user is logged in or not
  static Future<bool> isLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }
}