// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';

class EnableLocation extends StatefulWidget {
  const EnableLocation({Key? key}) : super(key: key);
  @override
  State<EnableLocation> createState() => _EnableLocation();
}

class _EnableLocation extends State<EnableLocation> {
  String locationName = 'unknown';
  late GoogleMapController googleMapController;
  final isLoading = false.obs;
  //late String _currentAddress;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(31.4615, 73.1482), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showAlertDialog(context);
    });
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
        // Placemark placemark = placemarks[0];
        setState(() {
          // locationName = '${placemark.locality}, ${placemark.country}';
          Get.offAll(Dashboard());
        });
      }
    } catch (e) {}
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Image.asset(
            TImages.locationIcn,
            width: 125,
            height: 125,
          ),
          title: Text(
            'Enable your Location',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Choose your location to start find the request around you',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: Obx(
                () {
                  return isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: TColors.primary,
                            backgroundColor: Colors.transparent,
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (locationName == 'unknown') {
                                _requestLocationPermission();
                              }
                            });
                          },
                          icon: Icon(
                            Icons.place,
                            color: TColors.white,
                          ),
                          label: Text(
                            'Use my Location',
                          ),
                        );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        _showAlertDialog(context);
      } else {
        getCurrentLocation();
      }
    } else {
      getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
        ],
      ),
    );
  }
}
