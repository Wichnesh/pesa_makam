import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'event_logger_controller.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final EventLoggerController eventLoggerController =
      Get.find<EventLoggerController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  String? userEmail;
  String? deviceName;
  String? userLocation;
  String? userAddress;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        // The app is in the background
        print('App in background. Uploading logs to Firebase...');
        await _captureUserInfo();
        await eventLoggerController.uploadLogsToFirebase(
            userEmail, deviceName, userLocation, userAddress);
        break;
      case AppLifecycleState.resumed:
        // The app is resumed from the background
        print('App resumed from background.');
        break;
      default:
        break;
    }
  }

  Future<void> _captureUserInfo() async {
    try {
      // Check for location permission
      if (await Permission.location.isGranted) {
        // Get the current user from FirebaseAuth
        User? user = _auth.currentUser;
        userEmail = user?.email;

        // Get device info
        if (GetPlatform.isAndroid) {
          AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
          deviceName =
              "${androidInfo.model},${androidInfo.brand}.${androidInfo.device},${androidInfo.hardware}";
        } else if (GetPlatform.isIOS) {
          IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
          deviceName = iosInfo.utsname.machine;
        }

        // Get user location
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
        userLocation = "${position.latitude}, ${position.longitude}";

        // Get user address
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          userAddress =
              "${placemark.street}, ${placemark.locality}, ${placemark.country}";
        } else {
          userAddress = "Address not available";
        }
      } else {
        // Request location permission if not granted
        PermissionStatus permissionStatus = await Permission.location.request();
        if (permissionStatus.isGranted) {
          // Permission granted, capture user information
          await _captureUserInfo();
        } else {
          if (kDebugMode) {
            print('Location permission not granted.');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error capturing user info: $e');
      }
    }
  }
}
