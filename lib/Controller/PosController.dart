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
  final RxList<String> tableIds = RxList<String>();
  var totalamount = "".obs;
  TextEditingController cash = TextEditingController();
  var balanceAmount = "".obs;
  var grandTotal = "".obs;
  var selectedTable = "".obs;
  final List<Bill> savedBills = [];
  final List<Bill> filterBills = [];
  DateTime? fromdate;
  DateTime? todate;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectedTable.value = "Select the Table";
    fetchTableDocumentIds();
  }

  double calculateTotalValue(forPosTicketDetail item) =>
      double.parse(item.price!) * item.itemcount!;

  double calculateTotalAmount() =>
      detailList.fold(0.0, (total, item) => total + calculateTotalValue(item));


  void increaseItemCount(forPosTicketDetail item) {
    if (item.itemcount != null && item.itemcount! < 999) {
      item.itemcount = item.itemcount! + 1;
    }
    update();
  }

  void checkBalance(){
    double totalBill = calculateTotalAmount();
    double balance = double.parse(cash.text) - totalBill;
    totalamount.value = totalBill.toStringAsFixed(2);
    balanceAmount.value = balance.toStringAsFixed(2);
  }

  void decreaseItemCount(forPosTicketDetail item) {
    if (item.itemcount != null && item.itemcount! > 0) {
      item.itemcount = item.itemcount! - 1;
    }
    update();
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
              "cash" : cash.text,
              "balance": balanceAmount.value,
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
              "cash" : cash.text,
              "balance": balanceAmount.value,
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
            clearTableData();
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

  Future<void> fetchSavedBillDataByDate() async {
    filterBills.clear();
    showdata.value = false;
    update();
    String fromDateStr = fromdatetext.text.toString();
    String toDateStr = todatetext.text.toString();

    // Convert fromDateStr and toDateStr to DateTime objects
    DateTime fromDate = DateFormat('dd-MM-yyyy').parse(fromDateStr);
    DateTime toDate = DateFormat('dd-MM-yyyy').parse(toDateStr);

    // Subtract one day from fromDate (without affecting time)
    DateTime fromDateStart = DateTime(fromDate.year, fromDate.month, fromDate.day);
    DateTime fromDateEnd = fromDateStart.subtract(const Duration(days: 1));

    // Add one day to toDate (without affecting time)
    DateTime toDateStart = DateTime(toDate.year, toDate.month, toDate.day);
    DateTime toDateEnd = toDateStart.add(const Duration(days: 1));

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

            if (date.isAfter(fromDateStart) && date.isBefore(toDateEnd)) {
              final formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
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
            double billTotalAmount = double.parse(bill.totalAmount!);
            totalAmountOfAllBills += billTotalAmount;
          }
          if (kDebugMode) {
            print('Total Amount of All Bills: $totalAmountOfAllBills');
          }
          grandTotal.value = totalAmountOfAllBills.toStringAsFixed(2);
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


  void fetchTableDocumentIds() async {
    // Get the current user
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if the user is authenticated
    if (currentUser != null) {
      // Get the email of the current user
      final userEmail = currentUser.email;

      // Reference to the 'tables' collection for the current user
      final billCollectionRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .collection('tables');

      try {
        // Check if the 'tables' collection exists
        final tablesCollection = await billCollectionRef.parent?.get();
        if (!tablesCollection!.exists) {
          // If the collection doesn't exist, create it
          await billCollectionRef.parent?.set({});
        }

        // Get the documents from the 'tables' collection
        final QuerySnapshot snapshot = await billCollectionRef.get();

        // Iterate through each document and add its ID to the RxList
        snapshot.docs.forEach((doc) {
          final tableId = doc.id;
          tableIds.add(tableId);
          print('Table Document ID: $tableId');
        });

        // Create new documents from Table1 to Table15 if they don't exist
        for (int i = 1; i <= 15; i++) {
          final tableDocId = 'Table $i'; // Modify this line
          final tableDocRef = billCollectionRef.doc(tableDocId);
          final tableDocSnapshot = await tableDocRef.get();
          if (!tableDocSnapshot.exists) {
            await tableDocRef.set({'some_field': 'some_value'});
            tableIds.add(tableDocId); // Add to RxList
            print('New document created with ID: $tableDocId');
          } else {
            print('Document with ID $tableDocId already exists');
          }
        }
        update();
      } catch (error) {
        // Handle any errors that may occur
        print('Error fetching tables: $error');
      }
    } else {
      // User is not authenticated
      print('User is not authenticated.');
    }
  }

  void submitWithoutTime() async {
    double totalBill = calculateTotalAmount();
    totalamount.value = totalBill.toStringAsFixed(2);
    isloading.value = true;
    update();
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userEmail = currentUser.email;

        // Check if there are items with non-zero counts
        final itemsWithItemCountMoreThanZero = detailList.where((item) => item.itemcount! > 0).toList();

        if (itemsWithItemCountMoreThanZero.isNotEmpty) {
          for (var item in itemsWithItemCountMoreThanZero) {
            if (kDebugMode) {
              print(
                  "Item name: ${item.name}, Item count: ${item.itemcount},Item price : ${item.price}");
              print('Total Amount :${totalamount.value}');
            }
          }
          final userSnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .where('email', isEqualTo: userEmail)
              .limit(1)
              .get();

          // Get the selected table ID
          final selectedTableId = selectedTable.value;

          // Check if the selected table ID is not null
          if (selectedTableId != null) {
            // Reference to the 'tables' collection
            final tableDocRef = FirebaseFirestore.instance.collection('Users').doc(userEmail).collection('tables').doc(selectedTableId);

            // Create a new Firestore document under the selected table
            final billData = {
              'totalAmount': totalamount.value,
              'items': itemsWithItemCountMoreThanZero
                  .map((item) => {
                'name': item.name,
                'itemcount': item.itemcount,
                'price': item.price,
              })
                  .toList(),
            };
            await tableDocRef.set(billData);
            detailList.clear();
            var homeController = Get.find<HomeController>();
            homeController.detailList.clear();
            update();
            selectedTable.value = "Select the Table";
            showToast('Ticket updated Successfully');
            Get.back();
          } else {
            // Handle the case where no table is selected
            if (kDebugMode) {
              print("No table selected");
            }
          }
        } else {
          if (kDebugMode) {
            print("No items with itemcount more than 0 found");
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

  void fetchTable() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userEmail = currentUser.email;
      final selectedTableId = selectedTable.value; // Assuming selectedTable is a Rx variable containing the table ID

      await fetchTableDataAndAddToDetailList();
    }
  }

  Future<void> fetchTableDataAndAddToDetailList() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      final userEmail = currentUser!.email;
      // Reference to the document in the 'tables' collection
      final tableDocRef = FirebaseFirestore.instance.collection('Users').doc(userEmail).collection('tables').doc(selectedTable.value);

      // Fetch the document snapshot
      final tableDocSnapshot = await tableDocRef.get();

      if (tableDocSnapshot.exists) {
        final tableData = tableDocSnapshot.data();
        detailList.clear();
        // Extract 'items' field from the document data
        final List<dynamic>? items = tableData?['items'];

        if (items != null) {
          // Clear existing data in detailList
          detailList.clear();

          // Iterate over the items and add them to detailList
          for (var itemData in items) {
            final String? name = itemData['name'];
            final int? itemCount = itemData['itemcount'];
            final String? price = itemData['price'];

            // Create a new instance of forPosTicketDetail and add it to detailList
            detailList.add(forPosTicketDetail(
              name: name,
              itemcount: itemCount,
              price: price,
            ));
          }
          update();
        }
      }else{
        print("object");
      }
    } catch (e) {
      // Handle errors
      print(e);
    }
  }

  Future<void> clearTableData() async {

    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      final userEmail = currentUser!.email;
      // Reference to the document in the 'tables' collection
      final tableDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .collection('tables')
          .doc(selectedTable.value);

      // Get the document snapshot to access its data
      final tableDocSnapshot = await tableDocRef.get();

      // Check if the document exists
      if (tableDocSnapshot.exists) {
        // Get the data fields of the document
        final data = tableDocSnapshot.data();

        // Clear all fields of the document
        data?.forEach((key, value) {
          tableDocRef.update({key: FieldValue.delete()});
        });
        fetchTableDataAndAddToDetailList();
        Fluttertoast.showToast(msg: 'Table data cleared successfully');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Failed to clear table data: $e');
    }
  }

}
