// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class TapToReview extends StatefulWidget {
//   @override
//   _TapToReviewState createState() => _TapToReviewState();
// }

// class _TapToReviewState extends State<TapToReview> {
//   double _rating = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Tell others what you think of this vehicle',
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//             SizedBox(height: 15),
//         Row(
//           children: [
//             Text(
//               'Tap to rate : ',
//               style: TextStyle(fontSize: 20)
//             ),
//             SizedBox(height: 10),
//             RatingBar.builder(
//               initialRating: 0,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: false,
//               itemCount: 5,
//               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//               itemBuilder: (context, _) => Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   _rating = rating;
//                 });
//               },
//             ),
//           ],
//         ),
//         SizedBox(height: 24),
//         Text(
//           'Your rating: $_rating',
//           style: TextStyle(fontSize: 20),
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/review_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Models/review_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';
import 'package:xplorit/utils/constants/colors.dart';

class LenderTapToReview extends StatefulWidget {
  // final Function(double rating, String review) onSubmit;
  final String productId;

  LenderTapToReview(
      {
      // required this.onSubmit,
      required this.productId});

  @override
  _LenderTapToReviewState createState() => _LenderTapToReviewState();
}

class _LenderTapToReviewState extends State<LenderTapToReview> {
  bool isVehicle = false;
  double _rating = 0;
  double newRating = 0.0;
  int newNoOfRating = 0;
  String garageId = '';
  String renterId = '';
  final reviewController = Get.put(ReviewController());
  final renterController = Get.put(RenterController());
  final vehicleController = Get.put(VehicleController());
  final garageController = Get.put(GarageController());
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchRaterId();
  }

  Future<void> fetchRaterId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userPhoneNumber = user.phoneNumber ?? '';
      for (RenterModel renter in renterController.rentersData) {
        if (userPhoneNumber == renter.contactNumber) {
          renterId = renter.renterId;
        }
      }
      for (GarageModel garage in garageController.garagesData) {
        if (userPhoneNumber == garage.contactNumber) {
          garageId = garage.garageId;
        }
      }
    }
  }

  addReview(String raterId, double rating, String review) {
    final newReview = ReviewModel(
      productId: widget.productId,
      reviewId: 'rvwId',
      raterId: raterId,
      rating: rating,
      review: review,
      timestamp: Timestamp.now(),
    );
    reviewController.addReviewData(newReview);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell others what you think of this vehicle',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 15),
        const Text(
          'Tap to rate: ',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 15),
        RatingBar.builder(
          initialRating: 0,
          minRating: 0.5,
          direction: Axis.horizontal,
          glow: false,
          allowHalfRating: true, // Allow half and fractional ratings
          itemCount: 5,
          itemSize: 50,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        ),
        // RatingBar.builder(
        //   initialRating: 0,
        //   minRating: 1,
        //   direction: Axis.horizontal,
        //   allowHalfRating: false,
        //   itemCount: 5,
        //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        //   itemBuilder: (context, _) => Icon(
        //     Icons.star,
        //     color: Colors.amber,
        //   ),
        //   onRatingUpdate: (rating) {
        //     setState(() {
        //       _rating = rating;
        //     });
        //   },
        // ),
        SizedBox(height: 24),
        Text(
          'Your rating: $_rating',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _reviewController,
          decoration: InputDecoration(
            labelText: 'Write your review',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // widget.onSubmit(_rating, _reviewController.text);
                  // _reviewController.clear();
                  // setState(() {
                  //   _rating = 0;
                  // });
                  for (VehicleModel vehicle in vehicleController.vehiclesData) {
                    if (widget.productId == vehicle.vehicleId) {
                      newNoOfRating = vehicle.noOfRating + 1;
                      newRating = (vehicle.rating) * (vehicle.noOfRating);
                      newRating = newRating / newNoOfRating;
                      newRating = double.parse(newRating.toStringAsFixed(2));

                      vehicleController.updateVehicleReview(
                          widget.productId, newRating, newNoOfRating);

                      addReview(renterId, _rating, _reviewController.text);

                      Get.offAll(() => Dashboard());

                      isVehicle = true;
                      break;
                    }
                  }
                  if (!isVehicle) {
                    for (RenterModel renter in renterController.rentersData) {
                      if (widget.productId == renter.renterId) {
                        newNoOfRating = renter.noOfRating + 1;
                        newRating = (renter.rating) * (renter.noOfRating);
                        newRating = newRating / newNoOfRating;
                        newRating = double.parse(newRating.toStringAsFixed(2));

                        renterController.updateRenterReview(
                            widget.productId, newRating, newNoOfRating);

                        Get.offAll(() => HomelentPage());

                        addReview(garageId, _rating, _reviewController.text);

                        isVehicle = false;
                        break;
                      }
                    }
                  }
                },
                child: Text('Submit Review'),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  for (VehicleModel vehicle in vehicleController.vehiclesData) {
                    if (widget.productId == vehicle.vehicleId) {
                      Get.offAll(() => Dashboard());
                      isVehicle = true;
                    }
                  }
                  if (!isVehicle) {
                    for (RenterModel renter in renterController.rentersData) {
                      if (widget.productId == renter.renterId) {
                        Get.offAll(() => HomelentPage());
                      }
                    }
                  }
                },
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.secondary,
                    foregroundColor: TColors.primary
                    // Change background color here
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StarDisplay extends StatelessWidget {
  final double value;

  const StarDisplay({Key? key, this.value = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }
}
