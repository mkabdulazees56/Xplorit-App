import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/features/Lender_chat/message_model.dart';

class RenterChatService {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final garageController = Get.put(GarageController());
  final renterController = Get.put(RenterController());
  final bookingController = Get.put(BookingController());
  List<RenterModel> bookedRenters = [];

  String? userPhoneNumber;
  String? currentUserID;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Garage").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return data;
      }).toList();
    });
  }

  Future<void> getCurrentRenterId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userPhoneNumber = user.phoneNumber ?? '';
      print('user phone numer: $userPhoneNumber');

      try {
        for (RenterModel renter in renterController.rentersData) {
          if (renter.contactNumber == userPhoneNumber) {
            currentUserID = renter.renterId;
          }
        }
        print('object: $currentUserID');
      } catch (e) {}
    }
  }
  // Future<void> getGarageId() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     userPhoneNumber = user.phoneNumber ?? '';
  //     print('user phone numer: $userPhoneNumber');

  //     try {
  //       for (GarageModel garage in garageController.garagesData) {
  //         if (garage.contactNumber == userPhoneNumber) {
  //           currentUserID = garage.garageId;
  //           print(
  //               'RenterIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIiiiiiiiiiiiiiiiiiiiiiiiiiiiddddddddddddd: $currentUserID');
  //         }
  //       }
  //       print('object: $currentUserID');
  //     } catch (e) {}
  //   }
  // }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    await getCurrentRenterId();
    // final String currentUserID = getGarageId;

    // final String currentUserPhoneNo = _auth.currentUser?.phoneNumber ?? "";
    final Timestamp timestamp = Timestamp.now();

    //create a new message

    Message newMessage = Message(
        senderID: currentUserID!,
        senderPhoneNumber: userPhoneNumber!,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    //construct cat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID!, receiverID];
    ids.sort(); // sort the ids....this ensure that chatroomId is the same for any 2 people
    String chatRoomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMAp());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // otherUserID = '123';
    //construct chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
