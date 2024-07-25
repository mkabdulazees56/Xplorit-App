// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xplorit/Controllers/garage_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/garage_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/lent/AddVehicle/set_price_range_widget.dart';
import 'package:xplorit/features/lent/AddVehicle/text_input_re.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class AddCarDetails extends StatefulWidget {
  const AddCarDetails({
    required this.vehicleType,
    Key? key,
  });
  final String vehicleType;
  @override
  State<AddCarDetails> createState() => _AddCarDetails();
}

class _AddCarDetails extends State<AddCarDetails> {
  String selectedFuel = 'Petrol';
  List<Widget> inputFields1 = [];
  List<Widget> inputFields2 = [];
  final isLoading = false.obs;

  List<String> fuelType = [
    'Petrol',
    'Deisel',
    'N/A',
  ];

  String selectedTranmission = 'Automatic';

  List<String> tranmisssionType = [
    'Automatic',
    'Manual',
    'N/A',
  ];
  late bool isSwitched;
  late GoogleMapController googleMapController;
  late String _currentAddress = '';
  late String _showCurrentAddress = 'Address Here';

  void showPersistentDialog(
      BuildContext context, String message, VoidCallback onButtonPressed) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: onButtonPressed,
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(31.4615, 73.1482), zoom: 14);

  Set<Marker> markers = {};

  final controller = Get.put(VehicleController());
  final garageController = Get.put(GarageController());

  Future<void> addVehicleData(
    String vehicleId,
    String garageId,
    String model,
    String mileage,
    String pickupLocation,
    String fuelType,
    String transmission,
    String vehicleType,
    int seatingCapacity,
    double rentalRate,
    String rentalRateType,
    bool isVehicleActive,
    double rating,
    int noOfRating,
    List<String> vehicleImage,
    List<String> rules,
    List<String> extraFeatures,
  ) async {
    final vehicle = VehicleModel(
      vehicleId: vehicleId,
      garageId: garageId,
      model: model,
      mileage: mileage,
      pickupLocation: pickupLocation,
      fuelType: fuelType,
      transmission: transmission,
      vehicleType: vehicleType,
      seatingCapacity: seatingCapacity,
      rentalRates: rentalRate,
      rentalRateType: rentalRateType,
      isVehicleActive: isVehicleActive,
      rating: rating,
      noOfRating: noOfRating,
      rules: rules,
      extraFeatures: extraFeatures,
      vehicleImage: vehicleImage,
    );
    await VehicleController.instance.addVehicleData(vehicle, context);
  }

  User? user = FirebaseAuth.instance.currentUser;

  bool isGarageExist() {
    for (GarageModel garage in garageController.garagesData) {
      if (garage.contactNumber == user?.phoneNumber) {
        return false;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    isSwitched = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get.snackbar('Type', widget.vehicleType);
    });
    _showCurrentAddress = 'Address Here';
  }

  String vehicleId = 'v1';
  String garageId = '';
  String model = '';
  String mileage = '';
  int seatingCapacity = 0;
  int rentalRate = 0;
  bool isVehicleActive = true;
  int pricePerWeek = 0;
  double rating = 0.0;
  int noOfRating = 0;
  String extraFeature = '';

  List<String> extraFeatures = List.filled(30, '');
  List<String> rules = List.filled(30, '');
  List<String> vehicleImage = [];

  int rulesIndex = 2;
  int imageIndex = 0;
  int extraFeaturesIndex = 0;
  List<XFile> selectedImages = [];
  bool isImageSelected = false;

  String rentalRateType = 'Per day';
  // int pricePerHour = 40;
  // int pricePerDay = 1500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonWidget(),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add your ${widget.vehicleType} details',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: TColors.greyMy,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (selectedImages.isEmpty) ...[
                            Image(
                              image: AssetImage(TImages.addPhotoIcon),
                              height: 60,
                            ),
                            SizedBox(height: 15),
                          ] else ...[
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedImages.length,
                                itemBuilder: (context, index) {
                                  XFile image = selectedImages[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.file(
                                              File(image.path),
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: TColors.primary),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                              ),
                                              child: IconButton(
                                                icon: Icon(Icons.delete_forever,
                                                    color: TColors.secondary),
                                                onPressed: () {
                                                  setState(() {
                                                    selectedImages
                                                        .removeAt(index);
                                                    isImageSelected =
                                                        selectedImages
                                                            .isNotEmpty;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          SizedBox(height: 15),
                          SizedBox(
                            width: 200,
                            child: Obx(
                              () {
                                return isLoading.value
                                    ? Center(child: CircularProgressIndicator())
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: ElevatedButton(
                                          onPressed: selectedImages.length == 4
                                              ? null
                                              : () async {
                                                  isLoading.value = true;
                                                  try {
                                                    List<XFile>? images =
                                                        await ImagePicker()
                                                            .pickMultiImage();
                                                    if (images != null &&
                                                        images.isNotEmpty) {
                                                      if ((selectedImages
                                                                  .length +
                                                              images.length) >
                                                          4) {
                                                        Get.snackbar(
                                                          'Oops!',
                                                          'You can select only up to 4 Images.',
                                                        );
                                                      } else {
                                                        setState(() {
                                                          selectedImages
                                                              .addAll(images);
                                                          isImageSelected =
                                                              selectedImages
                                                                  .isNotEmpty;
                                                        });
                                                      }
                                                    }
                                                  } finally {
                                                    isLoading.value = false;
                                                  }
                                                },
                                          child: Text('Upload Images'),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Add Car Features',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.apply(color: TColors.greyDark),
                        ),
                        Text(
                          ' *',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.apply(color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        InputTextWidgetRe(
                          keyboardType: TextInputType.text,
                          hintText: 'Model',
                          index: 0,
                          onChanged: (value, index) {
                            setState(() {
                              model = value;
                            });
                          },
                        ),
                        Visibility(
                          visible: widget.vehicleType != 'bicycle',
                          child: InputTextWidgetRe(
                            keyboardType: TextInputType.number,
                            hintText: 'Seating Capacity',
                            index: 0,
                            onChanged: (value, index) {
                              setState(() {
                                seatingCapacity = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.vehicleType != 'bicycle',
                          child: InputTextWidgetRe(
                            keyboardType: TextInputType.text,
                            hintText: 'Mileage',
                            index: 0,
                            onChanged: (value, index) {
                              setState(() {
                                mileage = value;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.vehicleType != 'bicycle' &&
                              widget.vehicleType != 'motor bike',
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: TColors.darkGrey, width: 1),
                                borderRadius: BorderRadius.circular(12),
                                color: TColors.secondary),
                            child: DropdownButton<String>(
                              value: selectedFuel,
                              dropdownColor: TColors.white,
                              icon: const Icon(Icons.expand_more),
                              isExpanded: true,
                              underline: Container(
                                // height: 1,
                                color: TColors.primary,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedFuel = newValue!;
                                });
                              },
                              items: fuelType.map((selectedFuel) {
                                return DropdownMenuItem(
                                  value: selectedFuel,
                                  child: Text(selectedFuel),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: widget.vehicleType != 'bicycle' &&
                          widget.vehicleType != 'rickshaw',
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: TColors.darkGrey, width: 1),
                            borderRadius: BorderRadius.circular(12),
                            color: TColors.secondary),
                        child: DropdownButton<String>(
                          hint: Text('Select Transmission'),
                          value: selectedTranmission,
                          dropdownColor: TColors.white,
                          icon: const Icon(Icons.expand_more),
                          isExpanded: true,
                          underline: Container(
                            color: TColors.accent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTranmission = newValue!;
                            });
                          },
                          items: tranmisssionType.map((selectedTranmission) {
                            return DropdownMenuItem(
                              value: selectedTranmission,
                              child: Text(selectedTranmission),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ...inputFields1,
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: TColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TColors.darkGrey, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add more features',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        IconButton(
                          icon: Icon(Icons.add_rounded),
                          color: TColors.primary,
                          onPressed: () {
                            setState(() {
                              inputFields1.add(InputTextWidgetRe(
                                keyboardType: TextInputType.text,
                                hintText: 'Add a new feature',
                                index: extraFeaturesIndex,
                                onChanged: (value, index) {
                                  setState(() {
                                    try {
                                      extraFeatures[index] = value;
                                    } catch (e) {
                                      Get.snackbar('Error', '$e');
                                    }
                                  });
                                  print("Extra features: $extraFeatures");
                                },
                              ));
                              ++extraFeaturesIndex;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Set Rental Rates',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: TColors.greyDark),
                    ),
                    Text(
                      ' *',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // SetPriceRangeWidget(
                //   division: 10,
                //   priceTitle: "Per hour price",
                //   minimumPrice: 40,
                //   maximumPrice: 120,
                //   initialHigherPrice: 100,
                //   onChanged: (value) {
                //     pricePerHour = value.toInt();
                //     print("Price per hour: $value");
                //   },
                // ),
                // const SizedBox(height: 10),
                // SetPriceRangeWidget(
                //   division: 100,
                //   priceTitle: "Per day price",
                //   minimumPrice: 1500,
                //   maximumPrice: 2500,
                //   initialHigherPrice: 1750,
                //   onChanged: (value) {
                //     pricePerDay = value.toInt();
                //     print("Price per day: $value");
                //   },
                // ),
                DropdownButton<String>(
                  value: rentalRateType,
                  onChanged: (String? newValue) {
                    setState(() {
                      rentalRateType = newValue!;
                    });
                  },
                  items: <String>['Per hour', 'Per day']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                if (rentalRateType == 'Per day')
                  SetPriceRangeWidget(
                    division: 95,
                    priceTitle: "Per day price",
                    minimumPrice: 500.0,
                    maximumPrice: 10000.0,
                    initialHigherPrice: rentalRate.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        rentalRate = value.toInt();
                      });
                      print("Price per day: $value");
                    },
                  ),
                if (rentalRateType == 'Per hour')
                  SetPriceRangeWidget(
                    division: 24,
                    priceTitle: "Per hour price",
                    minimumPrice: 100.0,
                    maximumPrice: 2500.0,
                    initialHigherPrice: rentalRate.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        rentalRate = value.toInt();
                      });
                      print("Price per hour: $value");
                    },
                  ),
                const SizedBox(height: 10),
                // SetPriceRangeWidget(
                //   division: 100,
                //   priceTitle: "Per week price",
                //   minimumPrice: 5200,
                //   maximumPrice: 10000,
                //   initialHigherPrice: 7500,
                //   onChanged: (value) {
                //     pricePerWeek = value.toInt();
                //     print("Price per week: $value");
                //   },
                // ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Set Pick Up Location',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: TColors.greyDark),
                    ),
                    Text(
                      ' *',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedBTN(
                  titleBtn: 'Use my location',
                  btnColor: TColors.grey,
                  textColor: TColors.black,
                  onTapCall: () async {
                    print('Extra Features: $extraFeatures');
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
                        position: LatLng(position.latitude, position.longitude),
                      ),
                    );

                    setState(() {
                      _showCurrentAddress = 'Fetching address...';
                    });
                    _fetchAddress(position);
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  height: 400,
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
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: 14,
                              ),
                            ));

                            markers.clear();

                            markers.add(
                              Marker(
                                markerId: const MarkerId('currentLocation'),
                                position: LatLng(
                                    position.latitude, position.longitude),
                              ),
                            );

                            setState(() {
                              _showCurrentAddress =
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
                const SizedBox(height: 10),
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
                      child: Text(
                        _showCurrentAddress,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 18, color: Colors.green),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Add Rules and Requirements',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: TColors.greyDark),
                    ),
                    Text(
                      ' *',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(children: [
                  InputTextWidgetRe(
                    keyboardType: TextInputType.text,
                    index: 0,
                    hintText: 'Eg :- 21 years and above',
                    onChanged: (value, index) {
                      setState(() {
                        rules[0] = value;
                        print("Rules Index: $rules");
                      });
                    },
                  ),
                  InputTextWidgetRe(
                    keyboardType: TextInputType.text,
                    hintText: 'Eg :- Valid driver\'s license required',
                    index: 1,
                    onChanged: (value, index) {
                      rules[1] = value;
                      print("Rules Index: $rules");
                    },
                  ),
                  ...inputFields2,
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: TColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: TColors.darkGrey, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add more rules and requirments',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall, // Text color
                          ),
                          IconButton(
                            icon: Icon(Icons.add_rounded),
                            color: TColors.primary,
                            onPressed: () {
                              // Add a new input field when the button is pressed
                              setState(() {
                                inputFields2.add(InputTextWidgetRe(
                                  keyboardType: TextInputType.text,
                                  hintText: 'Add more rules and requirments',
                                  index: rulesIndex,
                                  onChanged: (value, index) {
                                    setState(() {
                                      try {
                                        rules[index] = value;
                                      } catch (e) {
                                        Get.snackbar('Error', '$e');
                                      }
                                    });
                                    print("Added Rules are as follows: $rules");
                                  },
                                ));
                                ++rulesIndex;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () {
                      return isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: TColors.primary,
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                isLoading.value = true;
                                try {
                                  List<String> errorField = [];
                                  if (model == '') {
                                    errorField.add('Model');
                                  }
                                  if (seatingCapacity == 0) {
                                    errorField.add('Seating capacity');
                                  }
                                  if (mileage == '') {
                                    errorField.add('Mileage');
                                  }
                                  if (rentalRate == 0) {
                                    errorField.add('Rental Rate');
                                  }
                                  if (_showCurrentAddress == 'Address Here') {
                                    errorField.add('Address');
                                  }
                                  if (rules.isEmpty || rules == []) {
                                    errorField.add('Rules and Requirements');
                                  }
                                  if (selectedImages == [] ||
                                      selectedImages.isEmpty) {
                                    errorField.add('Select at least 1 image.');
                                  }

                                  if (errorField.isEmpty || errorField == []) {
                                    vehicleImage = await controller
                                        .uploadVehicleImage(selectedImages);
                                    setState(() {
                                      for (GarageModel garage
                                          in garageController.garagesData) {
                                        if (garage.contactNumber ==
                                            user?.phoneNumber) {
                                          garageId = garage.garageId;
                                        }
                                      }
                                      List<String> mutableExtraFeatures =
                                          List.from(extraFeatures);
                                      List<String> mutableRules =
                                          List.from(rules);

                                      mutableExtraFeatures.removeWhere(
                                          (element) => element.isEmpty);
                                      extraFeatures =
                                          List.from(mutableExtraFeatures);
                                      extraFeatures.removeWhere(
                                          (element) => element.isEmpty);

                                      mutableRules.removeWhere(
                                          (element) => element.isEmpty);
                                      rules = List.from(mutableRules);
                                      rules.removeWhere(
                                          (element) => element.isEmpty);

                                      if (widget.vehicleType == 'bicycle') {
                                        selectedTranmission = 'N/A';
                                      }
                                      if (widget.vehicleType == 'rickshaw') {
                                        selectedTranmission = 'Manual';
                                      }

                                      if (widget.vehicleType == 'motor bike' ||
                                          widget.vehicleType == 'bicycle') {
                                        selectedFuel = 'N/A';
                                      }

                                      if (widget.vehicleType == 'bicycle') {
                                        seatingCapacity = 0;
                                        mileage = 'N/A';
                                      }

                                      addVehicleData(
                                        vehicleId,
                                        garageId,
                                        model,
                                        mileage,
                                        _currentAddress,
                                        selectedFuel,
                                        selectedTranmission!,
                                        widget.vehicleType,
                                        seatingCapacity,
                                        rentalRate.toDouble(),
                                        rentalRateType,
                                        isVehicleActive,
                                        rating,
                                        noOfRating,
                                        vehicleImage,
                                        rules,
                                        extraFeatures,
                                      );
                                    });
                                  } else {
                                    Get.snackbar(
                                      'Empty Fields: ',
                                      duration: Duration(seconds: 4),
                                      errorField.join(", "),
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      margin: EdgeInsets.all(15),
                                      colorText: Colors.white,
                                      icon: Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ), // Add prefix icon
                                    );
                                  }
                                } finally {
                                  isLoading.value = false;
                                }
                              },
                              child: Text("Save"),
                            );
                    },
                  ),
                ),
                // ElevatedBTN(
                //     titleBtn: 'Save',
                //     onTapCall: () {
                //       // extraFeatures.removeWhere((element) => element.isEmpty);
                //       // rules.removeWhere((element) => element.isEmpty);

                //       addVehicleData(
                //         model,
                //         mileage,
                //         _currentAddress,
                //         selectedFuel,
                //         selectedTranmission!,
                //         seatingCapacity,
                //         pricePerHour,
                //         pricePerDay,
                //         pricePerWeek,
                //         rating,
                //         vehicleImage,
                //         rules,
                //         extraFeatures,
                //       );
                //       // Get.to(RequestForRent());
                //     }),
                DividerWidget()
              ],
            ),
          ),
        ), //main Column
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
          _currentAddress = '${position.longitude},${position.latitude}';
          _showCurrentAddress =
              '${placemark.name ?? ''}, ${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.subAdministrativeArea ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''}';
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
