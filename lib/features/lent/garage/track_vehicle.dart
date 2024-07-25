// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/features/lent/garage/track_vehicle_card_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';

class TrackVehiclePage extends StatefulWidget {
  const TrackVehiclePage(
      {required this.model,
      required this.renterId,
      required this.renterName,
      required this.renterImage,
      required this.defaultVehicleImage,
      Key? key})
      : super(key: key);

  final String model;
  final String renterId;
  final String renterName;
  final String renterImage;
  final String defaultVehicleImage;

  @override
  _TrackVehiclePageState createState() => _TrackVehiclePageState();
}

class _TrackVehiclePageState extends State<TrackVehiclePage> {
  final renterController = Get.put(RenterController());

  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(31.4615, 73.1482), zoom: 14);

  Set<Marker> markers = {};
  String _currentVehicleLocation = '';

  double latitude = 0.0;
  double longitude = 0.0;

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeData();
  // }
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

// if(user?.phoneNumber == garage.garageId)
  Future<void> _initializeData() async {
    await fetchRenterData();
    _currentVehicleLocation = await _fetchAddressName();
  }

  Future<void> fetchRenterData() async {
    await renterController.fetchRenterData();
    for (RenterModel renter in renterController.rentersData) {
      if (renter.renterId == widget.renterId) {
        latitude = renter.latitude;
        longitude = renter.longitude;
      }
    }
  }

  Future<String> _fetchAddressName() async {
    String _currentVehicleLocation = '';
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _currentVehicleLocation =
              '${placemark.name ?? ''}, ${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.subAdministrativeArea ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''}' ??
                  '';
        });
      }
    } catch (e) {
      print('Error fetching address: $e');

      _currentVehicleLocation = 'Error fetching address';
    }
    return _currentVehicleLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: BackButtonWidget(
                btnColor: TColors.black,
              ),
            ),
            TrackVehicleCardWidget(
              renderImg: widget.renterImage,
              renterName: widget.renterName,
              vehicleImg: widget.defaultVehicleImage,
              vehicleName: widget.model,
              imgScale: 3,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                _currentVehicleLocation != '' ? _currentVehicleLocation : '',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            )),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Position position = await _determinePosition();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 14,
            ),
          ));

          markers.clear();

          markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(latitude, longitude),
            ),
          );

          setState(() {});
        },
        label: const Text(
          "Show current location of the vehicle",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.my_location_sharp,
          color: Colors.white,
        ),
        backgroundColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }

  // Future<Position> _determinePosition(Position position) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled');
  //   }

  //   permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();

  //     if (permission == LocationPermission.denied) {
  //       return Future.error("Location permission denied");
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('Location permissions are permanently denied');
  //   }

  //   // Position position = await Geolocator.getCurrentPosition();

  //   return position;
  // }
}
