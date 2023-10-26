import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/common_methods.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  var userTypeErrorText = "".obs;
  var nameErrorText = "".obs;
  var emailErrorText = "".obs;
  var passwordErrorText = "".obs;
  var rePasswordErrorText = "".obs;
  var userType = 'Select a role'.obs;
  List<String> roles = ['Select a role', 'Admin', 'Cashier'];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void onClose() {
    // Dispose the controllers when the controller is closed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.onClose();
  }

  updateUserType(val) {
    userType.value = val;
    update();
  }

  void validateFields() {
    validateEmail();
    validatePassword();
    validateRePassword();
  }

  void validateUserType() {
    if (userType.value == 'Select a role') {
      userTypeErrorText.value = 'Please select a role';
      showToast('Please select a role');
    } else {
      userTypeErrorText.value = '';
    }
  }

  void validateName() {
    if (nameController.text.isEmpty) {
      nameErrorText.value = 'Name is required';
      showToast('Name is required');
    } else {
      nameErrorText.value = '';
    }
  }

  void validateEmail() {
    if (emailController.text.isEmpty) {
      showToast('Email is required');
    } else if (!GetUtils.isEmail(emailController.text)) {
      showToast('Invalid email format');
    } else {
      emailErrorText.value = '';
    }
  }

  void validatePassword() {
    if (passwordController.text.isEmpty) {
      showToast('Password is required');
    } else if (passwordController.text.length < 6) {
      showToast('Password must be at least 6 characters long');
    } else {
      passwordErrorText.value = '';
    }
  }

  void validateRePassword() {
    if (rePasswordController.text.isEmpty) {
      showToast('Re-enter password is required');
    } else if (rePasswordController.text != passwordController.text) {
      showToast('Passwords do not match');
    } else {
      rePasswordErrorText.value = '';
    }
  }

  Future<void> registeruser() async {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      final userRef = FirebaseFirestore.instance.collection("Users");
      final email = emailController.text;

      // Check if email is already registered
      final querySnapshot =
          await userRef.where("email", isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        showToast("Email already registered");
        return;
      }
      //

      // Register the user
      await userRef.doc(email).set({
        "Username": nameController.text,
        "email": email,
        "password": passwordController.text,
        "Role": userType.value,
      });
      registerWithEmail();
      showToast("Registration Successful");
      Get.back();
    } else {
      showToast("Registration failed");
    }
  }

  Future<void> registerWithEmail() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the newly created user
      final User? user = userCredential.user;

// Set the username
      final String username = nameController.text;

// Update the user's profile with the username
      await user?.updateDisplayName(username);
      // Handle successful registration here, such as storing user information or navigating to another screen.
      // You can access the registered user through userCredential.user property.
      showToast("Registration Sign-in Successful");
    } catch (error) {
      showToast("Registration Failed: $error");
    }
  }
}
