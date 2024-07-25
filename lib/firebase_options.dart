// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDQSmz55WSujNDhnO4lFfBQYSXSIMCPnbA',
    appId: '1:996257690539:web:a90fd0957c1cad6e5c98ee',
    messagingSenderId: '996257690539',
    projectId: 'add-otp-6d230',
    authDomain: 'add-otp-6d230.firebaseapp.com',
    storageBucket: 'add-otp-6d230.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-y2RhwDjVmA31IyCFYmRrvW3yQfXE5Qk',
    appId: '1:996257690539:android:9c2d6dc897f09b095c98ee',
    messagingSenderId: '996257690539',
    projectId: 'add-otp-6d230',
    storageBucket: 'add-otp-6d230.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHk-aoe2rTUwfD8pWcNss3MPdeQUl1PmI',
    appId: '1:996257690539:ios:6919e3c1ab755f915c98ee',
    messagingSenderId: '996257690539',
    projectId: 'add-otp-6d230',
    storageBucket: 'add-otp-6d230.appspot.com',
    iosBundleId: 'com.example.xplorit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDHk-aoe2rTUwfD8pWcNss3MPdeQUl1PmI',
    appId: '1:996257690539:ios:ff9c24b68d1827b15c98ee',
    messagingSenderId: '996257690539',
    projectId: 'add-otp-6d230',
    storageBucket: 'add-otp-6d230.appspot.com',
    iosBundleId: 'com.example.xplorit.RunnerTests',
  );
}