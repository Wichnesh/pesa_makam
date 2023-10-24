import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/utils/common_methods.dart';

import 'homeController.dart';

class CategoriesController extends GetxController {
  List<String> categories = <String>[].obs;

  final TextEditingController categoryNameController = TextEditingController();
  var isloading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchCategoriesFromFirestore();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void addCategories(List<String> newCategories) {
    categories.addAll(newCategories);
    update();
  }

  Future<void> fetchCategoriesFromFirestore() async {
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
        List<String> fetchedCategories = querySnapshot.docs
            .map(
                (doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
            .toList();

        categories.assignAll(fetchedCategories);

        isloading.value = false; // Set loading flag to false
        showToast('category list available');
        print('Category list fetched from Firestore successfully!');
      } catch (error) {
        Get.snackbar("Error", "Error Occurred....!",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP);
        print('Error fetching category list from Firestore: $error');

        isloading.value = false;
      }
      update();
    }
  }

  Future<void> deleteCategory(String categoryName) async {
    try {
      print('delete category started');
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail != null) {
        // Get the Firestore reference to the user's collection
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('Users').doc(userEmail);

        // Get the category collection reference
        CollectionReference categoryCollection =
            userDocRef.collection('categories');

        // Query the category document to delete
        QuerySnapshot querySnapshot = await categoryCollection
            .where('name', isEqualTo: categoryName)
            .get();

        // Delete the category document
        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.delete();
          fetchCategoriesFromFirestore();
          HomeController homeController = Get.find<HomeController>();
          homeController.fetchCategoriesFromFirestore();
        } else {
          showToast('Category not found');
          fetchCategoriesFromFirestore();
        }
      }
    } catch (error) {
      print('Error deleting category from Firestore: $error');
    }
  }

  Future<void> saveCategoriesToFirestore(List<String> categoryList) async {
    isloading.value = true;
    update();
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail != null) {
      try {
        // Validate the current user's email

        // Get the Firestore reference to the user's collection
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('Users').doc(userEmail);

        // Create the category collection if it doesn't exist
        DocumentSnapshot userSnapshot = await userDocRef.get();
        if (!userSnapshot.exists) {
          await userDocRef.set({});
        }

        // Get the category collection reference
        CollectionReference categoryCollection =
            userDocRef.collection('categories');

        // Clear the existing categories in the collection
        await categoryCollection.get().then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Save the new category list to the Firestore collection
        for (String category in categoryList) {
          await categoryCollection.add({'name': category});
        }
        isloading.value = false;
        print('Category list saved to Firestore successfully!');
        HomeController homeController = Get.find<HomeController>();
        homeController.fetchCategoriesFromFirestore();
      } catch (error) {
        print('Error saving category list to Firestore: $error');
      }
      update();
    }
  }
}
