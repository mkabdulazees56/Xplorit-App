// ignore: unnecessary_import
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/utils/constants/colors.dart';

class VehicleRepository extends GetxController {
  static VehicleRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  // final controller = Get.put(VehicleController());

  Future<List<VehicleModel>> getVehicles() async {
    try {
      final snapshot = await _db.collection('Vehicle').get();

      if (snapshot == null) {
        return [];
      } else {
        List<VehicleModel> vehicles = snapshot.docs.map((doc) {
          return VehicleModel.fromSnapshot(doc);
        }).toList();
        return vehicles;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw 'Something went wrong: $e';
    }
  }

  Future<void> updateVehicle(String documentId, VehicleModel vehicle) async {
    DocumentReference docRef = _db.collection('Vehicle').doc(documentId);

    await docRef.update(vehicle.toJson()).then((_) {
      Get.snackbar('Success', 'Vehicle data updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color.fromARGB(255, 255, 255, 255),
          backgroundColor: TColors.primary);
    }).catchError((error) {
      // Show error snackbar if updating fails
      Get.snackbar(
        'Error',
        'Failed to update Vehicle',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }

  Future<void> updateVehicleActiveStatus(
      String documentId, bool isVehicleActive) async {
    DocumentReference docRef = _db.collection('Vehicle').doc(documentId);

    await docRef
        .update({'isVehicleActive': isVehicleActive})
        .then((_) {})
        .catchError((error) {
          // Show error snackbar if updating fails
          Get.snackbar(
            'Error',
            'Failed to update vehicle status',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Color.fromARGB(255, 255, 0, 0),
          );
          print(error.toString());
        });
  }

  Future<void> updateVehicleReview(
      String documentId, double rating, int noOfRating) async {
    DocumentReference docRef = _db.collection('Vehicle').doc(documentId);

    await docRef.update({
      'rating': rating,
      'noOfRating': noOfRating,
    }).then((_) {
      // Optionally, you can add some success feedback here
    }).catchError((error) {
      // Show error snackbar if updating fails
      Get.snackbar(
        'Error',
        'Failed to update vehicle reviews, ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }

  Future<String> AddVehicle(VehicleModel vehicle) async {
    try {
      DocumentReference ref =
          await _db.collection('Vehicle').add(vehicle.toJson());
      String vId = ref.id;
      vehicle.vehicleId = vId;
      await ref.update({'vehicleId': vId});
      Get.snackbar(
        'Success',
        'Vehicle ${vehicle.model} added successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );
      // controller.fetchVehicleData();
      return vId;
    } catch (error) {
      // Show error snackbar if adding or updating fails
      Get.snackbar(
        'Error',
        'Something went wrong \n $error',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
      return '';
    }
  }

  Future<void> removeVehicle(String vehicleId) async {
    try {
      // Reference to the document to be deleted
      DocumentReference ref = _db.collection('Vehicle').doc(vehicleId);

      // Delete the document
      await ref.delete();

      // Show success message
      Get.snackbar(
        'Success',
        'Vehicle removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );

      // Optionally, you can refresh or fetch updated data here
      // controller.fetchVehicleData();
    } catch (error) {
      // Show error snackbar if deletion fails
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    }
  } // Future<void> updateSingleField(Map<String, dynamic> json) async {
  //   try {
  //     await _db.collection('Garage').doc('documentId').update(json);
  //   } on FirebaseException catch (e) {
  //     throw 'Firebase Exception: $e';
  //   } catch (e) {
  //     throw ' Something went wrong. Please try again';
  //   }
  // }

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

  // Future<String> uploadImage(String path, XFile image) async {
  //   try {
  //     final ref = FirebaseStorage.instance.ref(path).child(image.name);
  //     await ref.putFile(File(image.path));

  //     final url = await ref.getDownloadURL();
  //     return url;
  //   } on FirebaseException catch (e) {
  //     throw 'Firebase Exception: $e';
  //   } catch (e) {
  //     throw ' Something went wrong. Please try again';
  //   }
  // }
}
