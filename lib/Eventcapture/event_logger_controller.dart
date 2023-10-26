import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EventLoggerController extends GetxController {
  RxList<String> logs = <String>[].obs;

  void addLog(String log) {
    logs.add(log);
  }

  Future<void> uploadLogsToFirebase(String? userEmail, String? deviceName,
      String? userLocation, String? userAddress) async {
    try {
      // Get logs from the controller
      List<String> logsList = logs.toList();

      // Convert logs to a single string with newline separation
      String logText = logsList.join('\n');

      // Add user information to the log text
      logText =
          "User Email: $userEmail\nDevice Name: $deviceName\nUser Location: $userLocation\nUser Address : $userAddress\n\n$logText";

      // Create a reference to the Firebase Storage bucket
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('logs')
          .child('event_logs_${DateTime.now().toString()}.txt');

      // Upload the log text to Firebase Storage as a document
      await storageRef.putString(logText);

      // Clear logs after successful upload
      logs.clear();

      if (kDebugMode) {
        print('Logs uploaded to Firebase Storage.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading logs: $e');
      }
    }
  }
}
