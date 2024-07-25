// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class DashBoardHeaderWidget extends StatefulWidget {
  const DashBoardHeaderWidget({
    // required this.location,
    required this.profilelogo,
    required this.tapCal,
    Key? key,
  }) : super(key: key);

  // final String location;
  final String profilelogo;
  final VoidCallback tapCal;

  @override
  State<DashBoardHeaderWidget> createState() => _DashBoardHeaderWidgetState();
}

class _DashBoardHeaderWidgetState extends State<DashBoardHeaderWidget> {
  String locationName = 'unknown';

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
    // else {
    //   getCurrentLocation();
    // }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _requestLocationPermission();
        });
      } else {
        getCurrentLocation();
      }
    } else {
      getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          locationName = '${placemark.locality}, ${placemark.country}';
        });
      } else {
        print("Placemark is empty");
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    String? phoneNumber = ' ';

    // Retrieve the current user from FirebaseAuth instance
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      phoneNumber = user.phoneNumber;
    } else {
      phoneNumber = 'User not authenticated';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image(
                  image: AssetImage(TImages.logo),
                  height: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Image(
                  image: AssetImage(TImages.title),
                  height: 50,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 5),
                Icon(
                  Icons.phone_android,
                  size: 18,
                  color: TColors.primary,
                ),
                Text(phoneNumber!,
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 5),
                Icon(
                  Icons.location_on,
                  size: 18,
                  color: TColors.primary,
                ),
                const SizedBox(width: 5),
                Text(locationName,
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        GestureDetector(
          onTap: widget.tapCal,
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey.shade200, // Set a background color
            child: ClipOval(
              child: widget.profilelogo.startsWith('http')
                  ? Image.network(
                      widget.profilelogo,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
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
                      widget.profilelogo,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
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
            ),
          ),
        )

        // GestureDetector(
        //   onTap: widget.tapCal,
        //   child: CircleAvatar(
        //     radius: 35,
        //     backgroundImage: widget.profilelogo.startsWith('http')
        //         ? NetworkImage(widget.profilelogo) as ImageProvider
        //         : AssetImage(widget.profilelogo) as ImageProvider,
        //     onBackgroundImageError: (exception, stackTrace) {
        //       // Handle the error case here, if necessary
        //       // For CircleAvatar, you can't show an error widget directly,
        //       // but you can handle the error in other ways
        //       print('Error loading image: $exception');
        //     },
        //     child: widget.profilelogo.startsWith('http')
        //         ? null
        //         : Image.asset(
        //             widget.profilelogo,
        //             height: 100,
        //             width: 100,
        //             fit: BoxFit.cover,
        //             errorBuilder: (context, error, stackTrace) {
        //               return Center(
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: const [
        //                     Icon(Icons.person,
        //                         color: TColors.secondary, size: 60),
        //                     SizedBox(height: 4),
        //                   ],
        //                 ),
        //               );
        //             },
        //           ),
        //   ),
        // )
      ],
    );
  }
}

// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:xplorit/utils/constants/colors.dart';
// import 'package:xplorit/utils/constants/image_strings.dart';

// class DashBoardHeaderWidget extends StatelessWidget {

//   const DashBoardHeaderWidget({
//     required this.location,
//     required this.profilelogo,
//     Key? key,
//   }) : super(key: key);

//   final String location;
//   final String profilelogo;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Image(
//                   image: AssetImage(TImages.logo),
//                   height: 50,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Image(
//                   image: AssetImage(TImages.title),
//                   height: 50,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 7),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.location_on,
//                 size: 18,
//                 color: TColors.primary,
//               ),
//               label: Text(location,
//                   style: Theme.of(context).textTheme.headlineSmall!),
//             ),
//           ],
//         ),
//         CircleAvatar(
//           radius: 35,
//           backgroundImage: AssetImage(profilelogo),
//         ),
//       ],
//     );
//   }
// }
