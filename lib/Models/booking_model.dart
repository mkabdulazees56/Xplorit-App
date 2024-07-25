import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String bookingId;
  String garageId;
  String renterId; //change the datatype
  String vehicleId;
  Timestamp startDate;
  Timestamp endDate;
  int duration;
  String paymentStatus;

  BookingModel({
    required this.bookingId,
    required this.garageId,
    required this.renterId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.paymentStatus,
  });

  toJson() {
    return {
      'bookingId': bookingId,
      'garageId': garageId,
      'renterId': renterId,
      'vehicleId': vehicleId,
      'startDate': startDate,
      'endDate': endDate,
      'duration': duration,
      'paymentStatus': paymentStatus,
    };
  }

  static BookingModel empty() => BookingModel(
        bookingId: '',
        garageId: '',
        renterId: '',
        vehicleId: '',
        startDate: Timestamp.fromDate(DateTime(0)),
        endDate: Timestamp.fromDate(DateTime(0)),
        paymentStatus: '',
        duration: 1,
      );

  factory BookingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return BookingModel.empty();
    final data = document.data();
    return BookingModel(
      bookingId: data?['bookingId'] ?? '',
      garageId: data?['garageId'] ?? '',
      renterId: data?['renterId'] ?? '',
      vehicleId: data?['vehicleId'] ?? '',
      startDate: data?['startDate'] ?? '',
      endDate: data?['endDate'] ?? '',
      duration: data?['duration'] ?? 1,
      paymentStatus: data?['paymentStatus'] ?? '',
    );
  }
}
