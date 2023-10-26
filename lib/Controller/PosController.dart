import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesa_makanam_app/utils/constant.dart';
import '../Model/Homemodel.dart';
import '../utils/common_methods.dart';
import 'homeController.dart';

class PosController extends GetxController {
  var isloading = false.obs;
  var showdata = false.obs;
  TextEditingController quantitytext = TextEditingController();
  TextEditingController fromdatetext = TextEditingController();
  TextEditingController todatetext = TextEditingController();
  RxList<forPosTicketDetail> detailList = RxList<forPosTicketDetail>();
  var totalamount = "".obs;
  final List<Bill> savedBills = [];
  final List<Bill> filterBills = [];
  DateTime? fromdate;
  DateTime? todate;

  double calculateTotalValue(forPosTicketDetail item) {
    return double.parse(item.price!) * item.itemcount!;
  }

  double calculateTotalAmount() {
    double totalAmount = 0;
    for (var item in detailList) {
      totalAmount += calculateTotalValue(item);
    }
    return totalAmount;
  }

  void increaseItemCount(forPosTicketDetail item) {
    if (item.itemcount != null) {
      if (item.itemcount! < 999) {
        item.itemcount = item.itemcount! + 1;
      }
    }
  }

  void decreaseItemCount(forPosTicketDetail item) {
    if (item.itemcount != null) {
      if (item.itemcount! > 0) {
        item.itemcount = item.itemcount! - 1;
      }
    }
  }

  void updateTotalValue(forPosTicketDetail item) {
    final totalValue = double.parse(item.price!) * item.itemcount!;
    // item.totalValue = totalValue;
  }

  void clear() {
    detailList.clear();
    var homeController = Get.find<HomeController>();
    homeController.detailList.clear();
    update();
  }

