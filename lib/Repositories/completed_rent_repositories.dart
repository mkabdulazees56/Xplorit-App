import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Models/completed_rent_model.dart';

class CompletedRentRepository extends GetxController {
  static CompletedRentRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<CompletedRentModel>> getCompletedRents() async {
    try {
      final snapshot = await _db.collection('CompletedRent').get();
      if (snapshot == null) {
        return [];
      } else {
        List<CompletedRentModel> completedrents = snapshot.docs.map((doc) {
          return CompletedRentModel.fromSnapshot(doc);
        }).toList();
        return completedrents;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> AddCompletedRent(CompletedRentModel completedrent) async {
    try {
      DocumentReference ref =
          await _db.collection('CompletedRent').add(completedrent.toJson());
      String cBId = ref.id;
      completedrent.completedRentId = cBId;
      await ref.update({'completedRentId': cBId});
      // controller.fetchCompletedRentData();
    } catch (error) {
      // Show error snackbar if adding or updating fails
      Get.snackbar(
        'Error',
        'Something went wrong \n $error',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  }

  Future<void> removeCompletedRent(String completedRentId) async {
    try {
      DocumentReference ref =
          _db.collection('CompletedRent').doc(completedRentId);
      await ref.delete();
      // Get.snackbar(
      //   'Success',
      //   'Completed Rent removed successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      //   colorText: Color.fromARGB(255, 255, 255, 255),
      //   backgroundColor: TColors.primary,
      // );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to remove Cancelled Booking',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  }
}
