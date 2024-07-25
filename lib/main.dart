// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDQSmz55WSujNDhnO4lFfBQYSXSIMCPnbA',
      projectId: 'add-otp-6d230',
      messagingSenderId: '996257690539',
      appId: '1:996257690539:android:9c2d6dc897f09b095c98ee',
      storageBucket: 'gs://add-otp-6d230.appspot.com',
    ),
  );

  runApp(const App());
}
// Platform  Firebase App Id
// web       1:996257690539:web:a90fd0957c1cad6e5c98ee
// android   1:996257690539:android:9c2d6dc897f09b095c98ee
// ios       1:996257690539:ios:6919e3c1ab755f915c98ee
// macos     1:996257690539:ios:ff9c24b68d1827b15c98ee
