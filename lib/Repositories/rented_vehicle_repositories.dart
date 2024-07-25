// ignore: unnecessary_import
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xplorit/Models/rented_vehicle_model.dart';
import 'package:xplorit/utils/constants/colors.dart';

class RentedVehicleRepository extends GetxController {
  static RentedVehicleRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  // final controller = Get.put(VehicleController());

  Future<List<RentedVehicleModel>> getRentedVehicles() async {
    try {
      final snapshot = await _db.collection('RentedVehicle').get();

      if (snapshot == null) {
        return [];
      } else {
        List<RentedVehicleModel> rentedvehicles = snapshot.docs.map((doc) {
          return RentedVehicleModel.fromSnapshot(doc);
        }).toList();
        return rentedvehicles;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw 'Something went wrong: \n$e';
    }
  }

  Future<void> removeRentedVehicle(String rentId) async {
    try {
      DocumentReference ref = _db.collection('RentedVehicle').doc(rentId);
      await ref.delete();
      Get.snackbar(
        'Success',
        'Vehicle handed over successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to remove data',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  }

  Future<void> updateRentedVehicle(
      String documentId, RentedVehicleModel rentedvehicle) async {
    DocumentReference docRef = _db.collection('RentedVehicle').doc(documentId);

    await docRef.update(rentedvehicle.toJson()).then((_) {
      Get.snackbar('Success', 'RentedVehicle $documentId updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color.fromARGB(255, 255, 255, 255),
          backgroundColor: TColors.primary);
    }).catchError((error) {
      // Show error snackbar if updating fails
      Get.snackbar(
        'Error',
        'Failed to update RentedVehicle',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }

  Future<void> AddRentedVehicle(RentedVehicleModel rentedvehicle) async {
    try {
      DocumentReference ref =
          await _db.collection('RentedVehicle').add(rentedvehicle.toJson());
      String rVId = ref.id;
      rentedvehicle.rentId = rVId;
      await ref.update({'rentId': rVId});
      Get.snackbar(
        'Success',
        'Vehicle has successfully rented',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  }

  Future<List<String>> uploadImages(String path, List<XFile> images) async {
    List<String> downloadUrls = [];

    try {
      for (XFile image in images) {
        // Create a reference to the specified path in Firebase Storage
        final ref = FirebaseStorage.instance.ref(path).child(image.name);

        // Upload the image to Firebase Storage
        await ref.putFile(File(image.path));

        // Get the download URL of the uploaded image
        final url = await ref.getDownloadURL();
        downloadUrls.add(url);
      }
      return downloadUrls;
    } on FirebaseException catch (e) {
      // Handle Firebase-specific exceptions
      throw 'Firebase Exception: $e';
    } catch (e) {
      // Handle any other exceptions
      throw 'Something went wrong. Please try again';
    }
  }
}
