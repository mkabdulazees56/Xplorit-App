import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel {
  String vehicleId;
  String garageId;
  String model;
  String mileage;
  String pickupLocation;
  String vehicleType;
  double rentalRates;
  String fuelType;
  String transmission;
  int? seatingCapacity;
  String rentalRateType;
  bool isVehicleActive;
  double rating;
  int noOfRating;
  List<String> vehicleImage;
  List<String> rules;
  List<String> extraFeatures;

  VehicleModel(
      {required this.vehicleId,
      required this.garageId,
      required this.model,
      required this.mileage,
      required this.pickupLocation,
      required this.rentalRates,
      required this.fuelType,
      required this.transmission,
      required this.seatingCapacity,
      required this.rentalRateType,
      required this.isVehicleActive,
      required this.rating,
      required this.noOfRating,
      required this.extraFeatures,
      required this.rules,
      required this.vehicleType,
      required this.vehicleImage});

  toJson() {
    return {
      'vehicleId': vehicleId,
      'model': model,
      'mileage': mileage,
      'garageId': garageId,
      'pickupLocation': pickupLocation,
      'rentalRates': rentalRates,
      'fuelType': fuelType,
      'transmission': transmission,
      'seatingCapacity': seatingCapacity,
      'rating': rating,
      'noOfRating': noOfRating,
      'extraFeatures': extraFeatures,
      'vehicleImage': vehicleImage,
      'rentalRateType': rentalRateType,
      'isVehicleActive': isVehicleActive,
      'rules': rules,
      'vehicleType': vehicleType
    };
  }

  static VehicleModel empty() => VehicleModel(
      vehicleId: '',
      garageId: '',
      model: '',
      mileage: '',
      pickupLocation: '',
      rentalRates: 0.0,
      fuelType: '',
      transmission: '',
      seatingCapacity: 0,
      rentalRateType: '',
      isVehicleActive: true,
      rating: 0.0,
      noOfRating: 0,
      vehicleType: '',
      rules: [],
      extraFeatures: [],
      vehicleImage: []);

  factory VehicleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return VehicleModel.empty();
    final data = document.data();
    return VehicleModel(
      vehicleId: data?['vehicleId'] ?? '',
      garageId: data?['garageId'] ?? '',
      model: data?['model'] ?? '',
      mileage: data?['mileage'] ?? '',
      pickupLocation: data?['pickupLocation'] ?? '',
      rentalRates: data?['rentalRates'] ?? 0.0,
      fuelType: data?['fuelType'] ?? '',
      transmission: data?['transmission'] ?? '',
      seatingCapacity: data?['seatingCapacity'] ?? 0,
      rentalRateType: data?['rentalRateType'] ?? '',
      isVehicleActive: data?['isVehicleActive'] ?? true,
      rating: data?['rating'] ?? 0.0,
      noOfRating: data?['noOfRating'] ?? 0,
      vehicleType: data?['vehicleType'] ?? '',
      vehicleImage: data?['vehicleImage'] != null
          ? List<String>.from(data?['vehicleImage'])
          : [],
      rules: data?['rules'] != null ? List<String>.from(data?['rules']) : [],
      extraFeatures: data?['extraFeatures'] != null
          ? List<String>.from(data?['extraFeatures'])
          : [],

      // vehicleImage: (data['vehicleImage'] != null
      //     ? List<String>.from(data['images'])
      //     : []),
    );
  }
}
