// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/features/Lender_chat/chat_bubble.dart';
import 'package:xplorit/features/Lender_chat/chat_services.dart';
import 'package:xplorit/features/Lender_chat/messageInput_widget.dart';
import 'package:xplorit/firebase_Services.dart';
import 'package:xplorit/utils/constants/colors.dart';

// ignore: must_be_immutable
class chatPage extends StatefulWidget {
  final String receiverPhoneNumber;
  final String displayName;
  final String receiverID;
  final String image;

  chatPage({
    super.key,
    required this.receiverPhoneNumber,
    required this.receiverID,
    required this.displayName,
    required this.image,
  });

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();
  final garageController = Get.put(GarageController());

  // Chat and auth services
  final LenderChatService _chatService = LenderChatService();

  final FirebaseAuthService _auth = FirebaseAuthService();

  String? userPhoneNumber;

  String? garageSenderId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await getSenderId();
  }

  // Send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  // Open dial pad
  Future<void> _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: widget.image.startsWith('http')
                      ? Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.person,
                                color: TColors.secondary,
                                size: 60,
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.person,
                                color: TColors.secondary,
                                size: 60,
                              ),
                            );
                          },
                        ),
                ), //icon
                SizedBox(width: 8),
                Text(
                  widget.displayName,
                  style: TextStyle(color: TColors.white),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.phone,
                size: 28, // Adjust the size as needed
                color: Colors.white, // Change the color
              ),
              onPressed: () {
                _launchDialer(widget.receiverPhoneNumber);
              },
            ),
          ],
        ),
        backgroundColor: TColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMessageList(),
            ),
          ),
          // User input
          _buildUserInput(),
        ],
      ),
    );
  }

  Future<void> getSenderId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userPhoneNumber = user.phoneNumber ?? '';
      try {
        for (GarageModel garage in garageController.garagesData) {
          if (garage.contactNumber == userPhoneNumber) {
            garageSenderId = garage.garageId;
          }
        }
      } catch (e) {}
    }
  }

  // Build message list
  Widget _buildMessageList() {
    final ScrollController scrollController = ScrollController();
    // String senderID = _auth.getCurrentUser()?.uid ?? '';
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, garageSenderId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading ...");
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return ListView(
          controller: scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUserMessage = data["senderID"] == garageSenderId!;
    // (_auth.getCurrentUser() != null ? _auth.getCurrentUser()!.uid : '');
    // : 'OcGoqopLmDTPQK3GRHAN');

    Timestamp timestamp = data["timestamp"];
    DateTime dateTime = timestamp.toDate();

    return Container(
      alignment:
          isCurrentUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isCurrentUserMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUserMessage,
            timestamp: dateTime,
          ),
        ],
      ),
    );
  }

  // Build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Textfield should take up most of the space
          Expanded(
            child: MessageInput(
              hintText: "Type a message",
              obscuretxt: false,
              controller: _messageController,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: TColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.send_outlined),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
