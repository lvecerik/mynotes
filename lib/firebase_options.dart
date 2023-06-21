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
    apiKey: 'AIzaSyCGoUm1mYZ-ivP9GMfKKpkNxiFORe77Dqo',
    appId: '1:958846460808:web:0727d336e380e1676a103d',
    messagingSenderId: '958846460808',
    projectId: 'lvnotes',
    authDomain: 'lvnotes.firebaseapp.com',
    storageBucket: 'lvnotes.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfImb8xguFU7o7bQhcrMziZaC2LGKB4DY',
    appId: '1:958846460808:android:e964198a1736d9cf6a103d',
    messagingSenderId: '958846460808',
    projectId: 'lvnotes',
    storageBucket: 'lvnotes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnyk1Nb-YLauc8OX3vHdOd6MsQ4pzOEZs',
    appId: '1:958846460808:ios:7e306007fa0b7d966a103d',
    messagingSenderId: '958846460808',
    projectId: 'lvnotes',
    storageBucket: 'lvnotes.appspot.com',
    iosClientId: '958846460808-028ustankn6gjb9q6kk3i4qcv4d0dc15.apps.googleusercontent.com',
    iosBundleId: 'com.example.myNotes',
  );
}