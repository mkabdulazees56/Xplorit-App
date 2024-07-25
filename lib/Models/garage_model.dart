import 'package:cloud_firestore/cloud_firestore.dart';

class GarageModel {
  String garageId;
  String userName;
  String? contactNumber;
  String address;

  GarageModel({
    required this.garageId,
    required this.userName,
    required this.contactNumber,
    required this.address,
  });

  toJson() {
    return {
      'garageId': garageId,
      'userName': userName,
      'contactNumber': contactNumber,
      'address': address,
    };
  }

  static GarageModel empty() => GarageModel(
        garageId: '',
        userName: '',
        contactNumber: '',
        address: '',
      );

  factory GarageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return GarageModel.empty();
    final data = document.data();
    return GarageModel(
      garageId: data?['garageId'] ?? '',
      userName: data?['userName'] ?? '',
      contactNumber: data?['contactNumber'] ?? '',
      address: data?['address'] ?? '',
    );
  }
}
