import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../utils/common_methods.dart';

class EmployeeController extends GetxController {
  var image = Rx<File?>(null);
  RxString fileName = ''.obs;
  RxBool isError = false.obs;
  var isloading = false.obs;

  List<String> sex = [
    'Select',
    'Male',
    'Female',
    'Other',
  ];
  var sexTypeErrorText = "".obs;
  var selectedSex = "Select".obs;
  DateTime? DOB;
  DateTime? DOJ;
  DateTime? Expiry;
  var DOJText = "".obs;
  var DOBText = "".obs;
  var expiryText = "".obs;
  var name = "".obs;
  var employeeId = "".obs;
  var age = "".obs;
  var nationality = "".obs;
  var permanentaddress = "".obs;
  var presentaddress = "".obs;
  var phonenumber = "".obs;
  var alternatephonenumber = "".obs;
  var emergencycontactname = "".obs;
  var emergencycontactnumber = "".obs;
  var passportno = "".obs;
  var governmentid = "".obs;
  var roles = "".obs;
  var perdaywages = "".obs;
  final TextEditingController DOBTextField = TextEditingController();
  final TextEditingController DOJTextField = TextEditingController();
  final TextEditingController expiryTextField = TextEditingController();
  //
  File? passportimage;
  var passportName = "".obs;
  final TextEditingController passportNameText = TextEditingController();
  //
  File? governmentidimage;
  var governmentidName = "".obs;
  final TextEditingController governmentidNameText = TextEditingController();
  //
  File? addressproofimage;
  var addressproofName = "".obs;
  final TextEditingController addressNameText = TextEditingController(); //
  void updateSex(newSex) {
    selectedSex.value = newSex;
  }

  void validateSexType() {
    if (selectedSex.value == 'Select') {
      sexTypeErrorText.value = "please ";
      showToast('Select sex');
    } else {
      sexTypeErrorText.value = "";
    }
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: source, imageQuality: 50);

      if (pickedFile != null) {
        image.value = File(pickedFile.path);
        fileName.value = pickedFile.path.split('/').last;
        print(".........................//////// ${fileName.value}");
        update();
        // Perform any additional actions with the selected image
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

  Future<void> passportImage(ImageSource source) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: source, imageQuality: 50);

      if (pickedFile != null) {
        passportimage = File(pickedFile.path);
        passportName.value = pickedFile.path.split('/').last;
        print(".........................//////// ${passportName.value}");
        update();
        // Perform any additional actions with the selected image
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

  Future<void> GovernmentIdImage(ImageSource source) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: source, imageQuality: 50);

      if (pickedFile != null) {
        governmentidimage = File(pickedFile.path);
        governmentidName.value = pickedFile.path.split('/').last;
        print(".........................//////// ${governmentidName.value}");
        update();
        // Perform any additional actions with the selected image
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

  Future<void> AddressproofImage(ImageSource source) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: source, imageQuality: 50);