  void Submit() async {
    isloading.value = true;
    update();
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        List<forPosTicketDetail> itemsWithItemCountMoreThanZero = [];
        final userEmail = currentUser.email;
        bool itemCountZeroFound = false;
        bool itemCountMoreThanZeroFound = false;

        for (var item in detailList) {
          if (item.itemcount == 0) {
            itemCountZeroFound = true;
          } else {
            itemCountMoreThanZeroFound = true;
          }
        }
        if (itemCountZeroFound && itemCountMoreThanZeroFound) {
          for (var item in detailList) {
            if (item.itemcount! > 0) {
              itemsWithItemCountMoreThanZero.add(item);
            }
          }
          if (itemsWithItemCountMoreThanZero.isNotEmpty) {
            // Here, you can print or perform actions with itemsWithItemCountMoreThanZero
            // For example:
            for (var item in itemsWithItemCountMoreThanZero) {
              if (kDebugMode) {
                print(
                    "Item name: ${item.name}, Item count: ${item.itemcount},Item price : ${item.price}");
                print('Total Amount :${totalamount.value}');
              }
            }
            // Check if the user already exists in the Users collection
            final userSnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .where('email', isEqualTo: userEmail)
                .limit(1)
                .get();
            final currentDate = DateTime.now();
            final formattedDate =
                "${currentDate.day}-${currentDate.month}-${currentDate.year}-${currentDate.hour}-${currentDate.minute}-${currentDate.second}";

            // Check if the Bill collection exists, and if not, create it
            final billCollectionRef =
                FirebaseFirestore.instance.collection('Users');
            final billCollectionExists = await billCollectionRef.limit(1).get();
            if (billCollectionExists.docs.isEmpty) {
              await billCollectionRef.doc('dummy').set({'created': true});
            }

            // Create a new Firestore document with a unique document ID based on the current date and time
            final billData = {
              'date': formattedDate,
              'totalAmount': totalamount.value,
              'items': itemsWithItemCountMoreThanZero
                  .map((item) => {
                        'name': item.name,
                        'itemcount': item.itemcount,
                        'price': item.price,
                      })
                  .toList(),
            };
            await billCollectionRef
                .doc(userEmail)
                .collection('Bills')
                .doc(
                    formattedDate) // Use the formatted date and time as the document ID
                .set(billData);
            detailList.clear();
            var homeController = Get.find<HomeController>();
            homeController.detailList.clear();
            update();
            showToast('Ticket saved Successfully');
            Get.back();
          } else {
            if (kDebugMode) {
              print("No items with itemcount more than 0 found");
            }
          }
          if (kDebugMode) {
            print("Some items have itemcount = 0 and some have itemcount > 0");
          }
        } else if (itemCountZeroFound) {
          detailList.clear();
          var homeController = Get.find<HomeController>();
          homeController.detailList.clear();
          showToast('Select item to Save');
          Get.back();
          if (kDebugMode) {
            print("itemcount is not available for the entire list");
          }
        } else if (itemCountMoreThanZeroFound) {
          for (var item in detailList) {
            if (item.itemcount! > 0) {
              itemsWithItemCountMoreThanZero.add(item);
            }
          }
          if (itemsWithItemCountMoreThanZero.isNotEmpty) {
            // Here, you can print or perform actions with itemsWithItemCountMoreThanZero
            // For example:
            for (var item in itemsWithItemCountMoreThanZero) {
              if (kDebugMode) {
                print(
                    "Item name: ${item.name}, Item count: ${item.itemcount},Item price : ${item.price}");
                print('Total Amount :${totalamount.value}');
              }
            }
            // Check if the user already exists in the Users collection
            final userSnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .where('email', isEqualTo: userEmail)
                .limit(1)
                .get();
            final currentDate = DateTime.now();
            final formattedDate =
                "${currentDate.day}-${currentDate.month}-${currentDate.year}-${currentDate.hour}-${currentDate.minute}-${currentDate.second}";

            // Check if the Bill collection exists, and if not, create it
            final billCollectionRef =
                FirebaseFirestore.instance.collection('Users');
            final billCollectionExists = await billCollectionRef.limit(1).get();
            if (billCollectionExists.docs.isEmpty) {
              await billCollectionRef.doc('dummy').set({'created': true});
            }

            // Create a new Firestore document with a unique document ID based on the current date and time
            final billData = {
              'date': formattedDate,
              'totalAmount': totalamount.value,
              'items': itemsWithItemCountMoreThanZero
                  .map((item) => {
                        'name': item.name,
                        'itemcount': item.itemcount,
                        'price': item.price,
                      })
                  .toList(),
            };
            await billCollectionRef
                .doc(userEmail)
                .collection('Bills')
                .doc(
                    formattedDate) // Use the formatted date and time as the document ID
                .set(billData);
            detailList.clear();
            var homeController = Get.find<HomeController>();
            homeController.detailList.clear();
            update();
            showToast('Ticket saved Successfully');
            Get.back();
          } else {
            if (kDebugMode) {
              print("No items with itemcount more than 0 found");
            }
          }
          if (kDebugMode) {
            print("itemcount more than 0 is available for at least one item");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    isloading.value = false;
    update();
  }

  void fromHomeSubmit() async {
    isloading.value = true;
    update();
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        List<forPosTicketDetail> itemsWithItemCountMoreThanZero = [];
        final userEmail = currentUser.email;
        bool itemCountZeroFound = false;
        bool itemCountMoreThanZeroFound = false;

        for (var item in detailList) {
          if (item.itemcount == 0) {
            itemCountZeroFound = true;
          } else {
            itemCountMoreThanZeroFound = true;
          }
        }
        if (itemCountZeroFound && itemCountMoreThanZeroFound) {
          for (var item in detailList) {
            if (item.itemcount! > 0) {
              itemsWithItemCountMoreThanZero.add(item);
            }
          }
          if (itemsWithItemCountMoreThanZero.isNotEmpty) {
            // Here, you can print or perform actions with itemsWithItemCountMoreThanZero
            // For example:
            for (var item in itemsWithItemCountMoreThanZero) {
              if (kDebugMode) {
                print(
                    "Item name: ${item.name}, Item count: ${item.itemcount},Item price : ${item.price}");
                print('Total Amount :${totalamount.value}');
              }
            }
            // Check if the user already exists in the Users collection
            final userSnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .where('email', isEqualTo: userEmail)
                .limit(1)
                .get();
            final currentDate = DateTime.now();
            final formattedDate =
                "${currentDate.day}-${currentDate.month}-${currentDate.year}-${currentDate.hour}-${currentDate.minute}-${currentDate.second}";

            // Check if the Bill collection exists, and if not, create it
            final billCollectionRef =
                FirebaseFirestore.instance.collection('Users');
            final billCollectionExists = await billCollectionRef.limit(1).get();
            if (billCollectionExists.docs.isEmpty) {
              await billCollectionRef.doc('dummy').set({'created': true});
            }

            // Create a new Firestore document with a unique document ID based on the current date and time
            final billData = {
              'date': formattedDate,
              'totalAmount': totalamount.value,
              'items': itemsWithItemCountMoreThanZero
                  .map((item) => {
                        'name': item.name,
                        'itemcount': item.itemcount,
                        'price': item.price,
                      })
                  .toList(),
            };
            await billCollectionRef
                .doc(userEmail)
                .collection('Bills')
                .doc(
                    formattedDate) // Use the formatted date and time as the document ID
                .set(billData);
            detailList.clear();
            var homeController = Get.find<HomeController>();
            homeController.detailList.clear();
            update();
            showToast('Ticket saved Successfully');
          } else {
            if (kDebugMode) {
              print("No items with itemcount more than 0 found");
            }
          }
          if (kDebugMode) {
            print("Some items have itemcount = 0 and some have itemcount > 0");
          }
        } else if (itemCountZeroFound) {
          detailList.clear();
          var homeController = Get.find<HomeController>();
          homeController.detailList.clear();
          showToast('Select item to Save');
          Get.back();
          if (kDebugMode) {
            print("itemcount is not available for the entire list");
          }
        } else if (itemCountMoreThanZeroFound) {
          for (var item in detailList) {
            if (item.itemcount! > 0) {
              itemsWithItemCountMoreThanZero.add(item);
            }
          }
          if (itemsWithItemCountMoreThanZero.isNotEmpty) {
            // Here, you can print or perform actions with itemsWithItemCountMoreThanZero
            // For example:
            for (var item in itemsWithItemCountMoreThanZero) {
              if (kDebugMode) {
                print(
                    "Item name: ${item.name}, Item count: ${item.itemcount},Item price : ${item.price}");
                print('Total Amount :${totalamount.value}');
              }
            }
            // Check if the user already exists in the Users collection
            final userSnapshot = await FirebaseFirestore.instance
                .collection('Users')
                .where('email', isEqualTo: userEmail)
                .limit(1)
                .get();
            final currentDate = DateTime.now();
            final formattedDate =
                "${currentDate.day}-${currentDate.month}-${currentDate.year}-${currentDate.hour}-${currentDate.minute}-${currentDate.second}";

            // Check if the Bill collection exists, and if not, create it
            final billCollectionRef =
                FirebaseFirestore.instance.collection('Users');
            final billCollectionExists = await billCollectionRef.limit(1).get();
            if (billCollectionExists.docs.isEmpty) {
              await billCollectionRef.doc('dummy').set({'created': true});
            }

            // Create a new Firestore document with a unique document ID based on the current date and time
            final billData = {
              'date': formattedDate,
              'totalAmount': totalamount.value,
              'items': itemsWithItemCountMoreThanZero
                  .map((item) => {
                        'name': item.name,
                        'itemcount': item.itemcount,
                        'price': item.price,
                      })
                  .toList(),
            };
            await billCollectionRef
                .doc(userEmail)
                .collection('Bills')
                .doc(
                    formattedDate) // Use the formatted date and time as the document ID
                .set(billData);
            detailList.clear();
            var homeController = Get.find<HomeController>();
            homeController.detailList.clear();
            update();
            showToast('Ticket saved Successfully');
            Get.back();
          } else {
            if (kDebugMode) {
              print("No items with itemcount more than 0 found");
            }
          }
          if (kDebugMode) {
            print("itemcount more than 0 is available for at least one item");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    isloading.value = false;
    update();
  }

  Future<void> fetchSavedBillData() async {
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
          savedBills.clear(); // Clear the existing list before adding new data
          for (var doc in billSnapshot.docs) {
            final billData = doc.data() as Map<String, dynamic>;
            final date = billData['date'];
            final totalAmount = billData['totalAmount'];
            final items = (billData['items'] as List<dynamic>)
                .map((item) => forPosTicketDetail(
                      name: item['name'],
                      itemcount: item['itemcount'],
                      price: item['price'],
                    ))
                .toList();

            final bill = Bill(
              date: date,
              totalAmount: totalAmount,
              items: items,
            );

            savedBills.add(bill);
          }

          // Print the retrieved data
          for (var bill in savedBills) {
            print('Date: ${bill.date}, Total Amount: ${bill.totalAmount}');
            for (var item in bill.items) {
              print(
                  'Item: ${item.name}, Count: ${item.itemcount}, Price: ${item.price}');
            }
          }
          try {
            print('Value of ROUTE_TICKETLIST: $ROUTE_TICKETLIST');
            Get.toNamed(ROUTE_TICKETLIST);
          } catch (e) {
            print(e);
          }
        } else {
          print('No saved bill data found.');
        }
      }
    } catch (e) {
      print('Error fetching saved bill data: $e');
    }
  }

  Future<void> fetchSavedBillDatabydate() async {
    filterBills.clear();
    showdata.value = false;
    update();
    String fromDateStr = fromdatetext.text.toString();
    String toDateStr = todatetext.text.toString();

    // Convert fromDateStr and toDateStr to DateTime objects
    DateTime fromDate = DateFormat('dd-MM-yyyy').parse(fromDateStr);
    DateTime toDate = DateFormat('dd-MM-yyyy').parse(toDateStr);

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
            final billData = doc.data() as Map<String, dynamic>;
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

              final bill = Bill(
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
            for (var item in bill.items) {
              print(
                  'Item: ${item.name}, Count: ${item.itemcount}, Price: ${item.price}');
            }
          }
          double totalAmountOfAllBills = 0.0;

          for (var bill in filterBills) {
            double billTotalAmount = double.parse(bill.totalAmount);
            totalAmountOfAllBills += billTotalAmount;
          }
          if (kDebugMode) {
            print('Total Amount of All Bills: $totalAmountOfAllBills');
          }
        } else {
          Fluttertoast.showToast(msg: 'No saved bill data found.');
          if (kDebugMode) {
            print('No saved bill data found.');
          }
        }
      }
    } catch (e) {
      print('Error fetching saved bill data: $e');
    }
  }
}
