import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Models/cancelled_booking_model.dart';
import 'package:xplorit/utils/constants/colors.dart';

class CancelledBookingRepository extends GetxController {
  static CancelledBookingRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<CancelledBookingModel>> getCancelledBookings() async {
    try {
      final snapshot = await _db.collection('CancelledBooking').get();
      if (snapshot == null) {
        return [];
      } else {
        List<CancelledBookingModel> cancelledbookings =
            snapshot.docs.map((doc) {
          return CancelledBookingModel.fromSnapshot(doc);
        }).toList();
        return cancelledbookings;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> AddCancelledBooking(
      CancelledBookingModel cancelledbooking) async {
    try {
      DocumentReference ref = await _db
          .collection('CancelledBooking')
          .add(cancelledbooking.toJson());
      String cBId = ref.id;
      cancelledbooking.cancelledBookingId = cBId;
      await ref.update({'cancelledBookingId': cBId});
      // controller.fetchCancelledBookingData();
    } catch (error) {
      // Show error snackbar if adding or updating fails
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  }

  Future<void> removeCancelledBooking(String cancelledBookingId) async {
    try {
      DocumentReference ref =
          _db.collection('CancelledBooking').doc(cancelledBookingId);
      await ref.delete();
      Get.snackbar(
        'Success',
        'Cancelled Booking removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );
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
