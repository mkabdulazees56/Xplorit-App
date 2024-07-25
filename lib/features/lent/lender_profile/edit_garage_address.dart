// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';

class EditGarageAddress extends StatefulWidget {
  EditGarageAddress({
    required this.garageAddress,
    super.key,
  });

  final String garageAddress;
  @override
  State<EditGarageAddress> createState() => _EditGarageAddressState();
}

class _EditGarageAddressState extends State<EditGarageAddress> {
  late GoogleMapController googleMapController;
  late String _currentAddress;
  User? user = FirebaseAuth.instance.currentUser;
  String? garageId = '';
  String garageName = '';
  bool isRefreshed = false;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(31.4615, 73.1482), zoom: 14);

  Set<Marker> markers = {};

  final garageController = Get.put(GarageController());

  void updateGarageData(String address, String garageName) {
    final garage = GarageModel(
      garageId: garageId!,
      userName: garageName,
      address: address,
      contactNumber: user?.phoneNumber,
    );
    GarageController.instance.updateGarageData(garageId!, garage);
  }

  Future<void> fetchGarageData() async {
    // await garageController.fetchGarageData();
    setState(() {
      for (GarageModel garage in garageController.garagesData) {
        if (garage.contactNumber == user?.phoneNumber) {
          garageId = garage.garageId;
          _currentAddress = garage.address;
          garageName = garage.userName;
        }
      }
    });
  }

  void refreshPage() {
    setState(() {
      isRefreshed = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentAddress = 'Address Here';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGarageData();
    });
    refreshPage();
  }

  Future<List<Widget>> _buildGarageWidgets() async {
    List<Widget> garageWidgets = [];

    garageWidgets.add(
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                size: 40,
                color: TColors.primary,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _currentAddress,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 18, color: Colors.green),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 500,
            child: Stack(
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
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () async {
                      Position position = await _determinePosition();

                      googleMapController
                          .animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 14,
                        ),
                      ));

                      markers.clear();

                      markers.add(
                        Marker(
                          markerId: const MarkerId('currentLocation'),
                          position:
                              LatLng(position.latitude, position.longitude),
                        ),
                      );

                      setState(() {
                        _currentAddress =
                            'Fetching address...'; // Placeholder until the address is fetched
                      });
                      _fetchAddress(position);
                    },
                    backgroundColor: TColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(
                      Icons.my_location_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                updateGarageData(_currentAddress, garageName);
              },
              child: Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
    return garageWidgets;
  }

  Widget garageForm() {
    return Obx(() {
      if (garageController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (garageController.garagesData.isEmpty) {
        return Text('No garage data available');
      } else {
        return FutureBuilder<List<Widget>>(
          future: _buildGarageWidgets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!,
              );
            }
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(
                  btnColor: TColors.black,
                ),
              ),
              Text("Set Address",
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: TColors.secondary,
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search address",
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              garageForm(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchAddress(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _currentAddress =
              '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}';
        });
      }
    } catch (e) {
      print('Error fetching address: $e');
      setState(() {
        _currentAddress = 'Error fetching address';
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
