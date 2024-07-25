import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/features/lender_review/lender_review_page.dart';
import 'package:xplorit/features/lent/homePage/home_lent.dart';

class ShowOtpPage extends StatefulWidget {
  final String garageId;
  final String vehicleId;
  final String renterId;

  ShowOtpPage(
      {super.key,
      required this.garageId,
      required this.vehicleId,
      required this.renterId});

  @override
  State<ShowOtpPage> createState() => _ShowOtpPageState();
}

class _ShowOtpPageState extends State<ShowOtpPage> {
  final vehicleController = Get.put(VehicleController());
  String vehicleName = '';
  String renterId = '';
  Future<void> removeOtp() async {
    try {
      await FirebaseFirestore.instance
          .collection('otps')
          .doc(widget.garageId)
          .delete();

      // Navigate back to the Dashboard after deleting the OTP
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomelentPage()),
      );
    } catch (e) {
      print('Error removing OTP: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    print('entered IV');
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchVehicleName();
    // await retrieveRenterId();
    print('entered V');
  }

  Future<void> fetchVehicleName() async {
    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      if (vehicle.vehicleId == widget.vehicleId) {
        vehicleName = vehicle.model;
      }
    }
  }

  Future<void> retrieveRenterId() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('otps')
          .doc(widget.garageId)
          .get();

      if (doc.exists) {
        renterId = doc['renterId'];
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('otps')
          .doc(widget.garageId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data == null) {
          // If snapshot has no data or data is null, navigate to Dashboard
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomelentPage()),
            );
          });
          return Container(); // Return empty container while navigating
        } else {
          // Check if the snapshot data is null before accessing it
          var data = snapshot.data!.data();
          if (data == null) {
            // If data is null, navigate to Dashboard
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => LenderReviewPage(
                          productId: widget.renterId,
                          editMode: true,
                        )),
                // MaterialPageRoute(builder: (context) => HomelentPage()),
              );
            });
            return Container(); // Return empty container while navigating
          }
          // String otp = data['otp'] ?? '';
          String otp = (data as Map<String, dynamic>)['otp'] ?? '';

          return Scaffold(
            appBar: AppBar(title: Text('OTP')),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 300),
                Center(
                  child: Text(
                    otp.isNotEmpty
                        ? 'Your OTP to return $vehicleName: \n$otp'
                        : 'Vehicle Returned',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: SizedBox()),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: removeOtp,
                        child: const Text('Clear OTP'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
            // Center(
            //   child: Text(
            //     otp.isNotEmpty
            //         ? 'Your OTP to return $vehicleName: $otp'
            //         : 'Vehicle Returned',
            //     style: TextStyle(fontSize: 24),
            //   ),
            // ),
          );
        }
      },
    );
  }
}
