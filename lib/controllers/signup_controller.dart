import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // Text controllers for form fields
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Email regex for validation
  final emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");

  // Function to validate form fields
  bool validateForm() {
    bool isValid = true;

    if (fullNameController.text.trim().isEmpty) {
      showSnackbar("Invalid Input", "Full Name can't be empty");
      isValid = false;
    }

    if (!emailRegex.hasMatch(emailController.text.trim())) {
      showSnackbar("Invalid Input", "Please enter a valid email");
      isValid = false;
    }

    if (passwordController.text.trim().length < 8) {
      showSnackbar("Invalid Input", "Password must be at least 8 characters long");
      isValid = false;
    }

    if (phoneController.text.trim().isEmpty || !phoneController.text.trim().startsWith('+')) {
      showSnackbar("Invalid Input", "Phone number must start with '+' and cannot be empty");
      isValid = false;
    }

    return isValid;
  }

  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP, // Snackbar at the bottom
      backgroundColor: Colors.redAccent.withOpacity(0.8), // Semi-transparent background
      colorText: Colors.white,
      margin: EdgeInsets.all(10), // Margin to avoid pushing UI
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      overlayBlur: 1.5, // Adding blur effect for overlay
      isDismissible: true,
      duration: Duration(seconds: 2), // Snackbar duration
    );
  }

  // Dispose controllers when not needed
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
