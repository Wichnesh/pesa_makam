import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constant.dart';
import '../utils/common_methods.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordEmpty = false.obs;
  var isloading = false.obs;
  var name = "".obs;
  var emailid = "".obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;

  Future<void> onInit() async {
    await _initializePreferences();
    super.onInit();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool validateEmail(String email) {
    // Use your email validation logic here
    // Return true if the email is valid, false otherwise
    // You can use regular expressions or any other method
    return email.isNotEmpty && email.contains('@');
  }

  void signInButtonPressed() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!validateEmail(email)) {
      // Show error or display a message for invalid email
      return;
    }

    if (password.isEmpty) {
      isPasswordEmpty.value = true;
      return;
    }

    // Perform the sign-in logic here
    // ...
  }

  Future<void> loginWithEmail() async {
    try {
      isloading.value = true;
      update();
      final userCredential = await _auth
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) async {
        name.value = value.user!.displayName.toString();
        emailid.value = value.user!.email.toString();
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(emailid.value);
        // Check if the user document exists in the 'Users' collection
        var docSnapshot = await userDocRef.get();

        if (docSnapshot.exists) {
          // Explicitly cast the data to Map<String, dynamic>
          var userData = docSnapshot.data() as Map<String, dynamic>;
          var role = userData['Role']; // Assuming 'role' is the field in your document
          print('User Role: $role');
          _prefs.setString(ROLE,role);
        } else {
          print('User document does not exist.');
        }
        _prefs.setBool('isLoggedIn', true);
        Get.offAllNamed(ROUTE_HOME);
        showToast("Login Successful");
      }).onError((error, stackTrace) {
        print('${error} && ${stackTrace}');
        showToast('Login failed');
      });
    } catch (error) {
      showToast("Login Failed: $error");
    }
    isloading.value = false;
    update();
  }

  Future<void> sendPasswordResetLink() async {
    String email = emailController.text.trim();

    if (!validateEmail(email)) {
      // Show error or display a message for invalid email
      print('object');
      Get.snackbar("Error", "Invalid format",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      print('send');
      await _auth.sendPasswordResetEmail(email: email);
      showToast("Password reset link sent to your email.");
    } catch (error) {
      showToast("Failed to send password reset link: $error");
    }
  }
}
