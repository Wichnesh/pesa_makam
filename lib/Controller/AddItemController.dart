import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/common_methods.dart';

class AddItemsController extends GetxController {
  File? _image;
  final ImagePicker picker = ImagePicker();
  final TextEditingController fileNameText = TextEditingController();
  List<String> categories = <String>[].obs;
  var selectedcategory = "Select a category".obs;
  var fileName = "".obs;
  var isError = false.obs;
  RxString name = ''.obs;
  RxString description = ''.obs;
  RxString price = ''.obs;
  var isloading = false.obs;
  File? get image => _image;

  void onInit() {
    // TODO: implement onInit
    fetchCategoriesFromFirestore();
    super.onInit();
  }

  updateSelectedcategory(val) {
    selectedcategory.value = val;
    update();
  }

  Future getImage(ImageSource source) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: source, imageQuality: 50);

      if (pickedFile != null) {
        _image = File(pickedFile.path);
        fileName.value = pickedFile.path.split('/').last;
        print(".........................//////// ${fileName.value}");
        update();
        // apiGetList(result);
        Future.delayed(Duration(seconds: 1), () {
          // print(isRun);
          // print(resp);
        });
      } else {
        print('No image selected.');
        isError.value = true;
      }
    } catch (e) {
      print(' Image Error ${e}.');
      isError.value = true;
    }
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

  void submitData() async {
    try {
      if (selectedcategory.value == 'Select a category') {
        // Display error dialog if category is not selected
        Get.dialog(
          AlertDialog(
            title: Text('Incorrect'),
            content: Text('Please fill in all fields.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      } else {
        isloading.value = true; // Show loading indicator
        update();

        String? userEmail = FirebaseAuth.instance.currentUser?.email;
        if (userEmail != null) {
          // Get the Firestore reference to the user's collection
          DocumentReference userDocRef =
              FirebaseFirestore.instance.collection('Users').doc(userEmail);

          // Get the category collection reference
          CollectionReference categoryCollection =
              userDocRef.collection('categories');

          // Check if the selected category exists in Firestore
          QuerySnapshot categorySnapshot = await categoryCollection
              .where('name', isEqualTo: selectedcategory.value)
              .get();

          if (categorySnapshot.docs.isNotEmpty) {
            DocumentSnapshot categoryDoc = categorySnapshot.docs.first;

            // Get the category ID
            String categoryId = categoryDoc.id;

            // Create a new document in the 'categorydetail' collection
            CollectionReference categoryDetailCollection =
                categoryDoc.reference.collection('categorydetail');

            // Generate a new document ID
            DocumentReference newCategoryDetailDoc =
                categoryDetailCollection.doc();

            // Create a data map with the item details
            Map<String, dynamic> itemData = {
              'name': name.value,
              'description': description.value,
              'price': price.value,
              // Add any other fields you want to save
            };

            // Upload the image file to Firebase Storage
            String imageFileName =
                newCategoryDetailDoc.id + '.jpg'; // Use a unique file name
            Reference storageRef = FirebaseStorage.instance
                .ref()
                .child('productimages/$imageFileName');
            UploadTask uploadTask = storageRef.putFile(image!);
            TaskSnapshot uploadSnapshot = await uploadTask;

            if (uploadSnapshot.state == TaskState.success) {
              // Get the download URL of the uploaded image
              String imageUrl = await storageRef.getDownloadURL();

              // Add the image URL to the item data
              itemData['image'] = imageUrl;

              // Save the item data to Firestore
              await newCategoryDetailDoc.set(itemData);

              isloading.value = false; // Hide loading indicator
              showToast('Item added successfully');
              print('Item added to Firestore successfully!');
              Get.back();
            } else {
              isloading.value = false; // Hide loading indicator
              showToast('Failed to upload image');
              print('Failed to upload image to Firebase Storage');
            }
          } else {
            isloading.value = false; // Hide loading indicator
            showToast('Selected category does not exist');
            print('Selected category does not exist in Firestore');
          }
        }
      }
    } catch (error) {
      isloading.value = false; // Hide loading indicator
      Get.snackbar(
        'Error',
        'An error occurred while adding the item',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      print('Error adding item to Firestore: $error');
    }
    update();
  }
}
