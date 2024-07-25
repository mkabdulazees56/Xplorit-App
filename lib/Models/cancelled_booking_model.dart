import 'package:cloud_firestore/cloud_firestore.dart';

class CancelledBookingModel {
  String bookingId;
  String cancelledBookingId;
  String renterId;
  String vehicleId;
  Timestamp startDate;
  Timestamp endDate;
  String canelledBy;
  String garageId;
  String garageName;
  String garageLocation;
  String vehicleImage;
  String vehicleModel;
  double vehicleRating;

  CancelledBookingModel({
    required this.cancelledBookingId,
    required this.bookingId,
    required this.renterId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.canelledBy,
    required this.garageId,
    required this.garageName,
    required this.garageLocation,
    required this.vehicleImage,
    required this.vehicleModel,
    required this.vehicleRating,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'renterId': renterId,
      'vehicleId': vehicleId,
      'startDate': startDate,
      'endDate': endDate,
      'canelledBy': canelledBy,
      'garageId': garageId,
      'garageName': garageName,
      'garageLocation': garageLocation,
      'vehicleImage': vehicleImage,
      'vehicleModel': vehicleModel,
      'vehicleRating': vehicleRating,
      'cancelledBookingId': cancelledBookingId,
    };
  }

  static CancelledBookingModel empty() => CancelledBookingModel(
        cancelledBookingId: '',
        bookingId: '',
        renterId: '',
        vehicleId: '',
        startDate: Timestamp.fromDate(DateTime(0)),
        endDate: Timestamp.fromDate(DateTime(0)),
        canelledBy: '',
        garageId: '',
        garageName: '',
        garageLocation: '',
        vehicleImage: '',
        vehicleModel: '',
        vehicleRating: 0.0,
      );

  factory CancelledBookingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return CancelledBookingModel.empty();
    final data = document.data();
    return CancelledBookingModel(
      cancelledBookingId: data?['cancelledBookingId'] ?? '',
      bookingId: data?['bookingId'] ?? '',
      renterId: data?['renterId'] ?? '',
      vehicleId: data?['vehicleId'] ?? '',
      startDate: data?['startDate'] ?? Timestamp.fromDate(DateTime(0)),
      endDate: data?['endDate'] ?? Timestamp.fromDate(DateTime(0)),
      canelledBy: data?['canelledBy'] ?? '',
      garageId: data?['garageId'] ?? '',
      garageName: data?['garageName'] ?? '',
      garageLocation: data?['garageLocation'] ?? '',
      vehicleImage: data?['vehicleImage'] ?? '',
      vehicleModel: data?['vehicleModel'] ?? '',
      vehicleRating: data?['vehicleRating'] ?? 0.0,
    );
  }
}
