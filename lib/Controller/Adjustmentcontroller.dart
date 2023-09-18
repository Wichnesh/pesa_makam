import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Model/Homemodel.dart';
import '../Model/PurchaseModel.dart';

class AdjustmentController extends GetxController {
  var isloading = false.obs;
  TextEditingController fromdatetext = TextEditingController();
  TextEditingController todatetext = TextEditingController();
  TextEditingController adjustmentPercentageText = TextEditingController();
  var totalSalesAmount = "".obs;

  var totalPurchaseAmount = "".obs;
  var totalAmount = "".obs;
  var adjTotalSalesAmount = "".obs;
  var adjTotalPurchaseAmount = "".obs;
  var adjTotalAmount = "".obs;
  final List<FilterBill> filterBills = [];
  var purchases = <FilterPurchaseModel>[].obs;
  var showdata = false.obs;
  DateTime? fromdate;
  DateTime? todate;
  var saleSelected = false.obs;
  var purchaseSelected = false.obs;

  void toggleSale() {
    saleSelected.value = !saleSelected.value;
    if (saleSelected.value) {
      if (kDebugMode) {
        print('Sale is true');
      }
    }
  }

  void togglePurchase() {
    purchaseSelected.value = !purchaseSelected.value;
    if (purchaseSelected.value) {
      if (kDebugMode) {
        print('Purchase is true');
      }
    }
  }

  Future<void> fetchSavedBillDataByDate() async {
    filterBills.clear();
    showdata.value = false;
    update();
    String fromDateStr = fromdatetext.text.toString();
    String toDateStr = todatetext.text.toString();

    // Convert fromDateStr and toDateStr to DateTime objects
    DateTime fromDate = DateFormat('dd-MM-yyyy').parse(fromDateStr);
    DateTime toDate = DateFormat('dd-MM-yyyy').parse(toDateStr);
    if (kDebugMode) {
      print('sales filter --- > $fromDate -- $toDate');
    }
    // Subtract one day from fromDate
    fromDate = fromDate.subtract(const Duration(days: 1));

    // Add one day to toDate
    toDate = toDate.add(const Duration(days: 1));

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;

        final billCollectionRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(userEmail)
            .collection('Bills');

        final billSnapshot = await billCollectionRef.get();

        if (billSnapshot.docs.isNotEmpty) {
          for (var doc in billSnapshot.docs) {
            final billData = doc.data();
            final dateString = billData['date'];
            final dateParts = dateString.split('-');

            final year = int.parse(dateParts[2]);
            final month = int.parse(dateParts[1]);
            final day = int.parse(dateParts[0]);

            final date = DateTime(year, month, day);
            final formattedDate = DateFormat('dd-MM-yyyy').format(date);

            if (date.isAfter(fromDate) && date.isBefore(toDate)) {
              final totalAmount = billData['totalAmount'];
              final items = (billData['items'] as List<dynamic>)
                  .map((item) => forPosTicketDetail(
                        name: item['name'],
                        itemcount: item['itemcount'],
                        price: item['price'],
                      ))
                  .toList();

              final bill = FilterBill(
                id: doc.id,
                date: formattedDate,
                totalAmount: totalAmount,
                items: items,
              );

              filterBills.add(bill);
              showdata.value = true;
              update();
            }
          }

          for (var bill in filterBills) {
            if (kDebugMode) {
              print('Date: ${bill.date}, Total Amount: ${bill.totalAmount}');
            }
            for (var item in bill.items!) {
              if (kDebugMode) {
                print(
                    'Item: ${item.name}, Count: ${item.itemcount}, Price: ${item.price}');
              }
            }
          }
          double totalAmountOfAllBills = 0.0;

          for (var bill in filterBills) {
            double billTotalAmount = double.parse(bill.totalAmount!);
            totalAmountOfAllBills += billTotalAmount;
          }
          totalSalesAmount.value = totalAmountOfAllBills.toStringAsFixed(2);
          adjTotalSalesAmount.value = totalSalesAmount.value;
          if (kDebugMode) {
            print('Total Amount of All Bills: $totalAmountOfAllBills');
          }
          if (purchaseSelected.value) {
          } else {
            calculateTotalAmount();
          }
        } else {
          Fluttertoast.showToast(msg: 'No saved bill data found.');
          if (kDebugMode) {
            print('No saved bill data found.');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching saved bill data: $e');
      }
    }
  }

