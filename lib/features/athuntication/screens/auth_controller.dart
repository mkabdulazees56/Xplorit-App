import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/onboarding');
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> deleteAccount() async {
    try {
      // await _auth.signOut();
      //implement the loginto remove the datas permenently
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
