import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderPhoneNumber;
  final String receiverID;
  // final String message;
  final Timestamp timestamp;
  final List<Map<String, dynamic>> renterMessages;
  final List<Map<String, dynamic>> lenderMessages;

  Message(
      {required this.senderID,
      required this.senderPhoneNumber,
      required this.receiverID,
      // required this.message,

      this.renterMessages = const [],
      this.lenderMessages = const [],
      required this.timestamp});

  //convert to map

  Map<String, dynamic> toMAp() {
    return {
      'senderID': senderID,
      'senderPhoneNumber': senderPhoneNumber,
      'receiverID': receiverID,
      // 'message': message,
      'renterMessages': renterMessages,
      'lenderMessages': lenderMessages,
      'timestamp': timestamp,
    };
  }
}
