import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xplorit/Controllers/booking_controller.dart';
import 'package:xplorit/Controllers/renter_controller.dart';
import 'package:xplorit/Controllers/renter_vehicle_controller.dart';
import 'package:xplorit/Controllers/vehicle_controller.dart';
import 'package:xplorit/Models/booking_model.dart';
import 'package:xplorit/Models/rented_vehicle_model.dart';
import 'package:xplorit/Models/renter_model.dart';
import 'package:xplorit/Models/vehicle_model.dart';
import 'package:xplorit/common_widgets/back_botton_widget.dart';
import 'package:xplorit/common_widgets/date_widget.dart';
import 'package:xplorit/common_widgets/divider_widget.dart';
import 'package:xplorit/common_widgets/elevated_btn_widget.dart';
import 'package:xplorit/common_widgets/order_summery_widget.dart';
import 'package:xplorit/common_widgets/vehicle_name_tag.dart';
import 'package:xplorit/features/dashbord/dashboard.dart';
import 'package:xplorit/utils/constants/colors.dart';
import 'package:xplorit/utils/constants/image_strings.dart';
import 'package:xplorit/utils/constants/sizes.dart';

class RequestForRent extends StatefulWidget {
  RequestForRent({
    required this.vehicleId,
    Key? key,
  }) : super(key: key);

  final String vehicleId;

  @override
  State<RequestForRent> createState() => _RequestForRent();
}

