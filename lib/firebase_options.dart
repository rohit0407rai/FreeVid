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
    apiKey: 'AIzaSyBzgSkNxXXYU7o3a8XBuOJWhKw0qVuA6GE',
    appId: '1:686602671698:web:613ea2858e665fe80af18b',
    messagingSenderId: '686602671698',
    projectId: 'freevid-4fd84',
    authDomain: 'freevid-4fd84.firebaseapp.com',
    storageBucket: 'freevid-4fd84.appspot.com',
    measurementId: 'G-6JQ88F5F7W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD83xjsQcDvHbJMwt8AusiGL4ofwiz0oy0',
    appId: '1:686602671698:android:0cf3c9ced3f8f9e90af18b',
    messagingSenderId: '686602671698',
    projectId: 'freevid-4fd84',
    storageBucket: 'freevid-4fd84.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGHTrOwz9CnTShjkhVSXbuiBNc4u2aJU8',
    appId: '1:686602671698:ios:f538f7ce1cc45a050af18b',
    messagingSenderId: '686602671698',
    projectId: 'freevid-4fd84',
    storageBucket: 'freevid-4fd84.appspot.com',
    iosClientId: '686602671698-h32pbr3kq1gr2ar29v6bulqau2pg6os2.apps.googleusercontent.com',
    iosBundleId: 'com.example.freevid',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGHTrOwz9CnTShjkhVSXbuiBNc4u2aJU8',
    appId: '1:686602671698:ios:5766bf2ec1fb4f760af18b',
    messagingSenderId: '686602671698',
    projectId: 'freevid-4fd84',
    storageBucket: 'freevid-4fd84.appspot.com',
    iosClientId: '686602671698-kfonfajt368e6uo9v9itlnkbuen1lgdt.apps.googleusercontent.com',
    iosBundleId: 'com.example.freevid.RunnerTests',
  );
}
