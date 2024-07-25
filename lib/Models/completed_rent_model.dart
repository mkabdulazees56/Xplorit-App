import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedRentModel {
  // String bookingId;
  String completedRentId;
  String renterId;
  String vehicleId;
  String garageId;
  String rentId;
  double earning;
  int duration;
  Timestamp endDate;
  Timestamp startDate;

  CompletedRentModel({
    required this.completedRentId,
    // required this.bookingId,
    required this.renterId,
    required this.vehicleId,
    required this.garageId,
    required this.rentId,
    required this.earning,
    required this.duration,
    required this.endDate,
    required this.startDate,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'bookingId': bookingId,
      'renterId': renterId,
      'vehicleId': vehicleId,
      'garageId': garageId,
      'completedRentId': completedRentId,
      'rentId': rentId,
      'earning': earning,
      'duration': duration,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  static CompletedRentModel empty() => CompletedRentModel(
        completedRentId: '',
        // bookingId: '',
        renterId: '',
        vehicleId: '',
        garageId: '',
        rentId: '',
        earning: 0.0,
        duration: 0,
        endDate: Timestamp.now(),
        startDate: Timestamp.now(),
      );

  factory CompletedRentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return CompletedRentModel.empty();
    final data = document.data();
    return CompletedRentModel(
      completedRentId: data?['completedRentId'] ?? '',
      // bookingId: data?['bookingId'] ?? '',
      renterId: data?['renterId'] ?? '',
      vehicleId: data?['vehicleId'] ?? '',
      garageId: data?['garageId'] ?? '',
      rentId: data?['rentId'] ?? '',
      duration: data?['duration'] ?? 0,
      endDate: data?['endDate'] ?? Timestamp.now(),
      startDate: data?['startDate'] ?? Timestamp.now(),
      earning: data?['earning'] ?? 0.0,
    );
  }
}
