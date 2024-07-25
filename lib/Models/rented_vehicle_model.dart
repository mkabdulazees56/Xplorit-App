import 'package:cloud_firestore/cloud_firestore.dart';

class RentedVehicleModel {
  String rentId;
  String garageId;
  String vehicleId;
  String bookingId;
  String renterId;

  RentedVehicleModel({
    required this.rentId,
    required this.garageId,
    required this.vehicleId,
    required this.renterId,
    required this.bookingId,
  });

  toJson() {
    return {
      'rentId': rentId,
      'bookingId': bookingId,
      'renterId': renterId,
      'garageId': garageId,
      'vehicleId': vehicleId,
    };
  }

  static RentedVehicleModel empty() => RentedVehicleModel(
        rentId: '',
        garageId: '',
        renterId: '',
        bookingId: '',
        vehicleId: '',
      );

  factory RentedVehicleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return RentedVehicleModel.empty();
    final data = document.data();
    return RentedVehicleModel(
      rentId: data?['rentId'] ?? '',
      garageId: data?['garageId'] ?? '',
      renterId: data?['renterId'] ?? '',
      vehicleId: data?['vehicleId'] ?? '',
      bookingId: data?['bookingId'] ?? '',
    );
  }
}
