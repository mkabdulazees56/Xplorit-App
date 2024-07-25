import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/utils/constants/colors.dart';

class RenterRepository extends GetxController {
  static RenterRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<RenterModel>> getRenters() async {
    try {
      final snapshot = await _db.collection('Renter').get();
      //.where('transmission', isEqualTo: 'Manual').limit(4);
      if (snapshot == null) {
        return [];
      } else {
        List<RenterModel> renters = snapshot.docs.map((doc) {
          return RenterModel.fromSnapshot(doc);
        }).toList();
        return renters;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw ' Something went wrong. Please try again';
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    String downloadUrl = '';

    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      downloadUrl = url;
      Get.snackbar('Success', 'Image Added Successfully');
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw 'Something went wrong. Please try again \n $e';
    }
  }

  Future<void> updateRenterActiveStatus(
      String documentId, bool isRentedAVehicle) async {
    DocumentReference docRef = _db.collection('Renter').doc(documentId);

    await docRef
        .update({'isRentedAVehicle': isRentedAVehicle})
        .then((_) {})
        .catchError((error) {
          // Show error snackbar if updating fails
          Get.snackbar(
            'Error',
            'Failed to update renter status',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Color.fromARGB(255, 255, 0, 0),
          );
          print(error.toString());
        });
  }

  Future<void> updateRenter(String documentId, RenterModel renter) async {
    DocumentReference docRef = _db.collection('Renter').doc(documentId);

    await docRef.update(renter.toJson()).then((_) {
      Get.snackbar('Success', 'Renter data updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color.fromARGB(255, 255, 255, 255),
          backgroundColor: TColors.primary);
    }).catchError((error) {
      // Show error snackbar if updating fails
      Get.snackbar(
        'Error',
        'Failed to update Renter',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }

  void updateRenterLocation(String documentId, double latitude,
      double longitude, Timestamp timestamp) {
    DocumentReference docRef = _db.collection('Renter').doc(documentId);

    docRef.update({
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    }).catchError((error) {
      // Show error snackbar if updating fails
      Get.snackbar(
        'Error',
        'Failed to update Renter location',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }

  Future<void> updateRenterReview(
      String documentId, double rating, int noOfRating) async {
    DocumentReference docRef = _db.collection('Renter').doc(documentId);

    await docRef.update({
      'rating': rating,
      'noOfRating': noOfRating,
    }).then((_) {
      // Optionally, you can add some success feedback here
    }).catchError((error) {
      // Show error snackbar if updating fails
      Get.snackbar(
        'Error',
        'Failed to update renter reviews, ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }

  Future<void> AddRenter(RenterModel renter) async {
    try {
      DocumentReference ref =
          await _db.collection('Renter').add(renter.toJson());
      String rId = ref.id;

      renter.renterId = rId;

      await ref.update({'renterId': rId});
      Get.snackbar(
        'Success',
        'Renter ${renter.userName} added successfully',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: TColors.primary,
      );
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

  Future<void> RemoveRenter(String renterId) async {
    await _db.collection('Renter').doc(renterId).delete().then((_) {
      // Show success snackbar
      Get.snackbar('Success', 'renter removed successfully',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color.fromARGB(255, 255, 255, 255),
          backgroundColor: TColors.primary);
    }).catchError((error) {
      // Show error snackbar if deletion fails
      Get.snackbar(
        'Error',
        'Failed to remove vehicle\n $error',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }
}
