import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/common_methods.dart';

class PaymentController extends GetxController {
  var isloading = false.obs;
  List<String> month = [
    'Select',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  var selectmonth = 'Select'.obs;
  var MonthTypeErrorText = ''.obs;
  var EmpId = ''.obs;

  void updateMonth(newMonth) {
    selectmonth.value = newMonth;
  }

  void validateSexType() {
    if (selectmonth.value == 'Select') {
      MonthTypeErrorText.value = "please ";
      showToast('Select sex');
    } else {
      MonthTypeErrorText.value = "";
    }
  }

  String getNumericMonth(String monthName) {
    int numericMonth = month.indexOf(monthName) + 0;
    print(numericMonth);
    // Pad the numeric month with a leading zero if it's a single-digit number
    return numericMonth.toString().padLeft(2, '0');
  }

  void fetchEmployeeRecords(String employeeId, String selectedMonth) async {
    isloading.value = true; // Show loading indicator

    try {
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
            .where('employee Id', isEqualTo: employeeId)
            .get();

        if (employeeSnapshot.docs.isNotEmpty) {
          DocumentSnapshot employeeDoc = employeeSnapshot.docs.first;

          // Get the 'Record' collection reference for the employee
          CollectionReference recordCollection =
              employeeDoc.reference.collection('Record');

          // Fetch the data for the selected month
          QuerySnapshot recordSnapshot = await recordCollection.get();

          // Now you can filter the records based on the selected month and year
          List<QueryDocumentSnapshot> selectedMonthRecords =
              recordSnapshot.docs.where((doc) {
            String currentDate = doc.get('current date');
            // Split the current date to get the month and year parts
            List<String> dateParts = currentDate.split('-');
            String monthPart =
                dateParts[1]; // Index 1 represents the month part
            String yearPart = dateParts[2]; // Index 2 represents the year part

            String month = getNumericMonth(selectedMonth);
            // Check if the month part and year part match the selected month and current year
            return monthPart == month &&
                yearPart == DateTime.now().year.toString();
          }).toList();

          // Process the selected month records as needed
          for (var record in selectedMonthRecords) {
            print('Employee Record for $selectedMonth: ${record.data()}');
            // Do any processing or manipulation of data here
          }
        } else {
          showToast('Selected employee not found');
        }
      } else {
        showToast('User not logged in');
        print('User not logged in');
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'An error occurred while fetching employee records',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      print('Error fetching employee records: $error');
    }

    isloading.value = false; // Hide loading indicator
    update();
  }
}
