import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String paymentId;
  String bookingId;
  double amount;
  DateTime paymentDate;
  String paymentStatus;

  PaymentModel({
    required this.paymentId,
    required this.bookingId,
    required this.amount,
    required this.paymentDate,
    required this.paymentStatus,
  });

  toJson() {
    return {
      'paymentId': paymentId,
      'bookingId': bookingId,
      'amount': amount,
      'paymentDate': paymentDate,
      'paymentStatus': paymentStatus,
    };
  }

  static PaymentModel empty() => PaymentModel(
        paymentId: '',
        bookingId: '',
        amount: 0.0,
        paymentDate: DateTime(0),
        paymentStatus: '',
      );

  factory PaymentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return PaymentModel.empty();
    final data = document.data();
    return PaymentModel(
      paymentId: data?['vehicleId'] ?? '',
      bookingId: data?['model'] ?? '',
      amount: data?['mileage'] ?? '',
      paymentDate: data?['pickupLocation'] ?? '',
      paymentStatus: data?['rentalRates'] ?? '',
    );
  }
}
