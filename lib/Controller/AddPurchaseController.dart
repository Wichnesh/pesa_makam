import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/utils/common_methods.dart';

import 'PurchaseController.dart';

class AddPurchaseController extends GetxController {
  var isloading = false.obs;
  var vendorname = "".obs;
  var Amount = "".obs;
  var taxpercentage = "".obs;
  var taxamount = "".obs;
  var Totalamount = "".obs;
  var orderdateText = "".obs;
  var pendingdateText = "".obs;
  var selectedpaymenttype = "".obs;
  final TextEditingController OrderDateText = TextEditingController();
  final TextEditingController PendingDateText = TextEditingController();
  final TextEditingController TaxAmountText = TextEditingController();
  final TextEditingController TotalAmountText = TextEditingController();
  DateTime? OrderselectedDate;
  DateTime? PendingselectedDate;
  RxBool isChecked = false.obs;

  void setChecked(bool value) {
    isChecked.value = value;
    if (isChecked == true) {
      print('Net Payment'); // Replace this with your desired action
      selectedpaymenttype.value = "Net Payment";
    } else {
      print('not selected');
      selectedpaymenttype.value = "";
    }
    update();
  }

  void calculateAmounts() {
    double amountValue = double.tryParse(Amount.value) ?? 0.0;
    double taxPercentageValue = double.tryParse(taxpercentage.value) ?? 0.0;
    double taxAmountValue = (amountValue * taxPercentageValue) / 100.0;
    double totalAmountValue = amountValue + taxAmountValue;

    taxamount.value = taxAmountValue.toString();
    Totalamount.value = totalAmountValue.toString();
    update();
  }

  Future<void> submitDataToFirestore() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;
        // Check if all required values are available
        if (vendorname.value.isEmpty ||
            Amount.value.isEmpty ||
            taxpercentage.value.isEmpty ||
            taxamount.value.isEmpty ||
            Totalamount.value.isEmpty ||
            OrderselectedDate == null ||
            orderdateText.value.isEmpty ||
            isChecked.value == false ||
            pendingdateText.value.isEmpty) {
          // Show a dialog box indicating that all fields must be filled
          showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: Text('Incomplete Data'),
                content: Text('Please fill in all the fields to submit.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }
        // Check if the user already exists in the Users collection
        final userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (userSnapshot.size == 1) {
          // User exists, create a new document in the Purchase collection
          final purchaseData = {
            'vendorName': vendorname.value,
            'amount': Amount.value,
            'taxPercentage': taxpercentage.value,
            'taxAmount': taxamount.value,
            'totalAmount': Totalamount.value,
            'payment': selectedpaymenttype.value,
            'orderDate': orderdateText.value,
            'pendingDate ': pendingdateText.value
          };

          final purchaseRef = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userSnapshot.docs[0].id)
              .collection('Purchase')
              .add(purchaseData)
              .then((value) {
            PurchaseController purchaseController =
                Get.find<PurchaseController>();
            purchaseController.fetchPurchaseData();
            showToast('Data saved Successfully');
            Get.back();
          });
        } else {
          // User doesn't exist in the Users collection
          showToast('Data Not saved Successfully');
        }
      }
    } catch (e) {
      print('Error submitting data to Firestore: $e');
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to add purchase',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      );
    }
  }
}
