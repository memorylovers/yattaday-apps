// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_prod.dart';
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
    apiKey: 'AIzaSyDBGm4ahnzwojY5mc_IhNLwz4oiGJ1_ctI',
    appId: '1:965620404751:web:676e2017601d69bc43097a',
    messagingSenderId: '965620404751',
    projectId: 'yattaday-prod',
    authDomain: 'yattaday-prod.firebaseapp.com',
    storageBucket: 'yattaday-prod.firebasestorage.app',
    measurementId: 'G-JC9BXN4W9W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAI5vg9E_FTrgU2om867G-w1Rsuom5Lg5E',
    appId: '1:965620404751:android:eae3aec51d5f919443097a',
    messagingSenderId: '965620404751',
    projectId: 'yattaday-prod',
    storageBucket: 'yattaday-prod.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDv4amnhTdiAOk9lm6Tsvmk3iIjFVNq_5w',
    appId: '1:965620404751:ios:f6e9b10dd94e2ddc43097a',
    messagingSenderId: '965620404751',
    projectId: 'yattaday-prod',
    storageBucket: 'yattaday-prod.firebasestorage.app',
    iosClientId:
        '965620404751-pgpbouir95b0no5skvqecmibli3tuku6.apps.googleusercontent.com',
    iosBundleId: 'com.memorylovers.yattaday',
  );
}
