// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/features/product/filtered_product_list.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class VehicleFilter extends StatefulWidget {
  const VehicleFilter({super.key});
  @override
  State<VehicleFilter> createState() => _VehicleFilter();
}

class _VehicleFilter extends State<VehicleFilter> {
  List<Map> vehicles = [
    {"name": "Car", "isChecked": true},
    {"name": "Motor Bike", "isChecked": false},
    {"name": "Bicycle", "isChecked": false},
    {"name": "Rickshaw", "isChecked": false},
  ];

  bool byCity = false;
  bool isSwitched = false;
  List<String> vehicleTypes = ['Car'];
  int lowerPrice = 500;
  int higherPrice = 3000;
  int higherDistance = 5;
  int distance = 0;

  String selectedCity = 'Selected City';

  List<String> cities = [
    'Selected City',
    'Karachi',
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Gujranwala',
    'Hyderabad',
    'Abbottabad',
    'Sargodha',
    'Sukkur',
    'Bahawalpur',
  ];

  List<String> convertToLowerCase(List<String> strings) {
    return strings.map((string) => string.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            //main Column
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Positioned(
                      top: -10,
                      left: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Filters",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  color: TColors.darkGrey,
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What is your preferred type of Vehicle?',
                      style: Theme.of(context).textTheme.headlineSmall?.apply(
                            color: TColors.primary,
                          ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                          color: TColors.secondary,
                          border: Border.all(
                            color: TColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: vehicles.map((vehicle) {
                          return CheckboxListTile(
                            title: Text(vehicle['name']),
                            value: vehicle['isChecked'],
                            onChanged: (val) {
                              setState(() {
                                vehicle['isChecked'] = val;
                                if (val == true) {
                                  vehicleTypes.add(vehicle['name']);
                                } else {
                                  vehicleTypes.remove(vehicle['name']);
                                }
                              });
                            },
                            activeColor: TColors.primary,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Price Range Per Day:',
                      style: Theme.of(context).textTheme.headlineSmall?.apply(
                            color: TColors.primary,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rs $lowerPrice',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  'Rs $higherPrice',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          slider(
                            RangeSlider(
                              values: RangeValues(lowerPrice.toDouble(),
                                  higherPrice.toDouble()),
                              min: 500,
                              max: 3000,
                              divisions: 25,
                              activeColor: TColors.primary,
                              inactiveColor: TColors.blueLight,
                              onChanged: (RangeValues newValues) {
                                setState(() {
                                  lowerPrice = newValues.start.round();
                                  higherPrice = newValues.end.round();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Distance From Your Location:',
                      style: Theme.of(context).textTheme.headlineSmall?.apply(
                            color: TColors.primary,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.primary, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Visibility(
                            visible: !byCity,
                            child: SizedBox(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '$higherDistance km',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  slider(
                                    Slider(
                                      value: higherDistance.toDouble(),
                                      min: 1.0,
                                      max: 5.0,
                                      activeColor: TColors.primary,
                                      inactiveColor: TColors.blueLight,
                                      onChanged: (double newValue) {
                                        setState(() {
                                          higherDistance = newValue.round();
                                          print(higherDistance);
                                        });
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        'Vehicle within a 15-km range \n will be Shown when run out of matches.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      // Switch(
                                      //   value: isSwitched,
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       isSwitched = value;
                                      //       if (isSwitched == true) {
                                      //         distance = 15;
                                      //         print(distance);
                                      //       } else {
                                      //         distance = higherDistance;
                                      //       }
                                      //     });
                                      //   },
                                      //   activeColor: TColors.primary,
                                      //   inactiveThumbColor: TColors.darkGrey,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: !byCity,
                            child: Divider(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Filter by City',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                Switch(
                                  value: byCity,
                                  onChanged: (value) {
                                    setState(() {
                                      byCity = value;
                                    });
                                  },
                                  activeColor: TColors.primary,
                                  inactiveThumbColor: TColors.darkGrey,
                                ),
                              ],
                            ),
                          ),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: TColors.secondary,
                          //     foregroundColor: TColors.primary,
                          //   ),
                          //   onPressed: () {
                          //     setState(() {
                          //       byCity = true;
                          //     });
                          //   },
                          //   child: Text('Filter By City'),
                          // ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Visibility(
                      visible: byCity,
                      child: Text(
                        'Select by City:',
                        style: Theme.of(context).textTheme.headlineSmall?.apply(
                              color: TColors.primary,
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Visibility(
                    //   visible: byCity,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.blue, width: 1),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: DropdownButton<String>(
                    //       value: selectedCity,
                    //       dropdownColor: Colors.white,
                    //       icon: const Icon(Icons.expand_more),
                    //       isExpanded: true,
                    //       underline: Container(
                    //         color: Colors.blue,
                    //       ),
                    //       onChanged: byCity
                    //           ? (String? newValue) {
                    //               setState(() {
                    //                 selectedCity = newValue!;
                    //                 print(selectedCity);
                    //               });
                    //             }
                    //           : null,
                    //       items: cities.map((city) {
                    //         return DropdownMenuItem(
                    //           value: city,
                    //           child: Text(city),
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),

                    // ),
                    Builder(
                      builder: (context) {
                        try {
                          if (byCity) {
                            return Column(
                              children: [
                                CityDropdown(
                                  selectedCity: selectedCity,
                                  byCity: byCity,
                                  cities: cities,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCity = newValue!;
                                      print(selectedCity);
                                    });
                                  },
                                )
                              ],
                            );
                          }
                        } catch (e) {
                          Get.snackbar('Dropdown exception: $e', '');
                          return DropdownButton<String>(
                            value: 'Selected City',
                            onChanged: null,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Selected City',
                                  child: Text('Selected City'))
                            ],
                          );
                        }
                        return Column(
                          children: [],
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.secondary,
                          foregroundColor: TColors.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            vehicleTypes = [];
                            vehicles = vehicles.map((vehicle) {
                              return {
                                'name': vehicle['name'],
                                'isChecked': vehicle['name'] == 'Car',
                              };
                            }).toList();
                            byCity = false;
                            vehicleTypes.add('car');
                            lowerPrice = 500;
                            higherPrice = 3000;
                            higherDistance = 5;
                            // isSwitched = false;
                            distance = 0;
                            selectedCity = 'Selected City';
                          });
                        },
                        child: Text('Clear all'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // if (!byCity) {
                            //   selectedCity = 'Selected City';
                            // }
                            if (selectedCity == 'Selected City') {
                              byCity = false;
                            }

                            try {
                              List<String> convertedVehicleList =
                                  convertToLowerCase(vehicleTypes);
                              Get.to(
                                () => FilteredProductListing(
                                    byCity: byCity,
                                    vehicleTypeList: convertedVehicleList,
                                    priceRangeHigh: higherPrice,
                                    priceRangeLow: lowerPrice,
                                    distance: higherDistance.toDouble(),
                                    city: selectedCity),
                              );
                            } catch (e) {
                              Get.snackbar('Oops!', e.toString());
                            }
                          });

                          // Handle onPressed for ElevatedButton
                        },
                        child: Text(
                          'Apply filters',
                        ),
                      ),
                    ),
                  ],
                ),
                DividerWidget(),
              ],
            ), //main Column
          ),
        ),
      ),
    );
  }

  SliderTheme slider(StatefulWidget sliderType) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbColor: TColors.primary,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
      ),
      child: sliderType,
    );
  }
}

class CityDropdown extends StatefulWidget {
  String selectedCity;
  final bool byCity;
  final List<String> cities;
  final Function(String)? onChanged;

  CityDropdown({
    required this.selectedCity,
    required this.byCity,
    required this.cities,
    this.onChanged,
  });

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: widget.selectedCity,
        dropdownColor: Colors.white,
        icon: const Icon(Icons.expand_more),
        isExpanded: true,
        underline: Container(color: TColors.primary),
        onChanged: widget.onChanged as void Function(String?)?,

        // onChanged: widget.byCity
        //     ? (String? newValue) {
        //         setState(() {
        //           widget.selectedCity = newValue!;
        //           // print(selectedCity);
        //         });
        //       }
        //     : null,
        items: widget.cities.map((city) {
          return DropdownMenuItem(
            value: city,
            child: Text(city),
          );
        }).toList(),
      ),
    );
  }
}