class _RequestForRent extends State<RequestForRent> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedDays = 0;
  final renterController = Get.put(RenterController());
  final rentedVehicleController = Get.put(RentedVehicleController());

  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  DateTime _notNullDate(DateTime? date) {
    if (date == null) {
      return DateTime(2000, 1, 1, 0, 0);
    } else {
      return date;
      // return date.toString().split(' ')[0];
    }
  }

  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchRenterId();
  }

  Future<void> _initializeData() async {
    await fetchRenterId();
  }

  Future<void> fetchRenterId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userPhoneNumber = user.phoneNumber ?? '';

      try {
        if (mounted) {
          setState(() {
            var matchingRenter = renterController.rentersData.firstWhere(
              (renter) => renter.contactNumber == userPhoneNumber,
            );

            renterId =
                matchingRenter != null && matchingRenter.renterId.isNotEmpty
                    ? matchingRenter.renterId
                    : '';
            for (RenterModel renter in renterController.rentersData) {
              if (renter.renterId == renterId && renter.isRentedAVehicle) {
                isRentedAVehicle = true;
              }
            }
          });
        }
      } catch (e) {
        var matchingRenter = renterController.rentersData.firstWhere(
          (renter) => renter.contactNumber == userPhoneNumber,
        );

        renterId = matchingRenter != null && matchingRenter.renterId.isNotEmpty
            ? matchingRenter.renterId
            : '';
        for (RentedVehicleModel renteredVehicle
            in rentedVehicleController.rentedvehiclesData) {
          if (renteredVehicle.renterId == renterId) {
            isRentedAVehicle = true;
          }
        }
      }
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusDay;
      });
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _rangeStart = start;
      _rangeEnd = end;
      if (start != null && end != null) {
        _selectedDays = end.difference(start).inDays;
      } else {
        _selectedDays = 0;
      }
    });
  }

  final vehicleController = Get.put(VehicleController());
  final bookingController = Get.put(BookingController());

  String defaultVehicleImage = '';
  double refundableDeposit = 0.0;
  double rentalRate = 0.0;
  bool isSummeryVisible = false;

  String bookingId = '';
  String vehicleId = '';
  String renterId = '';
  String garageId = '';
  DateTime? endDate;
  DateTime? startDate;
  String paymentStatus = '';
  bool isRentedAVehicle = false;
  String rentalRateType = '';
  String startTimeString = '';
  String endTimeString = '';
  final isLoading = false.obs;

  DateTime? _selectedDate;

  void _selectedDateOnPerHour(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void addBookingData(
    String bookingId,
    String vehicleId,
    String garageId,
    String renterId,
    DateTime endDate,
    DateTime startDate,
    String paymentStatus,
    int duration,
  ) {
    final booking = BookingModel(
      bookingId: bookingId,
      vehicleId: vehicleId,
      renterId: renterId,
      garageId: garageId,
      paymentStatus: paymentStatus,
      endDate: Timestamp.fromDate(endDate),
      startDate: Timestamp.fromDate(startDate),
      duration: duration,
    );

    bookingController.addBookingData(booking);
  }

  void _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }

        if (_selectedDate != null && _startTime != null && _endTime != null) {
          DateTime startDateTime = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _startTime!.hour,
            _startTime!.minute,
          );
          DateTime endDateTime = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _endTime!.hour,
            _endTime!.minute,
          );

          if (startDateTime.isAfter(endDateTime)) {
            DateTime temp = startDateTime;
            startDateTime = endDateTime;
            endDateTime = temp;
          }

          Duration duration = endDateTime.difference(startDateTime);
          _selectedDays = duration.inHours;
        }
      });
    }
  }

  // void _selectTime(BuildContext context, bool isStartTime) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: isStartTime
  //         ? (_startTime ?? TimeOfDay.now())
  //         : (_endTime ?? TimeOfDay.now()),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (isStartTime) {
  //         _startTime = picked;
  //       } else {
  //         _endTime = picked;
  //       }

  //       // Calculate the duration in hours
  //       if (_startTime != null && _endTime != null && _selectedDate != null) {
  //         DateTime startDateTime = DateTime(
  //           _selectedDate!.year,
  //           _selectedDate!.month,
  //           _selectedDate!.day,
  //           _startTime!.hour,
  //           _startTime!.minute,
  //         );
  //         DateTime endDateTime = DateTime(
  //           _selectedDate!.year,
  //           _selectedDate!.month,
  //           _selectedDate!.day,
  //           _endTime!.hour,
  //           _endTime!.minute,
  //         );

  //         if (startDateTime.isAfter(endDateTime)) {
  //           DateTime temp = startDateTime;
  //           startDateTime = endDateTime;
  //           endDateTime = temp;
  //         }

  //         Duration duration = endDateTime.difference(startDateTime);
  //         _selectedDays = duration.inHours;
  //         _printSelectedDays = '${duration.inHours} hour(s)';
  //       }
  //     });
  //   }
  // }
  // void _selectTime(BuildContext context, bool isStart) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (isStart) {
  //         _startTime = picked;
  //       } else {
  //         _endTime = picked;
  //       }
  // _calculateDuration(); // Call to calculate duration
  //     });
  //   }
  // }

  // void _calculateDuration() {
  //   if (_startTime != null && _endTime != null) {
  //     if (_startTime!.hour > _endTime!.hour ||
  //         (_startTime!.hour == _endTime!.hour &&
  //             _startTime!.minute > _endTime!.minute)) {
  //       // Swap start and end times
  //       final temp = _startTime;
  //       _startTime = _endTime;
  //       _endTime = temp;
  //     }
  //     // Calculate duration
  //     final start = DateTime(_selectedDay!.year, _selectedDay!.month,
  //         _selectedDay!.day, _startTime!.hour, _startTime!.minute);
  //     final end = DateTime(_selectedDay!.year, _selectedDay!.month,
  //         _selectedDay!.day, _endTime!.hour, _endTime!.minute);
  //     final duration = end.difference(start);
  //     setState(() {
  //       _selectedDays = duration.inHours;
  //       if (duration.inHours < 1) {
  //         Get.snackbar('Snap!', 'Select atleast 1 hour',
  //             duration: const Duration(seconds: 3));
  //       }
  //       _printSelectedDays = '${duration.inHours} hour(s)';
  //     });
  //   }
  // }

  Future<List<Widget>> _buildVehicleWidgets() async {
    List<Widget> vehicleWidgets = [];

    for (VehicleModel vehicle in vehicleController.vehiclesData) {
      if (widget.vehicleId == vehicle.vehicleId) {
        try {
          if (vehicle.vehicleImage.isNotEmpty &&
              vehicle.vehicleImage[0].isNotEmpty) {
            defaultVehicleImage = vehicle.vehicleImage[0];
          } else {
            defaultVehicleImage = TImages.car;
            // firstVehicleImage = TImages.rover;
          }
        } catch (e) {
          defaultVehicleImage = TImages.car;
        }
        garageId = vehicle.garageId;
        rentalRateType = vehicle.rentalRateType;
        vehicleWidgets.add(
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: TColors.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VehicleNameTag(
                    model: vehicle.model,
                    imageUrl: defaultVehicleImage,
                    rating: vehicle.rating,
                    noOfRating: vehicle.noOfRating,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return vehicleWidgets;
  }

  Widget fetchVehicleDeatils() {
    return FutureBuilder<List<Widget>>(
      future: _buildVehicleWidgets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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

  @override
  Widget build(BuildContext context) {
    // void showAlert(BuildContext context) {
    //   QuickAlert.show(
    //     context: context,
    //     title: 'Success',
    //     text:
    //         'Request sent successfully.\nOnce the owner confirm, we will notify you',
    //     type: QuickAlertType.success,
    //     confirmBtnColor: TColors.primary,
    //     confirmBtnText: 'Back to Home',
    //     onConfirmBtnTap: () {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => Dashboard(),
    //         ),
    //       );
    //       // Get.to(() => const Dashboard());
    //       // Navigator.popAndPushNamed((context), '/home');
    //     },
    //     barrierDismissible: false, // Prevents closing when tapping outside
    //   );
    // }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BackButtonWidget(),
                      const SizedBox(height: 20),
                      Text('Request for Rent',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.apply(color: TColors.greyDark)),
                      const SizedBox(height: 20),
                      fetchVehicleDeatils(),
                      const SizedBox(height: 15),
                      if (rentalRateType == 'Per day') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DateWidget(
                              dateText: 'Start Trip',
                              dateFunc: _notNullDate(_rangeStart)
                                  .toString()
                                  .split(' ')[0],
                              iconBook: Icons.event,
                            ),
                            DateWidget(
                                dateText: 'End Trip',
                                dateFunc: _notNullDate(_rangeEnd)
                                    .toString()
                                    .split(' ')[0],
                                iconBook: Icons.schedule_outlined),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: TColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TableCalendar(
                            rowHeight: 45,
                            daysOfWeekHeight: 25,
                            focusedDay: _focusedDay,
                            firstDay: DateTime.now(),
                            lastDay: DateTime.utc(2030, 12, 12),
                            // firstDay: _rangeStart ?? DateTime.now(),
                            // lastDay: _rangeStart != null
                            //     ? _rangeStart!.add(Duration(days: 6))
                            //     : DateTime.utc(2030, 12, 12),
                            calendarFormat: _calendarFormat,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            headerStyle: const HeaderStyle(
                                titleTextStyle: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: TColors.dark),
                                formatButtonVisible: false,
                                titleCentered: true,
                                headerPadding: EdgeInsets.all(5)),
                            availableGestures: AvailableGestures.all,
                            onRangeSelected: _onRangeSelected,
                            rangeSelectionMode: RangeSelectionMode.toggledOn,
                            onDaySelected: _onDaySelected,
                            calendarStyle: const CalendarStyle(
                              rangeHighlightColor: TColors.blueLight,
                              rangeStartDecoration: BoxDecoration(
                                  color: TColors.primary,
                                  shape: BoxShape.circle),
                              rangeEndDecoration: BoxDecoration(
                                color: TColors.primary,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                  color: TColors.primary,
                                  shape: BoxShape.circle),
                            ),
                            rangeStartDay: _rangeStart,
                            rangeEndDay: _rangeEnd,
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                          ),
                        ),
                      ] else if (rentalRateType == 'Per hour') ...[
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectedDateOnPerHour(context),
                              child: Text(_selectedDate == null
                                  ? 'Select Date'
                                  : '${_selectedDate!.toLocal()}'
                                      .split(' ')[0]),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Start Time:'),
                                    SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _selectTime(context, true),
                                      child: Text(_startTime == null
                                          ? 'Select Start Time'
                                          : '${_startTime!.format(context)}'),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('End Time:'),
                                    SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _selectTime(context, false),
                                      child: Text(_endTime == null
                                          ? 'Select End Time'
                                          : '${_endTime!.format(context)}'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              _selectedDate != null &&
                                      _startTime != null &&
                                      _endTime != null
                                  ? 'Selected Duration: $_selectedDays hours'
                                  : 'Please select date and times',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        )
                      ],
                      const SizedBox(height: 5),
                      Text(
                        _rangeStart != null && _rangeEnd != null
                            ? 'Selected Duration: $_selectedDays Days'
                            : '',
                        style: TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 15),
                      StreamBuilder<Object>(
                          stream: null,
                          builder: (context, snapshot) {
                            for (VehicleModel vehicle
                                in vehicleController.vehiclesData) {
                              if (vehicle.vehicleId == widget.vehicleId) {
                                rentalRate = vehicle.rentalRates.toDouble();
                              }
                            }
                            return OrderSummery(
                              rentalRate: rentalRate,
                              noOfDays: _selectedDays,
                              rentalRateType: rentalRateType,
                            );
                          }),
                      const SizedBox(height: 15),
                      Obx(
                        () {
                          return isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: TColors.primary,
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              : ElevatedBTN(
                                  titleBtn: 'Send Request to Vehicle Owner',
                                  onTapCall: () {
                                    if (rentalRateType == 'Per hour') {
                                      if (_selectedDate != null &&
                                          _startTime != null &&
                                          _endTime != null) {
                                        DateTime startDateTime = DateTime(
                                          _selectedDate!.year,
                                          _selectedDate!.month,
                                          _selectedDate!.day,
                                          _startTime!.hour,
                                          _startTime!.minute,
                                        );
                                        DateTime endDateTime = DateTime(
                                          _selectedDate!.year,
                                          _selectedDate!.month,
                                          _selectedDate!.day,
                                          _endTime!.hour,
                                          _endTime!.minute,
                                        );

                                        if (startDateTime
                                            .isAfter(endDateTime)) {
                                          DateTime temp = startDateTime;
                                          startDateTime = endDateTime;
                                          endDateTime = temp;
                                        }
                                        bookingId = 'b1';
                                        vehicleId = widget.vehicleId;
                                        renterId = renterId;
                                        endDate = endDateTime;
                                        startDate = startDateTime;
                                        // startDateTime.toString().split(' ')[0];
                                        paymentStatus = 'paid';
                                        try {
                                          isLoading.value = true;
                                          addBookingData(
                                            bookingId,
                                            vehicleId,
                                            garageId,
                                            renterId,
                                            endDate!,
                                            startDate!,
                                            paymentStatus,
                                            _selectedDays,
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Dashboard(),
                                            ),
                                          );
                                        } finally {
                                          isLoading.value = false;
                                        }
                                      } else {
                                        Get.snackbar('Oh Snap!',
                                            'Select Appropriate Time!');
                                      }
                                    } else if (rentalRateType == 'Per day') {
                                      if (_notNullDate(_rangeEnd) !=
                                              DateTime(2000, 1, 1, 0, 0) &&
                                          _notNullDate(_rangeStart) !=
                                              DateTime(2000, 1, 1, 0, 0)) {
                                        DateTime startDateTime = DateTime(
                                          _notNullDate(_rangeStart).year,
                                          _notNullDate(_rangeStart).month,
                                          _notNullDate(_rangeStart).day,
                                          DateTime.now().hour,
                                          DateTime.now().minute,
                                        );
                                        DateTime endDateTime = DateTime(
                                          _notNullDate(_rangeEnd).year,
                                          _notNullDate(_rangeEnd).month,
                                          _notNullDate(_rangeEnd).day,
                                          DateTime.now().hour,
                                          DateTime.now().minute,
                                        );
                                        bookingId = 'b1';
                                        vehicleId = widget.vehicleId;
                                        renterId = renterId;
                                        endDate = _notNullDate(_rangeEnd);
                                        startDate = _notNullDate(_rangeStart);
                                        paymentStatus = 'paid';

                                        try {
                                          isLoading.value = true;
                                          addBookingData(
                                            bookingId,
                                            vehicleId,
                                            garageId,
                                            renterId,
                                            endDateTime,
                                            startDateTime,
                                            paymentStatus,
                                            _selectedDays,
                                          );

                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Dashboard()),
                                            (Route<dynamic> route) => false,
                                          ); // Get.snackbar(
                                          //     '$_selectedDays',
                                          //     'No of Days');
                                        } finally {
                                          isLoading.value = false;
                                        }
                                      } else {
                                        Get.snackbar('Oh Snap!',
                                            'Select the appropriate Date!');
                                      }
                                    }
                                  },
                                );
                        },
                      ),
                      const DividerWidget(),
                    ],
                  );
                }),
          ), //main Column
        ),
      ),
    );
  }
}
