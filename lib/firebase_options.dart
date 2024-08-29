// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAFPBDAIqoDHjaNyyOVpTD1eS641oiq-QE',
    appId: '1:732926640178:web:0fe03a50de34fe4db2fc2b',
    messagingSenderId: '732926640178',
    projectId: 'storefront-db898',
    authDomain: 'storefront-db898.firebaseapp.com',
    storageBucket: 'storefront-db898.appspot.com',
    measurementId: 'G-2G1DL604L3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpHI5Z1U20ihOpQPKi62Ig6DQd6OkfG7o',
    appId: '1:732926640178:android:afc629e83f121a4fb2fc2b',
    messagingSenderId: '732926640178',
    projectId: 'storefront-db898',
    storageBucket: 'storefront-db898.appspot.com',
  );
}
