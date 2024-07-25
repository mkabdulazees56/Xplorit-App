import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderPhoneNumber;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderID,
      required this.senderPhoneNumber,
      required this.receiverID,
      required this.message,
      required this.timestamp});

  //convert to map

  Map<String, dynamic> toMAp() {
    return {
      'senderID': senderID,
      'senderPhoneNumber': senderPhoneNumber,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
