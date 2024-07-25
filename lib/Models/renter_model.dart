import 'package:cloud_firestore/cloud_firestore.dart';

class RenterModel {
  String renterId;
  String userName;
  String? contactNumber;
  String profilePicture;
  double latitude;
  double longitude;
  Timestamp timestamp;
  bool isRentedAVehicle;
  int noOfRating;
  double rating;

  RenterModel({
    required this.isRentedAVehicle,
    required this.renterId,
    required this.userName,
    required this.contactNumber,
    required this.profilePicture,
    required this.longitude,
    required this.latitude,
    required this.timestamp,
    required this.noOfRating,
    required this.rating,
  });

  toJson() {
    return {
      'renterId': renterId,
      'userName': userName,
      'contactNumber': contactNumber,
      'profilePicture': profilePicture,
      'latitude': latitude,
      'longitude': longitude,
      'isRentedAVehicle': isRentedAVehicle,
      'timestamp': FieldValue.serverTimestamp(),
      'noOfRating': noOfRating,
      'rating': rating
    };
  }

  static RenterModel empty() => RenterModel(
        renterId: '',
        userName: '',
        contactNumber: '',
        profilePicture: '',
        latitude: 0.0,
        longitude: 0.0,
        timestamp: Timestamp.now(),
        isRentedAVehicle: false,
        noOfRating: 0,
        rating: 0.0,
      );

  factory RenterModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return RenterModel.empty();
    final data = document.data();
    return RenterModel(
      renterId: data?['renterId'] ?? '',
      userName: data?['userName'] ?? '',
      contactNumber: data?['contactNumber'] ?? '',
      profilePicture: data?['profilePicture'] ?? '',
      longitude: data?['longitude'] ?? 0.0,
      latitude: data?['latitude'] ?? 0.0,
      timestamp: data?['timestamp'] ?? Timestamp.now(),
      isRentedAVehicle: data?['isRentedAVehicle'] ?? Timestamp.now(),
      noOfRating: data?['noOfRating'] ?? 0,
      rating: data?['rating'] ?? 0.0,
    );
  }
}