  void fetchPurchaseDataByDate() async {
    try {
      purchases.clear();
      showdata.value = false;
      update();
      String fromDateStr = fromdatetext.text.toString();
      String toDateStr = todatetext.text.toString();

      // Convert fromDateStr and toDateStr to DateTime objects
      DateTime fromDate = DateFormat('dd-MM-yyyy').parse(fromDateStr);
      DateTime toDate = DateFormat('dd-MM-yyyy').parse(toDateStr);
      if (kDebugMode) {
        print('purchase filter --- > $fromDate -- $toDate');
      }
      // Subtract one day from fromDate
      fromDate = fromDate.subtract(const Duration(days: 1));

      // Add one day to toDate
      toDate = toDate.add(const Duration(days: 1));

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;

        final userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (userSnapshot.size == 1) {
          final userDocId = userSnapshot.docs[0].id;

          final purchaseCollectionRef = FirebaseFirestore.instance
              .collection('Users')
              .doc(userDocId)
              .collection('Purchase');

          final purchaseSnapshot = await purchaseCollectionRef.get();

          if (purchaseSnapshot.docs.isNotEmpty) {
            for (var doc in purchaseSnapshot.docs) {
              final purchaseData = doc.data();

              final orderDateStr = purchaseData['orderDate'];
              final orderDate = DateFormat('dd-MM-yyyy').parse(orderDateStr);

              if (orderDate.isAfter(fromDate) && orderDate.isBefore(toDate)) {
                final vendorName = purchaseData['vendorName'];
                final amount = purchaseData['amount'];
                final taxPercentage = purchaseData['taxPercentage'];
                final taxAmount = purchaseData['taxAmount'];
                final totalAmount = purchaseData['totalAmount'];
                final payment = purchaseData['payment'];
                final pendingDate = purchaseData['pendingDate'];

                final purchase = FilterPurchaseModel(
                  id: doc.id,
                  vendorName: vendorName,
                  amount: amount,
                  taxPercentage: taxPercentage,
                  taxAmount: taxAmount,
                  totalAmount: totalAmount,
                  payment: payment,
                  orderDate: orderDateStr,
                  pendingDate: pendingDate,
                );

                purchases.add(purchase);
                showdata.value = true;
                update();
              }
            }

            double totalPayment = 0.0;

            for (var purchase in purchases) {
              double purchasePayment =
                  double.parse(purchase.totalAmount.toString());
              totalPayment += purchasePayment;
            }
            totalPurchaseAmount.value = totalPayment.toStringAsFixed(2);
            adjTotalPurchaseAmount.value = totalPurchaseAmount.value;
            if (kDebugMode) {
              print('Total Payment: $totalPayment');
            }
            calculateTotalAmount();
          } else {
            Fluttertoast.showToast(msg: 'No purchase data found.');
            if (kDebugMode) {
              print('No purchase data found.');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching purchase data: $e');
      }
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to fetch purchase data',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      );
    }
    update();
  }

  void calculateTotalAmount() {
    double purchaseAmount = double.tryParse(totalPurchaseAmount.value) ?? 0.0;
    double salesAmount = double.tryParse(totalSalesAmount.value) ?? 0.0;

    double totalValue = purchaseAmount + salesAmount;
    totalAmount.value = totalValue.toString();
    adjTotalAmount.value = totalAmount.value;

    if (kDebugMode) {
      print(totalAmount.value);
    }

    update();
  }

  void calculateAdjustedTotalAmount() {
    if (adjustmentPercentageText.text.isEmpty) {
      // If the adjustment percentage is empty, do nothing
      return;
    }

    double adjustmentPercentage =
        double.tryParse(adjustmentPercentageText.text) ?? 0;
    double salesAmount = double.tryParse(adjTotalSalesAmount.value) ?? 0;
    double purchaseAmount = double.tryParse(adjTotalPurchaseAmount.value) ?? 0;

    // Calculate the adjusted amounts
    double adjustedSalesAmount =
        salesAmount - (salesAmount * (adjustmentPercentage / 100));
    double adjustedPurchaseAmount =
        purchaseAmount - (purchaseAmount * (adjustmentPercentage / 100));
    double adjustedTotalAmount = adjustedSalesAmount + adjustedPurchaseAmount;

    // Update the totalSalesAmount, totalPurchaseAmount, and totalAmount
    adjTotalSalesAmount.value = adjustedSalesAmount.toStringAsFixed(2);
    adjTotalPurchaseAmount.value = adjustedPurchaseAmount.toStringAsFixed(2);
    adjTotalAmount.value = adjustedTotalAmount.toStringAsFixed(2);

    // Update the UI
    update();
  }

  void rollBack() {
    adjTotalSalesAmount.value = totalSalesAmount.value;
    adjTotalPurchaseAmount.value = totalPurchaseAmount.value;
    adjTotalAmount.value = totalAmount.value;

    if (kDebugMode) {
      print(filterBills.length);
      print(purchases.length);
    }
    update();
  }

  void updateTotalAmountByPercentage() {
    if (adjustmentPercentageText.text.isEmpty) {
      // If the adjustment percentage is empty, do nothing
      print('Adjustment percentage is empty. Exiting.');
      return;
    }

    double adjustmentPercentage =
        double.tryParse(adjustmentPercentageText.text) ?? 0;
    print('Adjustment Percentage: $adjustmentPercentage');

    // Update the totalAmount for each item in filterBills
    for (var bill in filterBills) {
      double billTotalAmount = double.parse(bill.totalAmount!);
      print('Bill Total Amount before adjustment: $billTotalAmount');
      double adjustedTotalAmount =
          billTotalAmount - (billTotalAmount * (adjustmentPercentage / 100));
      print('Adjusted Total Amount: $adjustedTotalAmount');
      bill.totalAmount = adjustedTotalAmount.toStringAsFixed(2);
      print('Bill Total Amount after adjustment: ${bill.totalAmount}');
    }
    calculateTotalAmountForBills();
    // Update the totalAmount for each item in purchases
    for (var purchase in purchases) {
      double purchaseTotalAmount =
          double.parse(purchase.totalAmount.toString());
      print('Purchase Total Amount before adjustment: $purchaseTotalAmount');
      double adjustedTotalAmount = purchaseTotalAmount -
          (purchaseTotalAmount * (adjustmentPercentage / 100));
      print('Adjusted Total Amount: $adjustedTotalAmount');
      purchase.totalAmount = adjustedTotalAmount.toStringAsFixed(2);
      print('Purchase Total Amount after adjustment: ${purchase.totalAmount}');
    }
    // Update the UI
    calculateTotalAmountForBills();
    calculateTotalAmountForPurchases();
  }

  void calculateTotalAmountForBills() {
    double totalAmountOfAllBills = 0.0;

    for (var bill in filterBills) {
      double billTotalAmount = double.parse(bill.totalAmount!);
      totalAmountOfAllBills += billTotalAmount;
      print('Adding Bill Total Amount: $billTotalAmount');
    }

    print(
        'After update Total Amount for Bills: ${totalAmountOfAllBills.toStringAsFixed(2)}');
  }

  void calculateTotalAmountForPurchases() {
    double totalPayment = 0.0;

    for (var purchase in purchases) {
      double purchasePayment = double.parse(purchase.totalAmount.toString());
      totalPayment += purchasePayment;
      print('Adding Purchase Total Amount: $purchasePayment');
    }

    print(
        'After update Total Amount for Purchases: ${totalPayment.toStringAsFixed(2)}');
  }

  void updateTotalAmountInFirebase() async {
    isloading.value = true;
    if (adjustmentPercentageText.text.isEmpty) {
      // If the adjustment percentage is empty, do nothing
      return;
    }

    double adjustmentPercentage =
        double.tryParse(adjustmentPercentageText.text) ?? 0;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userEmail = currentUser.email;

      if (saleSelected.value) {
        // Update the totalAmount for each item in filterBills
        for (var bill in filterBills) {
          double billTotalAmount = double.parse(bill.totalAmount!);
          double adjustedTotalAmount = billTotalAmount -
              (billTotalAmount * (adjustmentPercentage / 100));
          bill.totalAmount = adjustedTotalAmount.toStringAsFixed(2);

          try {
            final billCollectionRef = FirebaseFirestore.instance
                .collection('Users')
                .doc(userEmail)
                .collection('Bills');

            // Update the Firestore document with the new totalAmount
            await billCollectionRef.doc(bill.id).update({
              'totalAmount': bill.totalAmount,
            });
          } catch (e) {
            if (kDebugMode) {
              print('Error updating bill document: $e');
            }
            // Handle the error as needed
          }
        }
        calculateTotalAmountForBills();
      }

      if (purchaseSelected.value) {
        // Update the totalAmount for each item in purchases
        for (var purchase in purchases) {
          double purchaseTotalAmount =
              double.parse(purchase.totalAmount.toString());
          double adjustedTotalAmount = purchaseTotalAmount -
              (purchaseTotalAmount * (adjustmentPercentage / 100));
          purchase.totalAmount = adjustedTotalAmount.toStringAsFixed(2);

          try {
            final userSnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .where('email', isEqualTo: userEmail)
                .limit(1)
                .get();

            if (userSnapshot.size == 1) {
              final userDocId = userSnapshot.docs[0].id;

              final purchaseCollectionRef = FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userDocId)
                  .collection('Purchase');

              // Update the Firestore document with the new totalAmount
              await purchaseCollectionRef.doc(purchase.id).update({
                'totalAmount': purchase.totalAmount,
              });
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error updating purchase document: $e');
            }
            // Handle the error as needed
          }
        }
        calculateTotalAmountForPurchases();
      }
      isloading.value = false;
      Fluttertoast.showToast(msg: "Updated Successfully");
      Get.back();
      update();
    }
  }
}