      if (pickedFile != null) {
        addressproofimage = File(pickedFile.path);
        addressproofName.value = pickedFile.path.split('/').last;
        print(".........................//////// ${addressproofName.value}");
        update();
        // Perform any additional actions with the selected image
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

  void submit() async {
    if (name.isEmpty ||
        employeeId.isEmpty ||
        selectedSex.value == 'Select' ||
        DOBText.isEmpty ||
        age.isEmpty ||
        DOJText.isEmpty ||
        nationality.isEmpty ||
        roles.isEmpty ||
        perdaywages.isEmpty) {
      // Show a dialog box indicating that all fields must be filled
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Employee Data is incomplete'),
            content: const Text('Please fill in all the fields to mandatory field (* marked) .'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      isloading.value = true;
      update();
      // Get the current user's email ID
      String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

      // Query the Users collection to find the user document with the matching email ID
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: currentUserEmail)
          .get();
      if (userQuerySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDocSnapshot = userQuerySnapshot.docs.first;

        CollectionReference employeeCollection =
            userDocSnapshot.reference.collection('employee');

        // Generate a new document ID
        DocumentReference newEmployeeDoc = employeeCollection.doc();
        String employeeimage = '';
        if (image.value != null) {
          String imageFileName1 = '${newEmployeeDoc.id}_image1.jpg';
          Reference storageRef1 = FirebaseStorage.instance
              .ref()
              .child('employeeimages/$imageFileName1');
          UploadTask uploadTask1 = storageRef1.putFile(image.value!);
          TaskSnapshot uploadSnapshot1 = await uploadTask1;
          if (uploadSnapshot1.state == TaskState.success) {
            employeeimage = await storageRef1.getDownloadURL();
          }
        }else{
          employeeimage = 'Employee Image not Available';
        }

        // Upload image 2
        String addressproof = '';
        if(addressproofimage != null){
          String imageFileName2 = '${newEmployeeDoc.id}_image2.jpg';
          Reference storageRef2 = FirebaseStorage.instance
              .ref()
              .child('addressproofimages/$imageFileName2');
          UploadTask uploadTask2 = storageRef2.putFile(addressproofimage!);
          TaskSnapshot uploadSnapshot2 = await uploadTask2;
          if (uploadSnapshot2.state == TaskState.success) {
            addressproof = await storageRef2.getDownloadURL();
          }
        }else{
          addressproof = 'Address Proof Image not Available';
        }

        // Upload image 3
        String passportproof = '';
        if(passportimage != null){
          String imageFileName3 = '${newEmployeeDoc.id}_image3.jpg';
          Reference storageRef3 = FirebaseStorage.instance
              .ref()
              .child('passportimages/$imageFileName3');
          UploadTask uploadTask3 = storageRef3.putFile(passportimage!);
          TaskSnapshot uploadSnapshot3 = await uploadTask3;
          if (uploadSnapshot3.state == TaskState.success) {
            passportproof = await storageRef3.getDownloadURL();
          }
        }else{
          passportproof = 'Passport Proof Image not Available';
        }

        // Upload image 4
        // String governmentidproof = '';
        // String imageFileName4 = '${newEmployeeDoc.id}_image4.jpg';
        // Reference storageRef4 = FirebaseStorage.instance
        //     .ref()
        //     .child('governmentimages/$imageFileName4');
        // UploadTask uploadTask4 = storageRef4.putFile(governmentidimage!);
        // TaskSnapshot uploadSnapshot4 = await uploadTask4;
        //
        // if (uploadSnapshot4.state == TaskState.success) {
        //   governmentidproof = await storageRef3.getDownloadURL();
        // }

        // Add data to the employee collection
        final employeeData = {
          'employee image': employeeimage.isNotEmpty ? employeeimage : 'Not Available',
          'name': name.value.isNotEmpty ? name.value : 'Not Available',
          'employee Id': employeeId.value.isNotEmpty ? employeeId.value : 'Not Available',
          'sex': selectedSex.value.isNotEmpty ? selectedSex.value : 'Not Available',
          'age': age.value.isNotEmpty ? age.value : 'Not Available',
          'Date of Birth': DOBText.value.isNotEmpty ? DOBText.value : 'Not Available',
          'Date of Joining': DOJText.value.isNotEmpty ? DOJText.value : 'Not Available',
          'Nationality': nationality.value.isNotEmpty ? nationality.value : 'Not Available',
          'Permanent Address': presentaddress.value.isNotEmpty ? presentaddress.value : 'Not Available',
          'present Address': presentaddress.value.isNotEmpty ? presentaddress.value : 'Not Available',
          'address proof': addressproof.isNotEmpty ? addressproof : 'Not Available',
          'Phone number': phonenumber.value.isNotEmpty ? phonenumber.value : 'Not Available',
          'Alternate Phone number': alternatephonenumber.value.isNotEmpty ? alternatephonenumber.value : 'Not Available',
          'emergency contact name': emergencycontactname.value.isNotEmpty ? emergencycontactname.value : 'Not Available',
          'emergency contact number': emergencycontactnumber.value.isNotEmpty ? emergencycontactnumber.value : 'Not Available',
          'Passport no': passportno.value.isNotEmpty ? passportno.value : 'Not Available',
          'passport expiry': expiryText.value.isNotEmpty ? expiryText.value : 'Not Available',
          'passport image': passportproof.isNotEmpty ? passportproof : 'Not Available',
          'role': roles.value.isNotEmpty ? roles.value : 'Not Available',
          'per day wages': perdaywages.value.isNotEmpty ? perdaywages.value : 'Not Available',
          'Advance amount': 'Not Available',
        };


        await newEmployeeDoc.set(employeeData);
        isloading.value = false;
        update();
        showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: const Text('Employee Data Submitted'),
              content:
                  const Text('Employee data has been successfully submitted.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.back();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                Text('An error occurred while submitting employee data: $e'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<String> uploademployeeImage(File? imageFile, String fileName) async {
    if (imageFile == null) {
      return '';
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final compressedImage = await compressImage(imageFile);
      final imageExtension = path.extension(fileName);
      final uploadTask = storageRef
          .child('employeeimages/$fileName$imageExtension')
          .putFile(compressedImage);
      final snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        final imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } else {
        print('Image upload failed');
        return '';
      }
    } catch (e) {
      print('Image upload error: $e');
      return '';
    }
  }

  Future<String> uploadpassportImage(File? imageFile, String fileName) async {
    if (imageFile == null) {
      return '';
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final compressedImage = await compressImage(imageFile);
      final imageExtension = path.extension(fileName);
      final uploadTask = storageRef
          .child('passportimages/$fileName$imageExtension')
          .putFile(compressedImage);
      final snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        final imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } else {
        print('Image upload failed');
        return '';
      }
    } catch (e) {
      print('Image upload error: $e');
      return '';
    }
  }

  Future<String> uploadgovernmentImage(File? imageFile, String fileName) async {
    if (imageFile == null) {
      return '';
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final compressedImage = await compressImage(imageFile);
      final imageExtension = path.extension(fileName);
      final uploadTask = storageRef
          .child('governmentimages/$fileName$imageExtension')
          .putFile(compressedImage);
      final snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        final imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } else {
        print('Image upload failed');
        return '';
      }
    } catch (e) {
      print('Image upload error: $e');
      return '';
    }
  }

  Future<String> uploadaddressproofImage(
      File? imageFile, String fileName) async {
    if (imageFile == null) {
      return '';
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final compressedImage = await compressImage(imageFile);
      final imageExtension = path.extension(fileName);
      final uploadTask = storageRef
          .child('addressproofimages/$fileName$imageExtension')
          .putFile(compressedImage);
      final snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        final imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } else {
        print('Image upload failed');
        return '';
      }
    } catch (e) {
      print('Image upload error: $e');
      return '';
    }
  }

  Future<File> compressImage(File imageFile) async {
    final filePath = imageFile.path;
    final lastIndex = filePath.lastIndexOf('.');
    final compressedFilePath =
        '${filePath.substring(0, lastIndex)}_compressed${filePath.substring(lastIndex)}';

    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      compressedFilePath,
      quality: 50,
    );

    return result as File? ?? imageFile;
  }
}
