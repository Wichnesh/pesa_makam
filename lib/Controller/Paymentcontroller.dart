import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../Model/PaymentModel.dart';
import '../utils/common_methods.dart';

enum PaymentType { Advance, Salary }

class PaymentController extends GetxController {
  var isloading = false.obs;
  var enablePDF = false.obs;
  List<String> employeename = <String>[].obs;
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

  TextEditingController perdaywagesText = TextEditingController();
  TextEditingController totalworkingdaysText = TextEditingController();
  TextEditingController monthlysalaryText = TextEditingController();
  TextEditingController workingdaysText = TextEditingController();
  TextEditingController noofnonwrkeddaysText = TextEditingController();
  TextEditingController payablesalaryText = TextEditingController();
  TextEditingController deductionamtText = TextEditingController();
  TextEditingController AdvanceamtText = TextEditingController();
  TextEditingController AdvanceavailableText = TextEditingController();
  List<Employee> employeeList = <Employee>[].obs;
  Employee? selectedEmployee;
  var selectmonth = 'Select'.obs;
  var MonthTypeErrorText = ''.obs;
  var EmpId = ''.obs;
  RxInt perdaywages = 0.obs;
  RxInt monthlysalary = 0.obs;
  RxInt workingdays = 0.obs;
  RxInt totalworkingdays = 0.obs;
  RxInt noofnonwrkeddays = 0.obs;
  RxInt payablesalary = 0.obs;
  RxInt deductionamt = 0.obs;
  RxInt Advance = 0.obs;
  var showdetails = false.obs;
  var Advancebool = false.obs;
  var AdvanceAvailable = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEmployeeNameList();
  }

  var paymentType = PaymentType.Salary.obs; // Default to 'Salary'

  void setPaymentType(PaymentType type) {
    paymentType.value = type;
    checkPaymentTypeAndSetAdvancebool();
  }

  void checkPaymentTypeAndSetAdvancebool() {
    if (isAdvanceSelected()) {
      Advancebool.value = true;
    } else if (isSalarySelected()) {
      Advancebool.value = false;
    }
  }

  bool isAdvanceSelected() => paymentType.value == PaymentType.Advance;
  bool isSalarySelected() => paymentType.value == PaymentType.Salary;

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

  void fetchEmployeeNameList() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    isloading.value = true;
    update();

    if (userEmail != null) {
      try {
        // Get the Firestore reference to the user's collection
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('Users').doc(userEmail);

        // Get the category collection reference
        CollectionReference employeeCollection =
            userDocRef.collection('employee');

        // Fetch the category documents from Firestore
        QuerySnapshot querySnapshot = await employeeCollection.get();

        // Update the employees list with the fetched data
        List<Employee> fetchedEmployees = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Employee(
              data['name'] as String, data['employee Id'] as String, data['Date of Joining'] as String);
        }).toList();

        // Clear the current list of employee names and IDs
        employeename.clear();

        // Update the employees list with the fetched data
        employeename.addAll(fetchedEmployees
            .map((employee) => '${employee.name} - ${employee.employeeId} - ${employee.doj}'));

        // Update the list of Employee objects separately
        employeeList.clear();
        employeeList.addAll(fetchedEmployees);

        // Check if the selectedEmployee is null or not in the updated list
        if (selectedEmployee != null &&
            !employeeList.contains(selectedEmployee)) {
          selectedEmployee = null;
        }

        isloading.value = false; // Set loading flag to false
        showToast('employee name list available');
        print('employee name list fetched from Firestore successfully!');
      } catch (error) {
        Get.snackbar("Error", "Error Occurred....!",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
        print('Error fetching category list from Firestore: $error');
        isloading.value = false;
      }
      isloading.value = false;
      update();
    }
  }

  void fetchEmployeeRecords(String employeeId, String selectedMonth) async {
    isloading.value = true; // Show loading indicator

    try {
      int checkInCount = 0;
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

          try {
            // Get the per-day wages from the employee document
            perdaywages = RxInt(int.parse(employeeDoc.get('per day wages')));

            // Check if the 'AdvanceRecord' collection exists for the employee
            CollectionReference advanceRecordCollection =
                employeeDoc.reference.collection('AdvanceRecord');
            String month = getNumericMonth(selectedMonth);
            // Get the current month and year
            DateTime now = DateTime.now();
            String currentMonthAndYear = '$month-${now.year}';

            // Fetch the Advance amount for the current month and year
            DocumentSnapshot advanceDoc =
                await advanceRecordCollection.doc(currentMonthAndYear).get();

            if (advanceDoc.exists) {
              // AdvanceRecord exists for the current month and year
              String advanceAmount =
                  advanceDoc.get('Advance amount').toString();
              Advance = RxInt(int.parse(advanceAmount));
              print('Advance amount for $currentMonthAndYear: $advanceAmount');
            } else {
              // AdvanceRecord does not exist for the current month and year
              print('No Advance data available for $currentMonthAndYear');

              // Create the 'AdvanceRecord' collection and add an initial record
              String currentDate = DateFormat('dd-MM-yyyy').format(now);
              await advanceRecordCollection.doc(currentMonthAndYear).set({
                'Advance amount':
                    '0', // You can set the initial Advance amount to 0 or any other value
                'Current date': currentDate,
              });
              Advance.value = 0;
              print(
                  'AdvanceRecord collection created for $currentMonthAndYear');
            }
          } catch (e) {
            print('Error fetching employee records: $e');
          }
          // Get the 'Record' collection reference for the employee
          CollectionReference recordCollection =
              employeeDoc.reference.collection('Record');

          // Fetch the data for the selected month
          QuerySnapshot recordSnapshot = await recordCollection.get();

          List<EmployeeRecord> selectedMonthRecords = recordSnapshot.docs
              .where((doc) {
                String currentDate = doc.get('current date');
                List<String> dateParts = currentDate.split('-');
                String monthPart = dateParts[1];
                String yearPart = dateParts[2];

                String month = getNumericMonth(selectedMonth);
                return monthPart == month &&
                    yearPart == DateTime.now().year.toString();
              })
              .map<EmployeeRecord>((doc) => EmployeeRecord.fromFirestore(
                  doc.data() as Map<String, dynamic>?))
              .toList();

          // Process the selected month records as needed
          for (var record in selectedMonthRecords) {
            print('Employee Record for $selectedMonth: ${record.currentDate}');
            print(
                'Employee Record for $selectedMonth: ${record.totalWorkingHours}');
            if (record.checkIn.isNotEmpty) {
              checkInCount++;
            }
          }

          print('Present -- $checkInCount');

          workingdays = RxInt(checkInCount);
          // Print the numeric representation of the selected month (e.g., "07")
          String numericMonth = getNumericMonth(selectedMonth);
          print('Numeric representation of $selectedMonth: $numericMonth');

          // Get the total number of days in the selected month
          totalworkingdays = RxInt(
              DateTime(DateTime.now().year, int.parse(numericMonth) + 1, 0)
                  .day);
          print('Total days in $selectedMonth: $totalworkingdays');

          noofnonwrkeddays.value = (totalworkingdays.value - workingdays.value);
          print('Non-working days: $noofnonwrkeddays');

          monthlysalary.value = (totalworkingdays.value * perdaywages.value);
          print('monthly salary -- $monthlysalary');

          AdvanceavailableText.text =
              ((workingdays.value * perdaywages.value) - Advance.value)
                  .toString();

          payablesalary.value =
              (workingdays.value * perdaywages.value) - Advance.value;
          print('worked salary  -- $payablesalary');

          deductionamt.value =
              ((monthlysalary.value - payablesalary.value) - Advance.value);
          print('deduction amount -- $deductionamt');
          enablePDF.value =true;
          showdetails.value = true;
          update();
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

  // Method to update the Advance amount inside the employee collection
  void updateAdvanceAmount(
      String employeeId, int advanceAvailable, String selectedMonth) async {
    isloading.value = true;
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail == null) {
      showToast('User not logged in');
      return;
    }

    try {
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

      if (employeeSnapshot.docs.isEmpty) {
        showToast('Selected employee not found');
        return;
      }

      // Get the first employee document reference
      DocumentReference employeeDocRef = employeeSnapshot.docs.first.reference;

      // Create the AdvanceRecord collection if it does not exist
      CollectionReference advanceRecordCollection =
          employeeDocRef.collection('AdvanceRecord');

      // Get the current month and year
      DateTime now = DateTime.now();
      String month = getNumericMonth(selectedMonth);
      String currentMonthAndYear = '$month-${now.year}';
      String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      // Update the Advance amount for the selected employee in AdvanceRecord
      String advanceFinal =
          (advanceAvailable + int.parse(AdvanceamtText.text)).toString();
      DocumentReference advanceDocRef =
          advanceRecordCollection.doc(currentMonthAndYear);
      await advanceDocRef.update({
        'Advance amount': advanceFinal,
        'Current date': currentDate,
      });

      showToast('Advance amount updated successfully');
    } catch (error) {
      showToast('Error updating Advance amount');
      print('Error updating Advance amount: $error');
    }
    isloading.value = false;
    update();
    Get.back();
  }

  Future<void> generatePdfPayslip(String employeeName, String month, String empID,String doj) async {
    final pdf = pw.Document();

    // Content of the payslip
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'RESTOREN AL-ASMI (24 JAM) PAYSLIP',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
                  ),
                  pw.Text(
                    'Month: $month',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Employee Information
              pw.Text('Employee ID: $empID'),
              pw.SizedBox(height: 10),
              pw.Text('Employee Name: $employeeName'),
              pw.SizedBox(height: 20),
              // pw.Text('Employee D.O.J: $doj'),
              // pw.SizedBox(height: 20),

              // Payslip Details Table
              pw.Table.fromTextArray(
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                headerHeight: 25,
                cellHeight: 20,
                cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.centerRight},
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Description', 'BreakDown'],
                data: [
                  ['Total Working Days', '${totalworkingdays.value} Days'], // Replace with actual data
                  ['Working Days', '${workingdays.value} Days'], // Replace with actual data
                  ['Monthly Salary', 'RM ${monthlysalary.value}'], // Replace with actual data
                  ['Deduction Amount', 'RM ${deductionamt.value}'],
                  ['Advance Taken','RM ${Advance.value}'],
                  ['Net Salary', 'RM ${payablesalary.value}'], // Replace with actual data
                ],
              ),
              pw.Spacer(),

              // Signatures
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Employee Signature: _________________'),
                  pw.Text('Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}'),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Employer Signature: _________________'),
                  pw.Text('Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}'),
                ],
              ),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final pdfFile = File('${dir.path}/Payslip_${employeeName}_$month.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Open the PDF file
    await OpenFile.open(pdfFile.path);
  }

}
