import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Model/AttendanceModel.dart';
import '../utils/common_methods.dart';

class AttendanceController extends GetxController {
  var employeenamelist = <Employeelist>[].obs;
  var currentattendancedetails = <EmployeeRecord>[].obs;
  var selectemployeename = "Select".obs;
  var isloading = false.obs;
  RxList<String> employeeNames = RxList<String>();
  var showinout = false.obs;
  var checkouttime = "".obs;
  var checkinbool = true.obs;
  var checkintime = "".obs;
  var displayslider = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void onInit() {
    fetchEmployeeListData();
    showinout.value = true;
    super.onInit();
  }

  void updateEmployeename(newname) {
    selectemployeename.value = newname;
  }

  void fetchEmployeeListData() async {
    isloading.value = true;
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;

        final userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (userSnapshot.size == 1) {
          final employeeSnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userSnapshot.docs[0].id)
              .collection('employee')
              .get();

          employeenamelist.value = employeeSnapshot.docs.map((doc) {
            final employeedata = doc.data();
            return Employeelist(
              name: employeedata['name'],
            );
          }).toList();
        }
      }

      update();
    } catch (e) {
      print('Error fetching purchase data: $e');
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to fetch purchase data',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      );
    }
    isloading.value = false;
    update();
  }

  void fetchEmployeeByName() async {
    try {
      if (selectemployeename.value == 'Select') {
        // Display error dialog if category is not selected
        Get.dialog(
          AlertDialog(
            title: Text('Incorrect'),
            content: Text('Please fill in all fields.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      } else {
        isloading.value = true; // Show loading indicator
        update();

        String? userEmail = FirebaseAuth.instance.currentUser?.email;
        if (userEmail != null) {
          // Get the Firestore reference to the user's collection
          DocumentReference userDocRef =
              FirebaseFirestore.instance.collection('Users').doc(userEmail);

          // Get the category collection reference
          CollectionReference employeeCollection =
              userDocRef.collection('employee');

          // Check if the selected category exists in Firestore
          QuerySnapshot employeeSnapshot = await employeeCollection
              .where('name', isEqualTo: selectemployeename.value)
              .get();

          if (employeeSnapshot.docs.isNotEmpty) {
            DocumentSnapshot categoryDoc = employeeSnapshot.docs.first;

            // Create a new document in the 'categorydetail' collection
            CollectionReference employeeRecordCollection =
                categoryDoc.reference.collection('Record');

            // Generate a new document ID based on date-month-year format
            String currentDate =
                DateFormat('dd-MM-yyyy').format(DateTime.now());
            DocumentReference newCategoryDetailDoc =
                employeeRecordCollection.doc(currentDate);

            // Check if the document already exists
            DocumentSnapshot documentSnapshot =
                await newCategoryDetailDoc.get();
            if (documentSnapshot.exists) {
              // Document already exists, check the check-in and check-out fields
              Map<String, dynamic> documentData =
                  documentSnapshot.data() as Map<String, dynamic>? ?? {};

              String checkIn = documentData['check in'] as String? ?? '';
              String checkOut = documentData['check out'] as String? ?? '';

              if (checkIn.isNotEmpty && checkOut.isEmpty) {
                // Check-in done, but check-out not done
                checkintime.value = checkIn;
                checkinbool.value = true;
                showinout.value = false;
                update();
              } else if (checkIn.isNotEmpty && checkOut.isNotEmpty) {
                checkintime.value = checkIn;
                checkouttime.value = checkOut;
                showinout.value = false;
                displayslider.value = false;
              } else if (checkIn.isEmpty && checkOut.isEmpty) {
                // Check-in and check-out both done, or no check-in recorded yet
                checkintime.value = "";
                checkouttime.value = "";
                checkinbool.value = false;
                showinout.value = false;
              }
              printCurrentAttendanceDetails();
            } else {
              // Document doesn't exist, create a new one
              // Create a data map with the item details
              Map<String, dynamic> itemData = {
                'current date': currentDate,
                'check in': '',
                'check out': '',
                // Add any other fields you want to save
              };
              await newCategoryDetailDoc.set(itemData);
              // Fetch the saved data
              showinout.value = false;
              checkinbool.value = false;
              print('Employee record added to Firestore successfully!');
            }
          } else {
            isloading.value = false; // Hide loading indicator
            showToast('Selected employee not found');
          }
        } else {
          isloading.value = false; // Hide loading indicator
          showToast('User not logged in');
          print('User not logged in');
        }
      }
    } catch (error) {
      isloading.value = false; // Hide loading indicator
      Get.snackbar(
        'Error',
        'An error occurred while fetching employee data',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      print('Error fetching employee data: $error');
    }
    isloading.value = false;
    update();
  }

  void Checkin() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      // Get the Firestore reference to the user's collection
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(userEmail);

      // Get the employee collection reference
      CollectionReference employeeCollection =
          userDocRef.collection('employee');

      // Check if the selected employee exists in Firestore
      QuerySnapshot employeeSnapshot = await employeeCollection
          .where('name', isEqualTo: selectemployeename.value)
          .get();

      if (employeeSnapshot.docs.isNotEmpty) {
        DocumentSnapshot employeeDoc = employeeSnapshot.docs.first;

        // Get the 'Record' collection reference for the employee
        CollectionReference recordCollection =
            employeeDoc.reference.collection('Record');

        // Generate a new document ID based on date-month-year format
        String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
        DocumentReference recordDocRef = recordCollection.doc(currentDate);

        // Update the 'check in' field with the current time
        DateTime currentTime = DateTime.now();
        String checkInTime = DateFormat('HH:mm').format(currentTime);
        await recordDocRef.update({'check in': checkInTime});

        // Update the local check-in time variable
        checkintime.value = checkInTime;
        showinout.value = false;
        checkinbool.value = true;
        update();
        showToast('Check-in Successfully');
        Get.back();
      }
    }
  }

  void Checkout() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      // Get the Firestore reference to the user's collection
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(userEmail);

      // Get the employee collection reference
      CollectionReference employeeCollection =
          userDocRef.collection('employee');

      // Check if the selected employee exists in Firestore
      QuerySnapshot employeeSnapshot = await employeeCollection
          .where('name', isEqualTo: selectemployeename.value)
          .get();

      if (employeeSnapshot.docs.isNotEmpty) {
        DocumentSnapshot employeeDoc = employeeSnapshot.docs.first;

        // Get the 'Record' collection reference for the employee
        CollectionReference recordCollection =
            employeeDoc.reference.collection('Record');

        // Generate a new document ID based on date-month-year format
        String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
        DocumentReference recordDocRef = recordCollection.doc(currentDate);

        // Update the 'check out' field with the current time
        DateTime currentTime = DateTime.now();
        String checkOutTime = DateFormat('HH:mm').format(currentTime);
        await recordDocRef.update({'check out': checkOutTime});

        // Update the local check-in time variable

        checkouttime.value = checkOutTime;
        showinout.value = false;
        checkinbool.value = true;
        update();
        showToast('Check-out time updated successfully');
        Get.back();
      }
    }
  }

  void printCurrentAttendanceDetails() {
    for (var record in currentattendancedetails) {
      print('Employee Record: $record');
      print(record.checkInBool);
    }
  }
}
