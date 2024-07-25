import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/completed_rent_controller.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/completed_rent_model.dart';
import 'package:xplorit/Models/rented_vehicle_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/features/lender_review/lender_review_page.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class EnterRentOtp extends StatefulWidget {
  final String renterId;
  final String garageId;
  final String vehicleId;

  const EnterRentOtp({
    super.key,
    required this.renterId,
    required this.vehicleId,
    required this.garageId,
  });

  @override
  State<EnterRentOtp> createState() => _EnterOtpRentState();
}

class _EnterOtpRentState extends State<EnterRentOtp> {
  final TextEditingController _otpController = TextEditingController();

  final renterController = Get.put(RenterController());
  final garageController = Get.put(GarageController());
  final bookingController = Get.put(BookingController());
  final vehicleController = Get.put(VehicleController());
  final completedRentController = Get.put(CompletedRentController());
  final rentedVehicleController = Get.put(RentedVehicleController());
  String vehicleId = '';
  String rentId = '';
  String garageId = '';
  String bookingId = '';
  Timestamp endDate = Timestamp.now();
  Timestamp startDate = Timestamp.now();
  int duration = 0;
  double rentalRate = 0.0;
  int rentedDuration = 0;
  final isLoading = false.obs;
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _validateOtp() async {
    String enteredOtp = _otpController.text.trim();
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('otps')
        .doc(widget.garageId)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      String savedOtp = data['otp'];
      setState(() {
        _isOtpValid = enteredOtp == savedOtp;
      });
    }
    return _isOtpValid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButtonWidget(),
                const SizedBox(
                  height: 60,
                ),
                const Row(
                  children: [
                    Image(
                      width: 55,
                      height: 55,
                      image: AssetImage(TImages.logo),
                    ),
                    Image(
                      width: 200,
                      height: 60,
                      image: AssetImage(TImages.title),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Enter the otp sent to the lender to return the vehicle',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 60,
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Verify otp number.',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
                Pinput(
                  length: 6,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onChanged: (value) {
                    print(value);
                  },
                  controller: _otpController,
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () {
                      return isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: TColors.primary,
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                isLoading.value = true;
                                try {
                                  _isOtpValid = await _validateOtp();

                                  if (_isOtpValid) {
                                    for (RentedVehicleModel rentedVehicle
                                        in rentedVehicleController
                                            .rentedvehiclesData) {
                                      if (widget.renterId ==
                                          rentedVehicle.renterId) {
                                        vehicleId = rentedVehicle.vehicleId;
                                        rentId = rentedVehicle.rentId;
                                        rentedVehicleController
                                            .removeRentedVehicleData(
                                                rentedVehicle.rentId);
                                      }
                                    }
                                    for (BookingModel booking
                                        in bookingController.bookingsData) {
                                      if (widget.renterId == booking.renterId) {
                                        bookingId = booking.bookingId;
                                        duration = booking.duration;
                                        endDate = booking.endDate;
                                        startDate = booking.startDate;
                                        rentedDuration = booking.duration;
                                        bookingController.removeBookingData(
                                            booking.bookingId);
                                      }
                                    }

                                    for (VehicleModel vehicle
                                        in vehicleController.vehiclesData) {
                                      if (vehicle.vehicleId == vehicleId) {
                                        garageId = vehicle.garageId;
                                        rentalRate = vehicle.rentalRates;
                                      }
                                    }

                                    double earning =
                                        rentalRate * rentedDuration;

                                    final completedRent = CompletedRentModel(
                                      completedRentId: 'cmb1',
                                      // bookingId: bookingId,
                                      duration: duration,
                                      endDate: endDate,
                                      startDate: startDate,
                                      renterId: widget.renterId,
                                      vehicleId: vehicleId,
                                      garageId: garageId,
                                      rentId: rentId,
                                      earning: earning,
                                    );

                                    completedRentController
                                        .addCompletedRentData(completedRent);

                                    vehicleController.updateVehicleActiveStatus(
                                        vehicleId, true);
                                    renterController.updateRenterActiveStatus(
                                        widget.renterId, false);

                                    await FirebaseFirestore.instance
                                        .collection('otps')
                                        .doc(widget.garageId)
                                        .delete();

                                    Get.offAll(
                                      () => LenderReviewPage(
                                        productId: widget.vehicleId,
                                        editMode: true,
                                      ),
                                    );

                                    // Get.snackbar(
                                    //     'OTP Valid', 'OTP entered is valid!',
                                    //     snackPosition: SnackPosition.BOTTOM,
                                    //     colorText:
                                    //         Color.fromARGB(255, 0, 255, 0),
                                    //     duration: const Duration(seconds: 3),
                                    //     margin: const EdgeInsets.all(20),
                                    //     backgroundColor: Colors.white);
                                  } else {
                                    Get.snackbar('Invalid OTP',
                                        'The entered OTP is incorrect',
                                        snackPosition: SnackPosition.BOTTOM,
                                        colorText: const Color.fromARGB(
                                            255, 255, 0, 0),
                                        duration: const Duration(seconds: 3),
                                        margin: const EdgeInsets.all(20),
                                        backgroundColor: Colors.white);
                                  }
                                } catch (ex) {
                                  Get.snackbar('Error', 'Something went wrong',
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText:
                                          const Color.fromARGB(255, 255, 0, 0),
                                      duration: const Duration(seconds: 3),
                                      margin: const EdgeInsets.all(20),
                                      backgroundColor: Colors.white);
                                } finally {
                                  isLoading.value = false;
                                }
                              },
                              child: const Text(
                                'Submit Code',
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
