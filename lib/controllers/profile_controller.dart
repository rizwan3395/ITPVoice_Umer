import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:itp_voice/models/user_profile_model/result.dart';
import 'package:itp_voice/models/user_profile_model/user_profile.dart';
import 'package:itp_voice/repo/auth_repo.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  RxBool isloading = false.obs;
  Profile? userProfile;

  // Controllers for text fields
  TextEditingController mobileController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String timezone = "";

  AuthRepo repo = AuthRepo();
  String phoneCode = "";

  // Fetch user profile from the server and populate controllers
  fetchUserProfile() async {
    isloading.value = true;
    final res = await repo.getProfile();

    if (res.runtimeType == UserProfile) {
      UserProfile model = res;
      userProfile = model.profile;
      firstNameController.text = userProfile?.firstname ?? '';
      lastNameController.text = userProfile?.lastname ?? '';
      phoneController.text = userProfile?.mobile ?? '';
      mobileController.text = userProfile?.mobile ?? '';
      faxController.text = userProfile?.fax ?? '';
    }
    isloading.value = false;
  }

  // Update user profile
  updateProfile() async {
    isloading.value = true;
    final res = await repo.editProfile(
        firstNameController.text,
        lastNameController.text,
        phoneController.text,
        mobileController.text,
        faxController.text,
        timezone);

    if (res.runtimeType == UserProfile) {
      UserProfile model = res;
      if (model.errors == false) {
        fetchUserProfile();
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update profile");
      }
    }
    isloading.value = false;
  }


  changePassword() async {
    isloading.value = true;
    final res = await repo.changePass(
        passwordController.text
        );

    if (res.runtimeType == UserProfile) {
      UserProfile model = res;
      if (model.errors == false) {
        fetchUserProfile();
        Get.snackbar("Success", "Password updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update Password");
      }
    }
    isloading.value = false;
  }

  // Validation function for all fields
  bool validateForm() {
    // Trim each input field
    _trimAllFields();

    // Check if any non-empty field has invalid content (only if required)
    if (!_isValid(firstNameController) ||
        !_isValid(lastNameController) ||
        !_isValid(phoneController) ||
        !_isValid(mobileController) ||
        !_isValid(faxController)) {
      return false;
    }

    // If all non-empty fields are valid, return true
    return true;
  }

  // Trim all fields
  void _trimAllFields() {
    firstNameController.text = firstNameController.text.trim();
    lastNameController.text = lastNameController.text.trim();
    phoneController.text = phoneController.text.trim();
    mobileController.text = mobileController.text.trim();
    faxController.text = faxController.text.trim();
  }

  // Helper function to validate a field (returns true if field is empty or valid)
  bool _isValid(TextEditingController controller) {
    String text = controller.text;

    // Here you can add any specific validation logic for non-empty fields
    if (text.isEmpty) {
      return true; // Valid because the field is allowed to be empty
    }

    // Additional validation rules for non-empty fields can go here, e.g., length check, format, etc.
    if (text.length < 2) {
      return false; // Example of a validation rule for demonstration
    }

    return true;
  }


  
}
