import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pesa_makanam_app/utils/constant.dart';

import '../Eventcapture/event_logger_controller.dart';
import '../Model/Homemodel.dart';
import '../View/Home/drawer/POS/RecieptScreen.dart';
import 'PosController.dart';

class HomeController extends GetxController {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User?> currentUser = Rx<User?>(null);
  var adminAccess = false.obs;
  var isloading = false.obs;
  List<String> categories = <String>[].obs;
  List<CategoryDetail> Detail = [];
  List<forPosTicketDetail> detailList = [];
  double totalAmount = 0;
  var istabscreenloading = false.obs;
  final EventLoggerController eventLoggerController =
      Get.find<EventLoggerController>();
  final PosController posController = Get.put(PosController());

  @override
  void onInit() {
    // Register EventLoggerController in the GetX service locator
    Get.put<EventLoggerController>(EventLoggerController());
    requestLocationPermission();
    eventLoggerController;
    // TODO: implement onInit
    getCurrentUser();
    fetchCategoriesFromFirestore();
    checkUserRole();
    super.onInit();
  }

  Future<void> checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('Users').doc(user.email);

      try {
        DocumentSnapshot userDoc = await userDocRef.get();
        if (userDoc.exists) {
          CollectionReference rolesCollectionRef =
          userDoc.reference.collection('roles');

          QuerySnapshot rolesQuerySnapshot = await rolesCollectionRef.get();
          if (rolesQuerySnapshot.docs.isNotEmpty) {
            // Loop through all the documents in the roles subcollection
            rolesQuerySnapshot.docs.forEach((rolesDoc) {
              // Assuming 'role' is the field containing the user's role in each document
              String role = rolesDoc.get('role');
              if(role == 'Admin'){
                adminAccess.value = rolesDoc.get('Admin access');
                print(adminAccess.value);
                print('User role: $role');
              }
            });
          } else {
            // Handle case where roles subcollection is empty
            print('No roles found for the user.');
          }
        } else {
          // Handle case where user document does not exist
          print('User document does not exist.');
        }
        update();
      } catch (e) {
        // Handle errors
        print('Error: $e');
      }
    } else {
      // Handle case where user is not authenticated
      Fluttertoast.showToast(msg: "Error");
    }
  }

  Future<void> printSampleReceipt(String paperSize) async {
    BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

    List<LineText> list = [];

    // Add restaurant information
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------RESTOREN AL-ASMI (24 JAM) ---------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            'Address: LOT 5 (DBKK NO.5-0) GROUND FLOOR,\nLORONG BUNGA RAJA 5,\nTAMAN BUNGA RAJAPHASE 2 \nJALAN LINTAS 88450 KOTA KINABALU',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    // Add more restaurant information lines...

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-------------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    // Add TAX INVOICE / BILL section
    // You can use the current date using DateTime.now() or replace it with your own date logic
    DateTime currentDate = DateTime.now();
    String formattedDate = currentDate.toString();
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'TAX INVOICE / BILL\nDate: $formattedDate',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    // Add Table and Server information...

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-------------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    // Add Item table header
    int columnWidth = 20; // Adjust this width as needed
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: _formatColumn('Item', columnWidth, LineText.ALIGN_LEFT) +
            _formatColumn('Quantity', 10, LineText.ALIGN_RIGHT) +
            _formatColumn('Unit Price', 12, LineText.ALIGN_RIGHT) +
            _formatColumn('Total', 9, LineText.ALIGN_RIGHT),
        align: LineText.ALIGN_LEFT,
        linefeed: 1));

    // Add item details dynamically
    for (var detail in detailList) {
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: _formatColumn(
                  detail.name!, columnWidth, LineText.ALIGN_LEFT) +
              _formatColumn(
                  detail.itemcount.toString(), 8, LineText.ALIGN_RIGHT) +
              _formatColumn(detail.price!, 10, LineText.ALIGN_RIGHT) +
              _formatColumn(
                  '${(double.parse(detail.price!) * detail.itemcount!).toString()} Rm',
                  14,
                  LineText.ALIGN_RIGHT),
          align: LineText.ALIGN_LEFT,
          linefeed: 0));
    }

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-------------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    // Add Subtotal, Tax, and Total
    // You can calculate these values based on your business logic
    double subtotal = 0;
    for (var detail in detailList) {
      subtotal += double.parse(detail.price!) * detail.itemcount!;
    }
    // double tax = subtotal * 0.05; // 5% tax example
    double total = subtotal;

    // list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: 'Subtotal:                              $subtotal',
    //     weight: 1,
    //     align: LineText.ALIGN_LEFT,
    //     linefeed: 1));
    // list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: 'Tax (%):                               5',
    //     weight: 1,
    //     align: LineText.ALIGN_LEFT,
    //     linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Total:                                      $total RM',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));

    // Add Payment Method
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Payment Method: Cash',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-------------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    // Add closing message
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            'Thank you for dining with us!\nFor feedback or inquiries, please contact [0109422163].',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    String terminalContent = '';
    for (var line in list) {
      terminalContent += ('${line.content!}\n');
    }
    if (kDebugMode) {
      print(terminalContent);
    }
    Map<String, dynamic> config = {
      'width': (paperSize == '80mm') ? 80 : 58,
      'height': 0,
    };
    Get.to(ReceiptScreen(terminalContent: terminalContent));
    //await bluetoothPrint.printReceipt(config, list);
  }

  Future<void> printReceipt(String paperSize, BuildContext context) async {
    var posController = Get.find<PosController>();
    posController.fromHomeSubmit();
    BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
    bool? isConnected = await bluetoothPrint.isConnected;
    if (!isConnected!) {
      // Show a dialog box to connect the printer
      showDialog(
        context:
            context, // You need to have access to the context for showDialog
        builder: (context) {
          return AlertDialog(
            title: Text('Connect Bluetooth Printer'),
            content: const Text(
                'Please connect a Bluetooth printer before printing the receipt.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the function since the printer is not connected
    }
    List<LineText> list = [];

    // Add restaurant information
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'RESTOREN AL-ASMI (24 JAM)------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            'Address: LOT 5 (DBKK NO.5-0) GROUND FLOOR,\nLORONG BUNGA RAJA 5,\nTAMAN BUNGA RAJAPHASE 2 \nJALAN LINTAS 88450 KOTA KINABALU',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    // Add more restaurant information lines...

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-------------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    // Add TAX INVOICE / BILL section
    // You can use the current date using DateTime.now() or replace it with your own date logic
    DateTime currentDate = DateTime.now();
    String formattedDate = currentDate.toString();
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'TAX INVOICE / BILL\nDate: $formattedDate',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    // Add Table and Server information...

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-------------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    // Add Item table header
    int columnWidth = 20; // Adjust this width as needed
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: _formatColumn('Item', columnWidth, LineText.ALIGN_LEFT) +
            _formatColumn('Quantity', 10, LineText.ALIGN_RIGHT) +
            _formatColumn('Unit Price', 12, LineText.ALIGN_RIGHT) +
            _formatColumn('Total', 9, LineText.ALIGN_RIGHT),
        align: LineText.ALIGN_LEFT,
        linefeed: 1));

    // Add item details dynamically
    for (var detail in detailList) {
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: _formatColumn(
                  detail.name!, columnWidth, LineText.ALIGN_LEFT) +
              _formatColumn(
                  detail.itemcount.toString(), 8, LineText.ALIGN_RIGHT) +
              _formatColumn(detail.price!, 10, LineText.ALIGN_RIGHT) +
              _formatColumn(
                  '${(double.parse(detail.price!) * detail.itemcount!).toString()} Rm',
                  14,
                  LineText.ALIGN_RIGHT),
          align: LineText.ALIGN_LEFT,
          linefeed: 0));
    }

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-------------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    // Add Subtotal, Tax, and Total
    // You can calculate these values based on your business logic
    double subtotal = 0;
    for (var detail in detailList) {
      subtotal += double.parse(detail.price!) * detail.itemcount!;
    }
    // double tax = subtotal * 0.05; // 5% tax example
    double total = subtotal;

    // list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: 'Subtotal:                              $subtotal',
    //     weight: 1,
    //     align: LineText.ALIGN_LEFT,
    //     linefeed: 1));
    // list.add(LineText(
    //     type: LineText.TYPE_TEXT,
    //     content: 'Tax (%):                               5',
    //     weight: 1,
    //     align: LineText.ALIGN_LEFT,
    //     linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Total:                                      $total RM',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));

    // Add Payment Method
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Payment Method: Cash',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-------------------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    // Add closing message
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content:
            'Thank you for dining with us!\nFor feedback or inquiries, please contact [0109422163].',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    String terminalContent = '';
    for (var line in list) {
      terminalContent += ('${line.content!}\n');
    }
    if (kDebugMode) {
      print(terminalContent);
    }
    Map<String, dynamic> config = {
      'width': (paperSize == '80mm') ? 80 : 58,
      'height': 0,
    };
    try {
      await bluetoothPrint.printReceipt(config, list);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Printing Error');
    } finally {
      Get.offAllNamed(ROUTE_HOME);
    }
  }

  //Function to format text within a column
  String _formatColumn(String text, int width, int alignment) {
    // Ensure text is not longer than the specified width
    if (text.length > width) {
      text = text.substring(0, width);
    }
    final spaces = width - text.length;
    if (alignment == LineText.ALIGN_RIGHT) {
      return ' ' * spaces + text;
    } else if (alignment == LineText.ALIGN_CENTER) {
      final leftSpaces = spaces ~/ 2;
      final rightSpaces = spaces - leftSpaces;
      return ' ' * leftSpaces + text + ' ' * rightSpaces;
    } else {
      return text + ' ' * spaces;
    }
  }

  //Function to format text within a column

  void addItem(forPosTicketDetail item) {
    int nameCount = detailList.where((e) => e.name == item.name).length;

    if (nameCount > 0) {
      // Check for duplicate names
      int index = detailList.indexWhere((e) => e.name == item.name);
      if (index != -1) {
        // Increment itemcount and update the name
        detailList[index].itemcount = detailList[index].itemcount! + 1;
        detailList[index].name = '${item.name}';
      }
    } else {
      // No duplicate name, add the item with itemcount 1
      forPosTicketDetail newItem = forPosTicketDetail(
        name: item.name,
        price: item.price,
        itemcount: 1, // Set the default itemcount to 1
      );
      detailList.add(newItem);
    }

    try {
      totalAmount += double.parse(item.price!);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    posController.detailList.value = detailList;

    // Print the current state (for debugging)
    if (kDebugMode) {
      printDetailList();
    }
  }

  void printDetailList() {
    detailList.forEach((item) {
      print('${item.name} -${item.itemcount} -${item.price}');
    });
    print('Total Amount: $totalAmount');
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
        // List<String> fetchedCategories = querySnapshot.docs
        //     .map(
        //         (doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
        //     .toList();
        // Filter out documents with null or missing names

        List<String> fetchedCategories = querySnapshot.docs
            .map((doc) =>
        (doc.data() as Map<String, dynamic>)['name'] as String?)
            .where((name) => name != null && name.isNotEmpty)
            .cast<String>() // Cast to String to remove nullable type
            .toList();

        if (fetchedCategories.isEmpty) {
          // Handle the case where no categories are fetched from Firestore
          Fluttertoast.showToast(msg: "No categories available");
          // You might want to set categories to a default value or handle this case based on your requirements
          categories.assignAll(['No Category Available']);
        } else {
          // Update the categories list with the fetched data
          categories.assignAll(fetchedCategories);
          if (kDebugMode) {
            print(categories[0]);
          }
          printCategoryDetails(categories[0]);
          if (kDebugMode) {
            print('Category list fetched from Firestore successfully!');
          }
          eventLoggerController.addLog('Home Controller : Category list fetched from Firestore successfully');
        }
      } catch (error) {
        Fluttertoast.showToast(msg: "No Data Available");
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
