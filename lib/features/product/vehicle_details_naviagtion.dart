// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
// // ignore: unused_import
// import 'package:geocoding_platform_interface/src/models/location.dart'
//     as GeocodingLocation;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// // ignore: unused_import
// import 'package:location/location.dart' as DeviceLocation;
// import 'package:xplorit/common_widgets/back_botton_widget.dart';
// import 'package:xplorit/utils/constants/api_constants.dart';
// import 'package:xplorit/utils/constants/colors.dart';

// class NavigationToShop extends StatefulWidget {
//   const NavigationToShop(
//       {required this.locationName, required this.distance, Key? key})
//       : super(key: key);

//   final String locationName;
//   final double distance;

//   @override
//   State<NavigationToShop> createState() => _NavigationToShopState();
// }

// double longitude = 0.0;
// double latitude = 0.0;
// String vehicleCity = 'unknown';

// class _NavigationToShopState extends State<NavigationToShop> {
//   double longitude = 0.0;
//   double latitude = 0.0;
//   String vehicleCity = 'unknown';

//   final DeviceLocation.Location _locationController = DeviceLocation.Location();
//   final Completer<GoogleMapController> _mapController =
//       Completer<GoogleMapController>();

//   static const LatLng _pGooglePlex = LatLng(
//     33.6844,
//     73.0479,
//   );

//   LatLng _pApplePark = LatLng(
//     31.5497,
//     74.3436,
//   );
//   LatLng? _currentP;
//   Map<PolylineId, Polyline> polylines = {};

//   Future<String> _fetchAddress(String location) async {
//     try {
//       List<String> coordinates = location.split(',');
//       setState(() {
//         longitude = double.parse(coordinates[0]);
//         latitude = double.parse(coordinates[1]);
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latitude,
//         longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark placemark = placemarks.first;
//         vehicleCity = placemark.subAdministrativeArea ?? '';
//       }
//     } catch (e) {
//       print('Error fetching address: $e');

//       vehicleCity = 'Error fetching address';
//     }
//     return vehicleCity;
//   }

//   Future<void> _getVehicleLocation() async {
//     vehicleCity = await _fetchAddress(widget.locationName);
//     setState(() {
//       _pApplePark = LatLng(latitude, longitude);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getVehicleLocation().then((_) {
//       getLocationUpdates().then((_) {
//         getPolylinePoints().then((coordinates) {
//           generatePolyLineFromPoints(coordinates);
//         });
//       });
//     });
//   }

//   Future<void> getLocationUpdates() async {
//     bool _serviceEnabled;
//     DeviceLocation.PermissionStatus _permissionGranted;

//     _serviceEnabled = await _locationController.serviceEnabled();
//     if (_serviceEnabled) {
//       _serviceEnabled = await _locationController.requestService();
//     } else {
//       return;
//     }

//     _permissionGranted = await _locationController.hasPermission();
//     if (_permissionGranted == DeviceLocation.PermissionStatus.denied) {
//       _permissionGranted = await _locationController.requestPermission();
//       if (_permissionGranted != DeviceLocation.PermissionStatus.granted) {
//         return;
//       }
//     }

//     _locationController.onLocationChanged
//         .listen((DeviceLocation.LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           _currentP =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           _cameraToPosition(_currentP!);
//         });
//       }
//     });
//   }

//   Future<List<LatLng>> getPolylinePoints() async {
//     List<LatLng> polylineCoordinates = [];
//     try {
//       PolylinePoints polylinePoints = PolylinePoints();
//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         GOOGLE_MAPS_API_KEY,
//         PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
//         PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
//         travelMode: TravelMode.driving,
//       );
//       if (result.points.isNotEmpty) {
//         result.points.forEach((PointLatLng point) {
//           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         });
//       } else {
//         print(result.errorMessage);
//       }
//     } catch (e) {}
//     return polylineCoordinates;
//   }

//   Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
//     await controller
//         .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
//   }

//   void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//         polylineId: id,
//         color: TColors.primary,
//         points: polylineCoordinates,
//         width: 8);
//     setState(() {
//       polylines[id] = polyline;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: ((GoogleMapController controller) =>
//                 _mapController.complete(controller)),
//             initialCameraPosition:
//                 CameraPosition(target: _pGooglePlex, zoom: 13),
//             markers: {
//               if (_currentP != null)
//                 Marker(
//                     markerId: MarkerId("_currentLocation"),
//                     position: _currentP!),
//               Marker(
//                   markerId: MarkerId("_sourceLocation"),
//                   position: _pGooglePlex),
//               Marker(
//                   markerId: MarkerId("_destionationLocation"),
//                   position: _pApplePark)
//             },
//             polylines: Set<Polyline>.of(polylines.values),
//           ),
//           Positioned(
//             top: 50,
//             left: 10,
//             child: BackButtonWidget(),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               height: 100,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: TColors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text('${widget.distance.toStringAsFixed(2)} km(s)',
//                           style: Theme.of(context)
//                               .textTheme
//                               .headlineMedium
//                               ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green)),
//                       // Text(' (20 min)',
//                       //     style: Theme.of(context)
//                       //         .textTheme
//                       //         .headlineMedium
//                       //         ?.copyWith(
//                       //             fontWeight: FontWeight.bold,
//                       //             color: Colors.black)),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(widget.locationName,
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                           fontWeight: FontWeight.normal, color: Colors.black)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as DeviceLocation;
import 'package:xplorit/utils/constants/api_constants.dart'; // Import your API key

class NavigationToShop extends StatefulWidget {
  const NavigationToShop({
    required this.latitude,
    required this.longitude,
    Key? key,
  }) : super(key: key);

  final double latitude;
  final double longitude;

  @override
  State<NavigationToShop> createState() => _NavigationToShopState();
}

class _NavigationToShopState extends State<NavigationToShop> {
  final DeviceLocation.Location _locationController = DeviceLocation.Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng _destination =
      LatLng(0, 0); // This will be updated to the passed location
  LatLng? _currentLocation;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _destination = LatLng(widget.latitude, widget.longitude);
    _getCurrentLocation().then((_) {
      _drawRoute();
    });
  }

  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    DeviceLocation.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == DeviceLocation.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != DeviceLocation.PermissionStatus.granted) {
        return;
      }
    }

    DeviceLocation.LocationData locationData =
        await _locationController.getLocation();
    setState(() {
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  Future<void> _drawRoute() async {
    if (_currentLocation == null) return;

    List<LatLng> polylineCoordinates = [];
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_MAPS_API_KEY,
        PointLatLng(_currentLocation!.latitude, _currentLocation!.longitude),
        PointLatLng(_destination.latitude, _destination.longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        _addPolyline(polylineCoordinates);
      } else {
        print(result.errorMessage);
      }
    } catch (e) {
      print('Error drawing route: $e');
    }
  }

  void _addPolyline(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                        markerId: MarkerId("currentLocation"),
                        position: _currentLocation!),
                    Marker(
                        markerId: MarkerId("destination"),
                        position: _destination),
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  child: BackButton(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
    );
  }
}
