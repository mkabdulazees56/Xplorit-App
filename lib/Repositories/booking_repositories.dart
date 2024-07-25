import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/utils/constants/colors.dart';

class BookingRepository extends GetxController {
  static BookingRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<BookingModel>> getBookings() async {
    try {
      final snapshot = await _db.collection('Booking').get();
      if (snapshot == null) {
        return [];
      } else {
        List<BookingModel> bookings = snapshot.docs.map((doc) {
          return BookingModel.fromSnapshot(doc);
        }).toList();
        return bookings;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> AddBooking(BookingModel booking) async {
    try {
      DocumentReference ref =
          await _db.collection('Booking').add(booking.toJson());
      String vId = ref.id;
      booking.bookingId = vId;
      await ref.update({'bookingId': vId});
      Get.snackbar(
        'Success',
        'Vehicle Booked successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );
      // controller.fetchBookingData();
    } catch (error) {
      // Show error snackbar if adding or updating fails
      Get.snackbar(
        'Error',
        'Something went wrong\n $error',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  }

  Future<void> removeBooking(String bookingId) async {
    try {
      DocumentReference ref = _db.collection('Booking').doc(bookingId);
      await ref.delete();
      Get.snackbar(
        'Success',
        'Booking removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to remove Booking',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  }
}
