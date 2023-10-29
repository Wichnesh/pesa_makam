import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pesa_makanam_app/utils/common_methods.dart';

import 'homeController.dart';

class CategoriesController extends GetxController {
  List<String> categories = <String>[].obs;

  final TextEditingController categoryNameController = TextEditingController();
  var isloading = false.obs;

  @override
  void onInit() {
    print('CategoriesController initialized');
    fetchCategoriesFromFirestore();
    super.onInit();
  }

  @override
  void dispose() {
    print('CategoriesController disposed');
    super.dispose();
  }

  void addCategories(List<String> newCategories) {
    categories.addAll(newCategories);
    update();
    print('Categories added: $newCategories');
  }

  Future<void> fetchCategoriesFromFirestore() async {
    print('Fetching categories from Firestore...');
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
    print('Deleting category: $categoryName');
    try {
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


        // Delete the category document and its sub-collection
        if (querySnapshot.docs.isNotEmpty) {
          var documentId = querySnapshot.docs.first.id; // Get the documentID

          // Delete the sub-collection inside the category document
          CollectionReference subCollectionReference =
          categoryCollection.doc(documentId).collection('categorydetail');
          QuerySnapshot subCollectionSnapshot = await subCollectionReference
              .get();
          if (subCollectionSnapshot.docs.isNotEmpty) {
            // Delete documents inside sub-collection
            for (QueryDocumentSnapshot subDocument in subCollectionSnapshot
                .docs) {
              await subDocument.reference.delete();
            }
          }
          // Delete the category document
          await categoryCollection.doc(documentId).delete();

          // Fetch updated categories from Firestore
          fetchCategoriesFromFirestore();
          HomeController homeController = Get.find<HomeController>();
          homeController.fetchCategoriesFromFirestore();

          // Delete the category document
          // if (querySnapshot.docs.isNotEmpty) {
          //   var documentId = querySnapshot.docs.first.id; // Get the documentID
          //   await categoryCollection.doc(documentId).delete(); // Delete the document by documentID
          //   fetchCategoriesFromFirestore();
          //   HomeController homeController = Get.find<HomeController>();
          //   homeController.fetchCategoriesFromFirestore();
          // } else {
          //   showToast('Category not found');
          //   fetchCategoriesFromFirestore();
          // }
        } else {
            showToast('Category not found');
            fetchCategoriesFromFirestore();
          }
      }
    } catch (error) {
      print('Error deleting category from Firestore: $error');
    }
  }

  Future<void> saveCategoriesToFirestore(String category) async {
    print('Saving categories to Firestore...');
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
        // await categoryCollection.get().then((snapshot) {
        //   for (DocumentSnapshot doc in snapshot.docs) {
        //     doc.reference.delete();
        //   }
        // });

        // Check if the category already exists in the collection

        QuerySnapshot duplicateCategories = await categoryCollection
            .where('name', isEqualTo: category)
            .get();

        // If there are no duplicate categories, save the new category
        if (duplicateCategories.docs.isEmpty) {
          await categoryCollection.add({'name': category});
          Fluttertoast.showToast(msg: 'Category saved to Firestore successfully!');
        } else {
          Fluttertoast.showToast(msg: 'Category already exists!');
        }

        isloading.value = false;
        Fluttertoast.showToast(msg: 'Category list saved to Firestore successfully!');
        fetchCategoriesFromFirestore();
        HomeController homeController = Get.find<HomeController>();
        homeController.Detail.clear();
        homeController.fetchCategoriesFromFirestore();
      } catch (error) {
        print('Error saving category list to Firestore: $error');
      }
      update();
    }
  }

}
