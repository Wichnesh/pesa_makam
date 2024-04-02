import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesa_makanam_app/utils/GlobalConst.dart';

import '../Model/Homemodel.dart';

class TicketDetailController extends GetxController {
  var date = "".obs;
  var isLoading = false.obs;
  var grandTotalAmount = "".obs;
  var bill = List<Bill>.empty(growable: true).obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (kDebugMode) {
      print(GlobalConstant.uniqueDate);
    }
    DateTime targetDateTime = parseDateTimeFromString(GlobalConstant.uniqueDate);
    await fetchSpecificBill(targetDateTime);
  }

  void updateBill() async{
    DateTime targetDateTime = parseDateTimeFromString(GlobalConstant.uniqueDate);
    await updateSpecificBill(targetDateTime, bill[0]);
  }

  // Method to parse the string into DateTime
  DateTime parseDateTimeFromString(String dateTimeString) {
    List<String> dateTimeParts = dateTimeString.split('-');
    int day = int.parse(dateTimeParts[0]);
    int month = int.parse(dateTimeParts[1]);
    int year = int.parse(dateTimeParts[2]);
    int hour = int.parse(dateTimeParts[3]);
    int minute = int.parse(dateTimeParts[4]);
    int second = int.parse(dateTimeParts[5]);

    return DateTime(year, month, day, hour, minute, second);
  }


  // Method to update item count
  void updateItemCount(int itemIndex, String value) {
    // Parse the value to integer
    final count = int.tryParse(value);

    if (count != null) {
      // Update the item count at the specified index
      bill[0].items[itemIndex].itemcount = count;

      // Notify observers about the change
      bill.refresh();
    }
  }

  Future<void> fetchSpecificBill(DateTime targetDateTime) async {
    isLoading.value = true;
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
            final billData = doc.data() as Map<String, dynamic>;
            final dateString = billData['date'];
            final dateParts = dateString.split('-');

            final day = int.parse(dateParts[0]);
            final month = int.parse(dateParts[1]);
            final year = int.parse(dateParts[2]);
            final hour = int.parse(dateParts[3]);
            final minute = int.parse(dateParts[4]);
            final second = int.parse(dateParts[5]);

            final date = DateTime(year, month, day, hour, minute, second);

            // Compare with targetDateTime
            if (date == targetDateTime) {
              final formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
              final totalAmount = billData['totalAmount'];
              final items = (billData['items'] as List<dynamic>)
                  .map((item) => forPosTicketDetail(
                name: item['name'],
                itemcount: item['itemcount'],
                price: item['price'],
              ))
                  .toList();

             final data =  Bill(
                date: formattedDate,
                totalAmount: totalAmount,
                items: items,
              );
              bill.add(data);
              // Handle the fetched bill as needed
              print('Bill found for $formattedDate');
              print('Total Amount: $totalAmount');
              grandTotalAmount.value = totalAmount;
              for (var item in items) {
                print('Item: ${item.name}, Count: ${item.itemcount}, Price: ${item.price}');
              }
              isLoading.value = false;
              return;
            }
          }
          // If no bill found for the specified date
          print('No bill found for ${DateFormat('dd-MM-yyyy HH:mm:ss').format(targetDateTime)}');
          isLoading.value = false;
        } else {
          Fluttertoast.showToast(msg: 'No saved bill data found.');
          if (kDebugMode) {
            print('No saved bill data found.');
          }
          isLoading.value = false;
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      if (kDebugMode) {
        print('Error fetching saved bill data: $e');
      }
      isLoading.value = false;
    }
  }

  Future<void> updateSpecificBill(DateTime targetDateTime, Bill updatedBill) async {
    isLoading.value = true;
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
            final billData = doc.data() as Map<String, dynamic>;
            final dateString = billData['date'];
            final dateParts = dateString.split('-');

            final day = int.parse(dateParts[0]);
            final month = int.parse(dateParts[1]);
            final year = int.parse(dateParts[2]);
            final hour = int.parse(dateParts[3]);
            final minute = int.parse(dateParts[4]);
            final second = int.parse(dateParts[5]);

            final date = DateTime(year, month, day, hour, minute, second);

            // Compare with targetDateTime
            if (date == targetDateTime) {
              final docId = doc.id;

              final formattedDate = DateFormat('dd-MM-yyyy-HH-mm-ss').format(date);
              final totalAmount = updatedBill.totalAmount;
              final items = updatedBill.items.map((item) => {
                'name': item.name,
                'itemcount': item.itemcount,
                'price': item.price,
              }).toList();

              final data = {
                'date': formattedDate,
                'totalAmount': totalAmount,
                'items': items,
              };

              await billCollectionRef.doc(docId).set(data);
              // Handle the updated bill as needed
              print('Bill updated for $formattedDate');
              print('Updated Total Amount: $totalAmount');
              for (var item in items) {
                print('Updated Item: ${item['name']}, Count: ${item['itemcount']}, Price: ${item['price']}');
              }
              isLoading.value = false;
              return;
            }
          }
          // If no bill found for the specified date
          print('No bill found for ${DateFormat('dd-MM-yyyy HH:mm:ss').format(targetDateTime)}');
          isLoading.value = false;
        } else {
          Fluttertoast.showToast(msg: 'No saved bill data found.');
          if (kDebugMode) {
            print('No saved bill data found.');
          }
          isLoading.value = false;
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      if (kDebugMode) {
        print('Error updating bill data: $e');
      }
      isLoading.value = false;
    }
  }



}