// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:xplorit/features/chat/chat_page.dart';
// import 'package:xplorit/features/chat/chat_services.dart';
// import 'package:xplorit/features/chat/user_tile.dart';
// import 'package:xplorit/firebase_Services.dart';

// class RenterChatHomePage extends StatelessWidget {
//   RenterChatHomePage({Key? key});

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
//               image: TImages.garageIcon,
//               name: userData["userName"],
//               message: _truncateMessage(message),
//               time: formattedTime,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => RenterchatPage(
//                       displayName: userData["userName"],
//                       image: TImages.garageIcon,
//                       receiverPhoneNumber: userData["phoneNumber"],
//                       receiverID: userData["uid"],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return UserTile(
//               image: TImages.garageIcon,
//               name: userData["userName"],
//               message: "No messages yet",
//               time: "",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => RenterchatPage(
//                       displayName: userData["userName"],
//                       image: TImages.garageIcon,
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
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/features/Lender_chat/user_tile.dart';
import 'package:xplorit/features/Renter_chat/renter_chat_page.dart';
import 'package:xplorit/features/Renter_chat/renter_chat_services.dart';
import 'package:xplorit/features/booking_status/my_bookings.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/dashbord/renter_profile/renter_profile_home.dart';
import 'package:xplorit/features/product/product_list.dart';
import 'package:xplorit/firebase_Services.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class RenterChatHomePage extends StatefulWidget {
  const RenterChatHomePage({Key? key});

  @override
  State<RenterChatHomePage> createState() => _RenterChatHomePageState();
}

class _RenterChatHomePageState extends State<RenterChatHomePage> {
  final RenterChatService _chatService = RenterChatService();
  final renterController = Get.put(RenterController());
  final bookingController = Get.put(BookingController());
  final FirebaseAuthService _auth = FirebaseAuthService();
  int bottomNavBarCurrentIndex = 1;
  bool hasUnreadMessages = false;

  String? userPhoneNumber;
  String? currentRenterId;

  get currentUserID => null;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await getCurrentRenterId();
  }

  Future<void> getCurrentRenterId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userPhoneNumber = user.phoneNumber ?? '';
      try {
        for (RenterModel renter in renterController.rentersData) {
          if (renter.contactNumber == userPhoneNumber) {
            currentRenterId = renter.renterId;
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          unselectedItemColor: TColors.darkGrey,
          selectedItemColor: TColors.primary,
          backgroundColor: TColors.secondary,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.message),
                  if (hasUnreadMessages) // Display indicator if there are unread messages
                    Positioned(
                      bottom: 12,
                      right: 0,
                      child: Container(
                        height: 12,
                        width: 12,
                        // padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Icon(Icons.message),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), // Chat icon

              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox),
              label: 'Bookings',
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                  (Route<dynamic> route) => false,
                );
                break;
              case 1:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RenterChatHomePage()));
                break;
              case 2:
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProductListing()));
                break;
              case 3:
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyBookings()));
                break;
              case 4:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RenterProfileHomePage()));
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
        List<String> garageIds = [];
        for (BookingModel booking in bookingController.bookingsData) {
          print('bookingGarage: ${booking.renterId}, $currentUserID');

          if (currentRenterId == booking.renterId) {
            garageIds.add(booking.garageId);
          }
        }

        // Filter users based on the renterIds
        List<Map<String, dynamic>> filteredUsers = snapshot.data!.where((user) {
          return garageIds.contains(
              user['garageId']); // Assuming user['id'] is the renterId
        }).toList();

        //       List<Map<String, dynamic>> users = snapshot.data ?? [];
        //       print("Users fetched: ${users.length}");
        //       return ListView.builder(
        //         itemCount: users.length,
        //         itemBuilder: (context, index) {
        //           Map<String, dynamic> userData = users[index];
        //           print("User Data: $userData");
        //           return userData.isNotEmpty
        //               ? _buildUserListItem(userData, context)
        //               : null;
        //         },
        //       );
        //     },
        //   );
        // }

        if (filteredUsers.isEmpty) {
          return Center(child: Text("No vehicle booked"));
        }

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
    // String currentUserPhoneNumber = _auth.getCurrentUser()?.phoneNumber ?? '';
    print("Current User Phone Number: $userPhoneNumber");
    print('Receiver Phone Number: ${userData["contactNumber"]}');

    return StreamBuilder(
      stream: _chatService.getMessages(currentRenterId!, userData["garageId"]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Loading messages...");
          return UserTile(
            image: TImages.garageIcon,
            name: userData["userName"],
            message: "Loading...",
            timestamp: Timestamp.now(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RenterchatPage(
                    displayName: userData["userName"],
                    image: TImages.garageIcon,
                    receiverPhoneNumber: userData["contactNumber"],
                    receiverID: userData["garageId"],
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
          lastMessage = lastMessageData["message"];
          timestamp = lastMessageData["timestamp"];
        }

        return UserTile(
          image: TImages.garageIcon,
          name: userData["userName"],
          message: _truncateMessage(lastMessage),
          timestamp: timestamp,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RenterchatPage(
                  displayName: userData["userName"],
                  image: TImages.garageIcon,
                  receiverPhoneNumber: userData["contactNumber"],
                  receiverID: userData["garageId"],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _truncateMessage(String message) {
    const maxLength = 30;
    if (message.length > maxLength) {
      return message.substring(0, maxLength) + '...';
    } else {
      return message;
    }
  }
}
