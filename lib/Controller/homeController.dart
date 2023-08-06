import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Eventcapture/event_logger_controller.dart';
import '../Model/Homemodel.dart';
import '../utils/common_methods.dart';
import 'logincontroller.dart';

class HomeController extends GetxController {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User?> currentUser = Rx<User?>(null);
  var isloading = false.obs;
  List<String> categories = <String>[].obs;
  List<CategoryDetail> Detail = [];
  var istabscreenloading = false.obs;
  final EventLoggerController eventLoggerController =
      Get.find<EventLoggerController>();

  @override
  void onInit() {
    // Register EventLoggerController in the GetX service locator
    Get.put<EventLoggerController>(EventLoggerController());
    requestLocationPermission();
    eventLoggerController;
    // TODO: implement onInit
    getCurrentUser();
    fetchCategoriesFromFirestore();
    super.onInit();
  }

  Future<void> getCurrentUser() async {
    if (kDebugMode) {
      print('fetching user data');
    }
    currentUser.value = await auth.currentUser;
    User? user = currentUser.value;

    while (user == null) {
      // User data not available yet, wait for a short duration
      await Future.delayed(const Duration(seconds: 1));

      // Check again for user data
      currentUser.value = await auth.currentUser;
      user = currentUser.value;
    }

    if (user == null) {
      print('User data not available');
    } else {
      print(user.displayName);
      print(user.email);
    }
    update();
  }

  Future<void> fetchCategoriesFromFirestore() async {
    print('Category fetching started successfully');
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    isloading.value = true;
    update();

    if (userEmail != null) {
      try {
        // Get the Firestore reference to the user's collection
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('Users').doc(userEmail);

        // Get the category collection reference
        CollectionReference categoryCollection =
            userDocRef.collection('categories');

        // Fetch the category documents from Firestore
        QuerySnapshot querySnapshot = await categoryCollection.get();

        // Update the categories list with the fetched data
        List<String> fetchedCategories = querySnapshot.docs
            .map(
                (doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
            .toList();

        categories.assignAll(fetchedCategories);
        isloading.value = false; // Set loading flag to false

        if (kDebugMode) {
          print(categories[0]);
        }
        printCategoryDetails(categories[0]);

        if (kDebugMode) {
          print('Category list fetched from Firestore successfully!');
        }
        eventLoggerController.addLog(
            'Home Controller : Category list fetched from Firestore successfully');
      } catch (error) {
        Get.snackbar("Error", "Error Occurred....!",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
        if (kDebugMode) {
          print('Error fetching category list from Firestore: $error');
        }
        isloading.value = false;
        throw Exception('Add Item ---- Error occurred $error');
      }
      isloading.value = false;
      update();
    } else {
      isloading.value = false;
      update();
    }
  }

  Future<List<CategoryDetail>> printCategoryDetails(String categoryName) async {
    istabscreenloading.value = true;
    update();
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        // Get the Firestore reference to the user's collection
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('Users').doc(userEmail);

        // Get the category collection reference
        CollectionReference categoryCollection =
            userDocRef.collection('categories');

        // Check if the category exists in Firestore
        QuerySnapshot categorySnapshot = await categoryCollection
            .where('name', isEqualTo: categoryName)
            .get();

        if (categorySnapshot.docs.isNotEmpty) {
          DocumentSnapshot categoryDoc = categorySnapshot.docs.first;

          // Get the category ID
          String categoryId = categoryDoc.id;

          // Get the category detail collection reference
          CollectionReference categoryDetailCollection =
              categoryDoc.reference.collection('categorydetail');

          // Fetch the category details from Firestore
          QuerySnapshot querySnapshot = await categoryDetailCollection.get();

          // Print the category details in a list
          List<Map<String, dynamic>> categoryDetails = querySnapshot.docs
              .map((doc) => (doc.data() as Map<String, dynamic>))
              .toList();

          print('Category: $categoryName');
          for (var detail in categoryDetails) {
            print('Name: ${detail['name']}');
            print('Description: ${detail['description']}');
            print('Price: ${detail['price']}');
            print('Image: ${detail['image']}');
            print('--------------------------------');
          }

          for (var detail in categoryDetails) {
            CategoryDetail categoryDetail = CategoryDetail(
              name: detail['name'],
              description: detail['description'],
              price: detail['price'],
              image: detail['image'],
            );
            Detail.add(categoryDetail);
          }
          eventLoggerController.addLog(
              'Home Controller : printCategoryDetails : Category Detail available $categoryName');
          istabscreenloading.value = false;

          update();
        } else {
          eventLoggerController.addLog(
              'Home Controller : printCategoryDetails : Category $categoryName does not exist in Firestore');
          if (kDebugMode) {
            print('Category $categoryName does not exist in Firestore');
          }
          istabscreenloading.value = false;
        }
      }
    } catch (error) {
      eventLoggerController.addLog(
          'Home Controller : printCategoryDetails : Error fetching category details from Firestore: $error');
      if (kDebugMode) {
        print('Error fetching category details from Firestore: $error');
      }
      istabscreenloading.value = false;
      throw Exception('Add Item ---- Error occurred $error');
    }
    update();
    return Detail;
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted
      print('Location permission granted.');
    } else if (status.isDenied) {
      // Permission denied
      print('Location permission denied.');
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied
      if (kDebugMode) {
        print('Location permission permanently denied.');
      }
      // You can show a dialog here to guide the user to enable the permission manually
    } else if (status.isRestricted) {
      // Permission is restricted on the device (only available on iOS)
      if (kDebugMode) {
        print('Location permission is restricted on this device.');
      }
    }
    // You can handle other permission statuses as needed
  }
}
