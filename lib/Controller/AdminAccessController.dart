import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/utils/constant.dart';

import 'homeController.dart';

class AdminAccessController extends GetxController {
 RxString userRole = ''.obs;
 var elevatedButtonText = "Access";
 var adminAccess = false.obs;
 var password = "".obs;

 @override
 void onInit() {
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
        password.value = rolesDoc.get('password');
        if (kDebugMode) {
          print(adminAccess.value);
          print(password.value);
        }
        if (kDebugMode) {
          print('User role: $role');
        }
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
    userRole.value = 'Unknown';
   }
  } else {
   // Handle case where user is not authenticated
   userRole.value = 'NotAuthenticated';
  }
 }

 Future<void> updateAdminAccess() async {
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
      rolesQuerySnapshot.docs.forEach((rolesDoc) async {
       String role = rolesDoc.get('role');
       if (role == 'Admin') {
        // Update the 'Admin access' field in the roles document
        rolesDoc.reference.update({'Admin access': !adminAccess.value});
        if(!adminAccess.value){
         Fluttertoast.showToast(msg: 'Admin access Granted successfully.');
        }else{
         Fluttertoast.showToast(msg: 'Admin access Revoked successfully.');
        }
        HomeController homeController = Get.find<HomeController>();
        homeController.checkUserRole();
        Get.offAllNamed(ROUTE_HOME);
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
   } catch (e) {
    // Handle errors
    print('Error: $e');
   }
  } else {
   // Handle case where user is not authenticated
   print('User is not authenticated.');
  }
 }

}
