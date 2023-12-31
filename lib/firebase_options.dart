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
    apiKey: 'AIzaSyC7TQ2FUlQ24U3qdt4eaPfS7h2oAKJK-ac',
    appId: '1:824088985472:android:27a77c2280cdc48e27cb65',
    messagingSenderId: '824088985472',
    projectId: 'pesamakanam-adfd9',
    storageBucket: 'pesamakanam-adfd9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9T4FNwwI5BunfM2DmSM1aHOvpE1TirPQ',
    appId: '1:824088985472:ios:2a2c2a1a1b1d3c1327cb65',
    messagingSenderId: '824088985472',
    projectId: 'pesamakanam-adfd9',
    storageBucket: 'pesamakanam-adfd9.appspot.com',
    androidClientId: '824088985472-jjj71ljvf9k6isfc7uj8p778tourn3tv.apps.googleusercontent.com',
    iosClientId: '824088985472-g7va07ikvtlune3t6h35kl3ol3l68a1i.apps.googleusercontent.com',
    iosBundleId: 'com.example.pesaMakanamApp',
  );
}
