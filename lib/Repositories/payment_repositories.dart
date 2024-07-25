// ignore: unnecessary_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Models/payment_model.dart';

class PaymentRepository extends GetxController {
  static PaymentRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<PaymentModel>> getPayments() async {
    try {
      final snapshot = await _db.collection('Payment').get();
      if (snapshot == null) {
        return [];
      } else {
        List<PaymentModel> payments = snapshot.docs.map((doc) {
          return PaymentModel.fromSnapshot(doc);
        }).toList();
        return payments;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw ' Something went wrong. Please try again';
    }
  }

  void AddPayment(PaymentModel payment) {
    _db
        .collection('Payment')
        .add(payment.toJson())
        .catchError((error, StackTrace) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }).whenComplete(
      () => Get.snackbar(
        'Success',
        'Payment added successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color(0xff00FF00),
      ),
    );
  }
}
