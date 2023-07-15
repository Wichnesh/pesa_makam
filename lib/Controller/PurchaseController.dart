import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/PurchaseModel.dart';

class PurchaseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var purchases = <PurchaseModel>[].obs;


  void onInit() {
    fetchPurchaseData();
    super.onInit();
  }

  void fetchPurchaseData() async {
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
          final purchaseSnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userSnapshot.docs[0].id)
              .collection('Purchase')
              .get();

          purchases.value = purchaseSnapshot.docs.map((doc) {
            final purchaseData = doc.data();
            return PurchaseModel(
              vendorName: purchaseData['vendorName'],
              amount: purchaseData['amount'],
              taxPercentage: purchaseData['taxPercentage'],
              taxAmount: purchaseData['taxAmount'],
              totalAmount: purchaseData['totalAmount'],
              payment: purchaseData['payment'],
              orderDate: purchaseData['orderDate'],
              pendingDate: purchaseData['pendingDate'],
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
    update();
  }
}
