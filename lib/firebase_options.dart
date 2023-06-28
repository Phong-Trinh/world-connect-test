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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBH7RXrQI2DH072A0D6l3DlYnqgqLjiBAA',
    appId: '1:1022459276719:android:1fc753208207f05bc6135a',
    messagingSenderId: '1022459276719',
    projectId: 'world-connect-test',
    storageBucket: 'world-connect-test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjLIL30x5FaoIYG3Bfi496YoZuCuLhLjo',
    appId: '1:1022459276719:ios:bc7e847e8f518633c6135a',
    messagingSenderId: '1022459276719',
    projectId: 'world-connect-test',
    storageBucket: 'world-connect-test.appspot.com',
    androidClientId: '1022459276719-g5m4reu07pk2ilvdjm3a2r2d6geko0im.apps.googleusercontent.com',
    iosClientId: '1022459276719-b8fhrsq0s4v41v18mssc7ehnjr4umkpp.apps.googleusercontent.com',
    iosBundleId: 'com.example.worldConnectTest',
  );
}
