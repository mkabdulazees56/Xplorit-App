// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:xplorit/features/chat/chat_page.dart';
// import 'package:xplorit/features/chat/chat_services.dart';
// import 'package:xplorit/features/chat/user_tile.dart';
// import 'package:xplorit/firebase_Services.dart';

// class ChatHomePage extends StatelessWidget {
//   ChatHomePage({Key? key});

//   final ChatService _chatService = ChatService();
//   final FirebaseAuthService _auth = FirebaseAuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF66b899),
//         title: Text("Users"),
//       ),
//       body: _buildUserList(),
//     );
//   }

//   Widget _buildUserList() {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: _chatService.getUsersStream(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           print("Error: ${snapshot.error}");
//           return Text("Error");
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           print("Loading...");
//           return Text("Loading...");
//         }

//         List<Map<String, dynamic>> users = snapshot.data ?? [];
//         print("Users fetched: ${users.length}");
//         return ListView.builder(
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             Map<String, dynamic> userData = users[index];
//             print("User Data: $userData");
//             return _buildUserListItem(userData, context);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildUserListItem(
//       Map<String, dynamic> userData, BuildContext context) {
//     String currentUserPhoneNumber = _auth.getCurrentUser()?.phoneNumber ?? '';
//     print("Current User Phone Number: $currentUserPhoneNumber");
//     if (currentUserPhoneNumber.isNotEmpty &&
//         userData["phoneNumber"] != currentUserPhoneNumber) {
//       return StreamBuilder(
//         stream: _chatService.getMessages(
//             currentUserPhoneNumber, userData["phoneNumber"]),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             print("Error: ${snapshot.error}");
//             return Text("Error");
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             print("Loading messages...");
//             return Text("Loading...");
//           }

//           QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
//               snapshot.data as QuerySnapshot<Map<String, dynamic>>;

//           if (messagesSnapshot.docs.isNotEmpty) {
//             Map<String, dynamic> lastMessage =
//                 messagesSnapshot.docs.last.data();
//             String message = lastMessage["message"];
//             Timestamp timestamp = lastMessage["timestamp"];
//             DateTime dateTime = timestamp.toDate();
//             String formattedTime = DateFormat.Hm().format(dateTime);

//             return UserTile(
//               image: userData["profilePicture"],
//               name: userData["userName"],
//               message: _truncateMessage(message),
//               time: formattedTime,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => chatPage(
//                       displayName: userData["userName"],
//                       image: userData["profilePicture"],
//                       receiverPhoneNumber: userData["phoneNumber"],
//                       receiverID: userData["uid"],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return UserTile(
//               image: userData["profilePicture"],
//               name: userData["userName"],
//               message: "No messages yet",
//               time: "",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => chatPage(
//                       displayName: userData["userName"],
//                       image: userData["profilePicture"],
//                       receiverPhoneNumber: userData["phoneNumber"],
//                       receiverID: userData["uid"],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       );
//     } else {
//       return Container();
//     }
//   }

//   String _truncateMessage(String message) {
//     const maxLength = 30;
//     if (message.length > maxLength) {
//       return message.substring(0, maxLength) + '...';
//     } else {
//       return message;
//     }
//   }
// }

// after proper login u have to use above mentioned code and make the change in chat_page

// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/features/Lender_chat/chat_page.dart';
import 'package:xplorit/features/Lender_chat/chat_services.dart';
import 'package:xplorit/features/Lender_chat/user_tile.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/features/lent/lender_profile/lender_profile_home.dart';
import 'package:xplorit/firebase_Services.dart';
import 'package:xplorit/utils/constants/colors.dart';

class LenderChatHomePage extends StatefulWidget {
  const LenderChatHomePage({Key? key});

  @override
  State<LenderChatHomePage> createState() => _LenderChatHomePageState();
}

