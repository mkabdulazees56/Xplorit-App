// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
// import 'dart:html';
// import 'dart:io';

// import 'dart:html' as html;
// import 'dart:io' as io;

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
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/features/lent/AddVehicle/set_price_range_widget.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class UpdateCarDetails extends StatefulWidget {
  const UpdateCarDetails({
    required this.vehicleId,
    Key? key,
  });
  final String vehicleId;
  @override
  State<UpdateCarDetails> createState() => _UpdateCarDetails();
}

class _UpdateCarDetails extends State<UpdateCarDetails> {
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
  String _showCurrentAddress = 'Address Here';

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(31.4615, 73.1482), zoom: 14);

  Set<Marker> markers = {};

  final controller = Get.put(VehicleController());
  final garageController = Get.put(GarageController());

  void updateVehicleData(
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
  ) {
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
    VehicleController.instance.updateVehicleData(vehicleId, vehicle);
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    isSwitched = false;
    vehicleId = widget.vehicleId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGarageData();
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
  double rating = 0.0;
  int noOfRating = 0;
  // String extraFeature = '';
  String rentalRateType = 'Per day';
  String vehicleType = '';
  List<String> extraFeatures = List.filled(30, '');
  List<String> rules = List.filled(30, '');
  List<String> vehicleImage = [];

  int rulesIndex = 2;
  int imageIndex = 0;
  int extraFeaturesIndex = 0;
  List<XFile> selectedImages = [];
  bool isImageSelected = false;

  String vehicleCity = '';
  Widget TextFieldVehicle(
      String labelText,
      int index,
      TextInputType keyboardType,
      String hintText,
      Function(String, int) onChanged,
      final Function(int) onClose,
      bool isList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$hintText: '),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: keyboardType,
                onChanged: (value) {
                  // Pass both the value and index to the parent onChanged callback
                  onChanged(value, index);
                },
                decoration: InputDecoration(
                  filled: true,
                  // labelText: labelText,
                  fillColor: TColors.secondary,
                  hintText: labelText,
                  contentPadding: EdgeInsets.all(12),
                ),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
              ),
            ),
            Visibility(
              visible: isList,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => onClose(index),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Future<void> fetchGarageData() async {
    await controller.fetchVehicleData();
    // setState(() {
    for (VehicleModel vehicle in controller.vehiclesData) {
      if (vehicle.vehicleId == widget.vehicleId) {
        vehicleId = vehicle.vehicleId;
        model = vehicle.model;
        garageId = vehicle.garageId;
        mileage = vehicle.mileage;
        seatingCapacity = vehicle.seatingCapacity!;
        rentalRate = vehicle.rentalRates.toInt();
        isVehicleActive = vehicle.isVehicleActive;
        rating = vehicle.rating;
        noOfRating = vehicle.noOfRating;
        rentalRateType = vehicle.rentalRateType;
        extraFeatures = vehicle.extraFeatures;
        rules = vehicle.rules;
        _initializeRulesInputFields();
        _initializeFeaturesInputFields();
        vehicleImage = vehicle.vehicleImage;
        selectedFuel = vehicle.fuelType;
        _showCurrentAddress = await _fetchAddressName(vehicle.pickupLocation);
        _currentAddress = vehicle.pickupLocation;
        selectedTranmission = vehicle.transmission;
        vehicleType = vehicle.vehicleType;
      }
    }
    setState(() {}); //important setstate that set the values from the firebase
    // });
  }

  void _initializeRulesInputFields() {
    for (int i = 0; i < rules.length; i++) {
      inputFields2.add(TextFieldVehicle(
          rules[i], i, TextInputType.text, 'Rules and requirements',
          (value, index) {
        setState(() {
          try {
            rules[index] = value;
          } catch (e) {
            Get.snackbar('Error', '$e');
          }
        });
      }, (index) {
        try {
          setState(() {
            rules.removeAt(index); // Remove feature from list
            inputFields2
                .removeAt(index); // Remove corresponding TextFieldVehicle
          });
        } catch (e) {
          Get.snackbar('title', e.toString());
        }
      }, true));
    }
  }

  void _initializeFeaturesInputFields() {
    for (int i = 0; i < extraFeatures.length; i++) {
      inputFields1.add(TextFieldVehicle(
          extraFeatures[i], i, TextInputType.text, 'Extra Features',
          (value, index) {
        setState(() {
          try {
            rules[index] = value;
          } catch (e) {
            Get.snackbar('Error', '$e');
          }
        });
      }, (index) {
        try {
          setState(() {
            extraFeatures.removeAt(index); // Remove feature from list
            inputFields1
                .removeAt(index); // Remove corresponding TextFieldVehicle
          });
        } catch (e) {
          Get.snackbar('title', e.toString());
        }
      }, true));
    }
  }

  Future<String> _fetchAddressName(String location) async {
    try {
      List<String> coordinates = location.split(',');
      double longitude = double.parse(coordinates[0]);
      double latitude = double.parse(coordinates[1]);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          vehicleCity =
              '${placemark.name ?? ''}, ${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.subAdministrativeArea ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''}' ??
                  '';
        });
      }
    } catch (e) {
      vehicleCity = 'Error fetching address';
    }
    return vehicleCity;
  }

  @override
  Widget build(BuildContext context) {
    List<String> allImages = [
      ...vehicleImage,
      ...selectedImages.map((e) => e.path)
    ];
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
                      'Add your car details',
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
                        children: [
                          if (allImages.isEmpty) ...[
                            Image.asset(TImages.addPhotoIcon, height: 60),
                            SizedBox(height: 15),
                          ] else ...[
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: allImages.length,
                                itemBuilder: (context, index) {
                                  String imageSource = allImages[index];
                                  Widget imageWidget;

                                  if (imageSource.startsWith('http')) {
                                    // If it's a URL, display the image using Image.network
                                    imageWidget = Image.network(
                                      imageSource,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Icon(
                                            Icons.error); // Handle error
                                      },
                                    );
                                  } else if (imageSource.startsWith('/data')) {
                                    imageWidget = Image.file(
                                      File(imageSource),
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Icon(
                                            Icons.error); // Handle error
                                      },
                                    );
                                  } else {
                                    imageWidget =
                                        SizedBox(); // Empty placeholder
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child:
                                                imageWidget, // Use the appropriate image widget
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
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                              ),
                                              child: IconButton(
                                                icon: Icon(Icons.delete_forever,
                                                    color: TColors.white),
                                                onPressed: () {
                                                  setState(() {
                                                    if (index <
                                                        vehicleImage.length) {
                                                      vehicleImage
                                                          .removeAt(index);
                                                    } else {
                                                      selectedImages.removeAt(
                                                          index -
                                                              vehicleImage
                                                                  .length);
                                                    }
                                                    isImageSelected =
                                                        (vehicleImage.length +
                                                                selectedImages
                                                                    .length) >
                                                            0;
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
                                                              vehicleImage
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
                    Text(
                      'Edit Car Features',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: TColors.greyDark),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        TextFieldVehicle(
                          model,
                          0,
                          TextInputType.text,
                          'Model',
                          (value, index) {
                            setState(() {
                              model = value;
                            });
                          },
                          (index) {
                            setState(() {});
                          },
                          false,
                        ),
                        Visibility(
                          visible: vehicleType != 'bicycle',
                          child: TextFieldVehicle(
                            seatingCapacity.toString(),
                            0,
                            TextInputType.number,
                            'Seating Capacity',
                            (value, index) {
                              setState(() {
                                seatingCapacity = int.tryParse(value) ?? 0;
                              });
                            },
                            (index) {
                              setState(() {});
                            },
                            false,
                          ),
                        ),
                        Visibility(
                          visible: vehicleType != 'bicycle',
                          child: TextFieldVehicle(
                            mileage,
                            0,
                            TextInputType.text,
                            'Mileage',
                            (value, index) {
                              setState(() {
                                mileage = value;
                              });
                            },
                            (index) {
                              setState(() {});
                            },
                            false,
                          ),
                        ),
                        Visibility(
                          visible: vehicleType != 'bicycle' &&
                              vehicleType != 'motor bike',
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
                      visible:
                          vehicleType != 'bicycle' && vehicleType != 'rickshaw',
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
                              extraFeatures
                                  .add(''); // Add an empty feature in the list
                              inputFields1.add(TextFieldVehicle(
                                '', // Initialize with empty value
                                extraFeatures.length -
                                    1, // Use extraFeatures length as index
                                TextInputType.text,
                                'Features',
                                (value, index) {
                                  setState(() {
                                    try {
                                      extraFeatures[index] = value;
                                    } catch (e) {
                                      Get.snackbar('Error', '$e');
                                    }
                                  });
                                  print("Extra features: $extraFeatures");
                                },
                                (index) {
                                  try {
                                    setState(() {
                                      extraFeatures.removeAt(
                                          index); // Remove feature from list
                                      inputFields1.removeAt(
                                          index); // Remove corresponding TextFieldVehicle
                                    });
                                  } catch (e) {
                                    Get.snackbar('title', e.toString());
                                  }
                                },
                                true,
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
                Text(
                  'Set Rental Rates',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                if (rentalRateType == 'Per day')
                  Container(
                    // width: double.minPositive,
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.primary, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        'Per day price',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    Slider(
                                      divisions: 40,
                                      value: rentalRate
                                          .toDouble()
                                          .clamp(500, 2500),
                                      min: 500,
                                      max: 2500,
                                      activeColor: TColors.primary,
                                      inactiveColor: TColors.blueLight,
                                      onChanged: (double newValue) {
                                        setState(() {
                                          rentalRate = newValue.toInt();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                        width: 1.0, color: TColors.primary),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Text(
                                        rentalRate.toString(),
                                        style: TextStyle(fontSize: 20),
                                        // style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 25),
                                      child: Text(
                                        'pkr',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (rentalRateType == 'Per hour')
                  SetPriceRangeWidget(
                    division: 7,
                    priceTitle: "Per hour price",
                    minimumPrice: 50,
                    maximumPrice: 400,
                    initialHigherPrice: rentalRate.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        rentalRate = value.toInt();
                      });
                    },
                  ),
                const SizedBox(height: 10),
                Text(
                  'Set Pick Up Location',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: TColors.greyDark),
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
                Text(
                  'Add Rules and Requirements',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: TColors.greyDark),
                ),
                const SizedBox(height: 10),
                Column(children: [
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
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          IconButton(
                            icon: Icon(Icons.add_rounded),
                            color: TColors.primary,
                            onPressed: () {
                              setState(() {
                                rules.add('');
                                inputFields2.add(TextFieldVehicle(
                                  '',
                                  inputFields2.length,
                                  TextInputType.text,
                                  'Rules and requirments',
                                  (value, index) {
                                    setState(() {
                                      try {
                                        rules[index] = value;
                                      } catch (e) {
                                        Get.snackbar('Error', '$e');
                                      }
                                    });
                                    print("Added Rules are as follows: $rules");
                                  },
                                  (index) {
                                    try {
                                      setState(() {
                                        rules.removeAt(
                                            index); // Remove feature from list
                                        inputFields2.removeAt(
                                            index); // Remove corresponding TextFieldVehicle
                                      });
                                    } catch (e) {
                                      Get.snackbar('title', e.toString());
                                    }
                                  },
                                  true,
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
                                  List<String> newImageUrls;
                                  List<String> updatedVehicleImages;

                                  if (selectedImages.isNotEmpty) {
                                    newImageUrls = await controller
                                        .uploadVehicleImage(selectedImages);
                                    updatedVehicleImages =
                                        vehicleImage + newImageUrls;
                                  } else {
                                    updatedVehicleImages = vehicleImage;
                                  }
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
                                  if (updatedVehicleImages == [] ||
                                      updatedVehicleImages.isEmpty) {
                                    errorField.add('Select at least 1 image.');
                                  }
                                  if (errorField.isEmpty || errorField == []) {
                                    vehicleImage = await controller
                                        .uploadVehicleImage(selectedImages);
                                    setState(() {
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

                                      updateVehicleData(
                                        vehicleId,
                                        garageId,
                                        model,
                                        mileage,
                                        _currentAddress,
                                        selectedFuel,
                                        selectedTranmission,
                                        vehicleType,
                                        seatingCapacity,
                                        rentalRate.toDouble(),
                                        rentalRateType,
                                        isVehicleActive,
                                        rating,
                                        noOfRating,
                                        updatedVehicleImages,
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
                              child: Text("Save Changes"),
                            );
                    },
                  ),
                ),
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
