// ignore: unnecessary_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/utils/constants/colors.dart';

class GarageRepository extends GetxController {
  static GarageRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<GarageModel>> getGarages() async {
    try {
      final snapshot = await _db.collection('Garage').get();
      if (snapshot == null) {
        return [];
      } else {
        List<GarageModel> garages = snapshot.docs.map((doc) {
          return GarageModel.fromSnapshot(doc);
        }).toList();
        return garages;
      }
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: $e';
    } catch (e) {
      throw ' Something went wrong. Please try again \n $e';
    }
  }

  Future<void> AddGarage(GarageModel garage) async {
    await _db
        .collection('Garage')
        .add(garage.toJson())
        .then((DocumentReference ref) async {
      // Get the auto-generated document ID
      String vId = ref.id;

      // Update the garage with the document ID
      garage.garageId = vId;

      await ref.update({'garageId': vId}).then((_) {
        // Show success snackbar
        Get.snackbar('Success', 'Garage Created successfully',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Color.fromARGB(255, 255, 255, 255),
            backgroundColor: TColors.primary);
      }).catchError((error) {
        // Show error snackbar if updating fails
        Get.snackbar(
          'Error',
          'Failed to update garage ID',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color.fromARGB(255, 255, 0, 0),
        );
        print(error.toString());
      });
    }).catchError((error) {
      // Show error snackbar if adding fails
      Get.snackbar(
        'Error',
        'Something went wrong\n $error',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Color.fromARGB(255, 255, 0, 0),
      );
      print(error.toString());
    });
  }

  Future<void> updateGarage(String documentId, GarageModel garage) async {
    // Get the document reference for the garage using its ID
    DocumentReference docRef = await _db.collection('Garage').doc(documentId);
    try {
      DocumentSnapshot docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        Get.snackbar(
          'Error',
          'Garage document not found',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color.fromARGB(255, 255, 0, 0),
        );
        return;
      }
      // Update the document with the new data
      await docRef.update(garage.toJson()).then((_) {
        // Show success snackbar
        Get.snackbar('Success', 'Garage $documentId updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Color.fromARGB(255, 255, 255, 255),
            backgroundColor: TColors.primary);
      }).catchError((error) {
        // Show error snackbar if updating fails
        Get.snackbar(
          'Error',
          'Failed to update garage/n${error.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Color.fromARGB(255, 255, 0, 0),
        );
        print(error.toString());
      });
    } catch (e) {
      Get.snackbar('Oops!', e.toString());
    }
  }

  Future<void> RemoveGarage(String garageId) async {
    await _db.collection('Garage').doc(garageId).delete().then((_) {
      // Show success snackbar
      Get.snackbar('Success', 'Garage removed successfully',
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