class _LenderChatHomePageState extends State<LenderChatHomePage> {
  final LenderChatService _chatService = LenderChatService();
  final garageController = Get.put(GarageController());
  final bookingController = Get.put(BookingController());
  final FirebaseAuthService _auth = FirebaseAuthService();
  String? userPhoneNumber;
  String? garageId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await getGarageId();
  }

  Future<void> getGarageId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userPhoneNumber = user.phoneNumber ?? '';
      try {
        for (GarageModel garage in garageController.garagesData) {
          if (garage.contactNumber == userPhoneNumber) {
            garageId = garage.garageId;
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int bottomNavBarCurrentIndex = 1;

    return PopScope(
      canPop: false, // Prevent back button from popping the current route
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColors.primary,
          title: Text(
            "Chats",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _buildUserList(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNavBarCurrentIndex,
          unselectedItemColor: TColors.greyDark,
          selectedItemColor: TColors.primary,
          backgroundColor: TColors.blueLight,
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          onTap: (index) {
            setState(() {
              bottomNavBarCurrentIndex = index;
            });
            switch (index) {
              case 0:
                Get.offAll(() => HomelentPage());
                break;
              case 1:
                Get.offAll(() => LenderChatHomePage());
                break;
              case 2:
                Get.offAll(() => LenderProfileHomePage());
                break;
            }
          },
        ),
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////// getting the user

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Loading...");
          return Center(
              child: Column(
            children: const [
              SizedBox(height: 300),
              CircularProgressIndicator(),
              Text("Loading..."),
            ],
          ));
        }

        List<String> renterIds = [];
        for (BookingModel booking in bookingController.bookingsData) {
          if (garageId == booking.garageId) {
            renterIds.add(booking.renterId);
          }
        }

        // Filter users based on the renterIds
        List<Map<String, dynamic>> filteredUsers = snapshot.data!.where((user) {
          return renterIds.contains(
              user['renterId']); // Assuming user['id'] is the renterId
        }).toList();

        if (filteredUsers.isEmpty) {
          return Center(child: Text("No vehicle booked"));
        }
        //     List<Map<String, dynamic>> users = snapshot.data ?? [];
        //     print("Users fetched: ${users.length}");
        //     return ListView.builder(
        //       itemCount: users.length,
        //       itemBuilder: (context, index) {
        //         Map<String, dynamic> userData = users[index];
        //         print("User Data: $userData");
        //         return userData.isNotEmpty
        //             ? _buildUserListItem(userData, context)
        //             : null;
        //       },
        //     );
        //   },
        // );
        // }

        print("Filtered Users fetched: ${filteredUsers.length}");
        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> userData = filteredUsers[index];
            print("User Data: $userData");
            return _buildUserListItem(userData, context);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    String currentUserPhoneNumber = userPhoneNumber ?? '';
    print("Current User Phone Number: $currentUserPhoneNumber");

    return StreamBuilder(
      stream: _chatService.getMessages(garageId!, userData["renterId"]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Loading messages...");
          return UserTile(
            image: userData["profilePicture"],
            name: userData["userName"],
            message: "Loading...",
            timestamp: userData["timestamp"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => chatPage(
                    displayName: userData["userName"],
                    image: userData["profilePicture"],
                    receiverPhoneNumber: userData["contactNumber"],
                    receiverID: userData["renterId"],
                  ),
                ),
              );
            },
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return UserTile(
            image: userData["profilePicture"],
            name: userData["userName"],
            message: "No messages yet",
            timestamp: userData["timestamp"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => chatPage(
                    displayName: userData["userName"],
                    image: userData["profilePicture"],
                    receiverPhoneNumber: userData["contactNumber"],
                    receiverID: userData["renterId"],
                  ),
                ),
              );
            },
          );
        }

        QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
            snapshot.data as QuerySnapshot<Map<String, dynamic>>;

        String lastMessage = "No messages yet";
        Timestamp timestamp = Timestamp.now();

        if (messagesSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> lastMessageData =
              messagesSnapshot.docs.last.data();

          // Debugging: print the last message data
          print("Last message data: $lastMessageData");

          if (lastMessageData.containsKey('message') &&
              lastMessageData.containsKey('timestamp')) {
            lastMessage = lastMessageData['message'];
            timestamp = lastMessageData['timestamp'] ?? Timestamp.now();
          }
        }

        return UserTile(
          image: userData["profilePicture"],
          name: userData["userName"],
          message: _truncateMessage(lastMessage),
          timestamp: timestamp,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => chatPage(
                  displayName: userData["userName"],
                  image: userData["profilePicture"],
                  receiverPhoneNumber: userData["contactNumber"],
                  receiverID: userData["renterId"],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget _buildUserListItem(
  //     Map<String, dynamic> userData, BuildContext context) {
  //   String currentUserPhoneNumber = userPhoneNumber ?? '';
  //   print("Current User Phone Number: $currentUserPhoneNumber");

  //   return StreamBuilder(
  //     stream: _chatService.getMessages(
  //         currentUserPhoneNumber, userData["contactNumber"]),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         print("Error: ${snapshot.error}");
  //         return Text("Error");
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         print("Loading messages...");
  //         return UserTile(
  //           image: userData["profilePicture"],
  //           name: userData["userName"],
  //           message: "Loading...",
  //           timestamp: userData["timestamp"],
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => chatPage(
  //                   displayName: userData["userName"],
  //                   image: userData["profilePicture"],
  //                   receiverPhoneNumber: userData["contactNumber"],
  //                   receiverID: userData["renterId"],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       }

  //       QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
  //           snapshot.data as QuerySnapshot<Map<String, dynamic>>;

  //       String lastMessage = "No messages yet";
  //       // String formattedTime = "";
  //       Timestamp timestamp = Timestamp.now();

  //       if (messagesSnapshot.docs.isNotEmpty) {
  //         Map<String, dynamic> lastMessageData =
  //             messagesSnapshot.docs.last.data();
  //         lastMessage = lastMessageData["message"];
  //         timestamp = lastMessageData["timestamp"];
  //       }

  //       return UserTile(
  //         image: userData["profilePicture"],
  //         name: userData["userName"],
  //         message: _truncateMessage(lastMessage),
  //         timestamp: timestamp,
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => chatPage(
  //                 displayName: userData["userName"],
  //                 image: userData["profilePicture"],
  //                 receiverPhoneNumber: userData["contactNumber"],
  //                 receiverID: userData["renterId"],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  String _truncateMessage(String message) {
    const maxLength = 30;
    if (message.length > maxLength) {
      return message.substring(0, maxLength) + '...';
    } else {
      return message;
    }
  }
}
