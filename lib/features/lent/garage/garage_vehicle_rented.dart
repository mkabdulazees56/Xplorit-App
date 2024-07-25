// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:xplorit/common_widgets/back_botton_widget.dart';
// import 'package:xplorit/common_widgets/icon_text_widget.dart';
// // import 'package:xplorit/features/lent/garage/garage_vehicle_card_notrented_widget.dart';
// import 'package:xplorit/features/lent/AddVehicle/add_car_details_form.dart';
// // import 'package:xplorit/features/lent/AddVehicle/select_vehicle_type_widget.dart';
// import 'package:xplorit/features/lent/garage/garage_vehicle_actions_widgets.dart';
// import 'package:xplorit/features/lent/garage/track_vehicle.dart';
// import 'package:xplorit/utils/constants/colors.dart';
// import 'package:xplorit/utils/constants/image_strings.dart';

// class MyGaragePageRented extends StatefulWidget {
//   const MyGaragePageRented({Key? key}) : super(key: key);

//   @override
//   State<MyGaragePageRented> createState() => _MyGaragePageRentedState();
// }

// class _MyGaragePageRentedState extends State<MyGaragePageRented> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: TColors.primary,
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: BackButtonWidget(
//                     btnColor: TColors.white,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Rickshaw Bajaj RE',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .headlineLarge
//                                 ?.copyWith(color: Colors.white),
//                           ),
//                           Container(
//                             width: 100,
//                             height: 40,
//                             padding: EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.green,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Rented',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headlineSmall
//                                     ?.apply(color: Colors.black),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       IconTextWidget(
//                         icon: Icons.star,
//                         txt: "4.9 (531 reviews)",
//                         colorIcon: Colors.yellow,
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Image.asset(
//                         TImages.autoBajaj,
//                         scale: 3,
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20),
//                         ),
//                       ),
// child: Padding(
//   padding: const EdgeInsets.all(20),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
// Container(
//   decoration: BoxDecoration(
//     color: TColors.secondary,
//     borderRadius: BorderRadius.circular(12),
//   ),
//   child: Padding(
//     padding: const EdgeInsets.all(12),
//     child: Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundImage: Image.asset(
//                       TImages.profile,
//                       scale: 5)
//                   .image,
//             ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Rented By',
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineSmall,
//                 ),
//                 Text(
//                   "Inas Nuzeer",
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineMedium,
//                 )
//               ],
//             ),
//           ],
//         ),
//         Row(
//           crossAxisAlignment:
//               CrossAxisAlignment.end,
//           children: [
//             IconButton(
//               onPressed: () {
//                 // Handle tap for the first icon button
//               },
//               icon: Container(
//                 width: 30,
//                 height: 30,
//                 child:
//                     Image.asset(TImages.chatIcon),
//               ),
//             ),
//             const SizedBox(width: 10),
//             IconButton(
//               onPressed: () {},
//               icon: Container(
//                 width: 30,
//                 height: 30,
//                 child: Image.asset(
//                     TImages.telephoneIcon),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ),
// ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             VehicleActionsWidget(
//                               title: "Modify",
//                               iconImg: TImages.settingsIcon,
//                               tapCal: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           AddCarDetails(vehicleType: 'car')),
//                                 );
//                               },
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             VehicleActionsWidget(
//                               title: "Track the vehicle",
//                               iconImg: TImages.trackVehicleIcon,
//                               tapCal: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => TrackVehiclePage()),
//                                 );
//                               },
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             VehicleActionsWidget(
//                               title: "Reviews",
//                               iconImg: TImages.reviewsIcon,
//                               tapCal: () {},
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/icon_text_widget.dart';
import 'package:xplorit/features/Lender_chat/chat_page.dart';
import 'package:xplorit/features/lender_review/lender_review_page.dart';
import 'package:xplorit/features/lent/AddVehicle/update_car_details_form.dart';
import 'package:xplorit/features/lent/garage/garage_vehicle_actions_widgets.dart';
import 'package:xplorit/features/lent/garage/track_vehicle.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class MyGaragePageRented extends StatefulWidget {
  const MyGaragePageRented({
    required this.renterImage,
    required this.renterId,
    required this.renterName,
    required this.vehicleId,
    required this.model,
    required this.rating,
    required this.defaultVehicleImage,
    required this.isVehicleActive,
    required this.renterContactNumber,
    Key? key,
  }) : super(key: key);
  final String vehicleId;
  final String renterId;
  final String renterImage;
  final String renterName;
  final String model;
  final String defaultVehicleImage;
  final String rating;
  final bool isVehicleActive;
  final String renterContactNumber;

  @override
  State<MyGaragePageRented> createState() => _MyGaragePageRentedState();
}

class _MyGaragePageRentedState extends State<MyGaragePageRented> {
  bool isSwitched = false;
  String switchText = 'Dectivate';
  final vehicleController = Get.put(VehicleController());

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // await fetchVehicleData();
  }

  // Future<void> fetchVehicleData() async {
  // await vehicleController.fetchVehicleData();
  // }

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
      body: Container(
        color: TColors.primary,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackButtonWidget(
                    btnColor: TColors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.model,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          Container(
                            width: 100,
                            height: 40,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                'Rented',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.apply(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      IconTextWidget(
                        icon: Icons.star,
                        txt: widget.rating,
                        colorIcon: Colors.yellow,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: widget.defaultVehicleImage.startsWith('http')
                              ? Image.network(
                                  widget.defaultVehicleImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.person,
                                        color: TColors.secondary,
                                        size: 60,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  widget.defaultVehicleImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
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
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: TColors.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: widget.renterImage
                                                    .startsWith('http')
                                                ? Image.network(
                                                    widget.renterImage,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          color:
                                                              TColors.secondary,
                                                          size: 60,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Image.asset(
                                                    widget.renterImage,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons.person,
                                                          color:
                                                              TColors.secondary,
                                                          size: 60,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rented By',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            Text(
                                              widget.renterName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Get.to(() => chatPage(
                                                  receiverID: widget.renterId,
                                                  receiverPhoneNumber: widget
                                                      .renterContactNumber,
                                                  displayName:
                                                      widget.renterName,
                                                  image: widget.renterImage,
                                                ));
                                          },
                                          icon: Container(
                                            width: 30,
                                            height: 30,
                                            child:
                                                Image.asset(TImages.chatIcon),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          onPressed: () {
                                            _launchDialer(
                                                widget.renterContactNumber);
                                          },
                                          icon: Container(
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                                TImages.telephoneIcon),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            VehicleActionsWidget(
                              title: "Modify",
                              iconImg: TImages.settingsIcon,
                              tapCal: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateCarDetails(
                                        vehicleId: widget.vehicleId),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            VehicleActionsWidget(
                              title: "Track the vehicle",
                              iconImg: TImages.trackVehicleIcon,
                              tapCal: () {
                                Get.to(
                                  () => TrackVehiclePage(
                                    model: widget.model,
                                    renterId: widget.renterId,
                                    renterImage: widget.renterImage,
                                    renterName: widget.renterName,
                                    defaultVehicleImage:
                                        widget.defaultVehicleImage,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            VehicleActionsWidget(
                              title: "Reviews",
                              iconImg: TImages.reviewsIcon,
                              tapCal: () {
                                Get.to(() => LenderReviewPage(
                                      editMode: false,
                                      productId: widget.vehicleId,
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
