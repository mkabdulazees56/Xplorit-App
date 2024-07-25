// // ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:xplorit/features/review/product_info_widget.dart';
// import 'package:xplorit/features/review/rating_summery_widget.dart';
// import 'package:xplorit/features/review/review_item.dart';
// import 'package:xplorit/features/review/taptoreview.dart';
// import 'package:xplorit/utils/constants/image_strings.dart';

// class LenderReviewPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   BackButton(),
//                   Expanded(
//                     child: Text('Reviews',
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.headlineLarge),
//                   ),
//                   SizedBox(width: 48),
//                 ],
//               ),
//               SizedBox(height: 16.0),
//               ProductInfo(),
//               SizedBox(height: 16.0),
//               RatingSummary(),
//               Divider(thickness: 1.0),
//               TapToReview(),
//               Divider(thickness: 1.0),

//               ReviewItem(
//                 name: 'Jinny Oslin',
//                 review:
//                     'Outstanding company! Top-notch service and excellent products.',
//                 date: '1 day ago',
//                 rating: 2,
//                 avatar: TImages.rickshaw,
//               ),
//               ReviewItem(
//                 name: 'Jane Barry',
//                 review:
//                     'I had a fantastic experience with the company. Their exceptional customer service and high-quality products exceeded my expectations.',
//                 date: '5 days ago',
//                 rating: 4.5,
//                 avatar: TImages.profile,
//               ),
//               ReviewItem(
//                 name: 'Jane Barry',
//                 review:
//                     'I had a fantastic experience with the company. Their exceptional customer service and high-quality products exceeded my expectations.',
//                 date: '5 days ago',
//                 rating: 4,
//                 avatar: TImages.rickshaw,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StarDisplay extends StatelessWidget {
//   final double value;

//   const StarDisplay({Key? key, this.value = 0}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(5, (index) {
//         return Icon(
//           index < value ? Icons.star : Icons.star_border,
//           color: Colors.amber,
//         );
//       }),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/review_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Models/review_model.dart';
import 'package:xplorit/features/lender_review/lender_review_item.dart';
import 'package:xplorit/features/lender_review/lender_tap_to_review.dart';
import 'package:xplorit/features/lender_review/product_info_widget.dart';
import 'package:xplorit/features/lender_review/rating_summery_widget.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class LenderReviewPage extends StatefulWidget {
  final String productId;
  final bool editMode;
  const LenderReviewPage({required this.productId, required this.editMode});

  @override
  _LenderReviewPageState createState() => _LenderReviewPageState();
}

class _LenderReviewPageState extends State<LenderReviewPage> {
  String raterName = '';
  String raterImage = '';
  List<Review> reviews = [];
  bool isVehicle = false;

  final reviewController = Get.put(ReviewController());
  final renterController = Get.put(RenterController());
  final garageController = Get.put(GarageController());

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchReview();
  }

  Future<void> fetchReview() async {
    for (ReviewModel review in reviewController.reviewsData) {
      if (review.productId == widget.productId) {
        for (RenterModel renter in renterController.rentersData) {
          if (renter.renterId == review.raterId) {
            try {
              if (renter.profilePicture.isNotEmpty) {
                raterImage = renter.profilePicture;
              } else {
                raterImage = TImages.profile;
              }
            } catch (e) {
              raterImage = TImages.profile;
            }
            // raterImage = renter.profilePicture;
            raterName = renter.userName;
            isVehicle = true;
          }
        }
        if (!isVehicle) {
          for (GarageModel garage in garageController.garagesData) {
            if (garage.garageId == review.raterId) {
              raterImage = TImages.garageIcon;
              raterName = garage.userName;
              isVehicle = false;
            }
          }
        }
        DateTime widgetDate = review.timestamp.toDate();

        // Calculate the difference between current date and widget date
        Duration difference = DateTime.now().difference(widgetDate);

        // Convert the difference to days
        int daysDifference = difference.inDays;

        reviews.add(
          Review(
              name: raterName,
              review: review.review,
              date: '$daysDifference days ago',
              rating: review.rating,
              avatar: raterImage),
        );
      }
    }
  }

  // void _addReview(double rating, String reviewText) {
  //   Get.snackbar(rating.toString(), reviewText);
  // setState(() {
  //   reviews.add(Review(
  //     name: 'Anonymous',
  //     review: reviewText,
  //     date: 'Just now',
  //     rating: rating,
  //     avatar: TImages.profile,
  //   ));
  // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // BackButton(),
                  // if (!widget.editMode)
                  //   TextButton.icon(
                  //     onPressed: () {
                  //       if (isVehicle) {
                  //         Get.offAll(() => HomelentPage());
                  //       } else if() {
                  //         Get.offAll(() => Dashboard());
                  //       }
                  //     },
                  //     icon: Icon(
                  //       Icons.arrow_back_ios_new,
                  //       size: 15,
                  //       color: Colors
                  //           .black, // Use btnColor if provided, otherwise use default color
                  //     ),
                  //     label: Text(
                  //       'Back',
                  //       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  //           color: Colors
                  //               .black), // Use btnColor if provided, otherwise use default color
                  //     ),
                  //   ),
                  Expanded(
                    child: Text('Reviews',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  SizedBox(width: 48),
                ],
              ),

              //
              //
              //
              //
              //

              SizedBox(height: 16.0),
              LenderProductInfo(productId: widget.productId),
              SizedBox(height: 16.0),
              LenderRatingSummary(productId: widget.productId),
              Divider(thickness: 1.0),
              if (widget.editMode)
                LenderTapToReview(
                  productId: widget.productId,
                  //  onSubmit: _addReview
                ),
              if (widget.editMode) Divider(thickness: 1.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return LenderReviewItem(
                    name: review.name,
                    review: review.review,
                    date: review.date,
                    rating: review.rating,
                    avatar: review.avatar,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Review {
  final String name;
  final String review;
  final String date;
  final double rating;
  final String avatar;

  Review({
    required this.name,
    required this.review,
    required this.date,
    required this.rating,
    required this.avatar,
  });
}
