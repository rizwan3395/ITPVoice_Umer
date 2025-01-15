import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/locator.dart';
import 'package:itp_voice/repo/auth_repo.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/services/numbers_service.dart';
import 'package:itp_voice/storage_keys.dart';
import 'package:itp_voice/widgets/custom_loader.dart';
import 'package:itp_voice/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_reponse_model/app_user.dart';

class LoginController extends GetxController {
  RxBool isRemember = true.obs;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController forgetEmailController = TextEditingController();
  final _authRepo = AuthRepo();

  RxBool showLogin = false.obs;

  login() async {
    bool isFormValid = validateLoginForm();
    if (isFormValid) {
      print("Logging in");
      CustomLoader.showLoader();
      var res = await _authRepo.loginUser(
        emailController.text,
        passwordController.text,
        isRemember.value,
      );
      print("*****1******${res.toString()}");
      Get.back();
      if (res.runtimeType == String) {
        CustomToast.showToast(res.toString(), true);

        return;
      }
      if (res == null) {
        CustomToast.showToast("Unexpected error occurred", true);

        return;
      } else {
        await locator<NumbersService>().getUpdatedNumbersList();
        Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
      }
    }
  }

  forgetPassword()async{
    if(forgetEmailController.text.isEmpty){
      CustomToast.showToast("Please enter email", true);
      return;
    }
    if (forgetEmailController.text.isNotEmpty) {
      bool isEmailValid = EmailValidator.validate(forgetEmailController.text);
      if (!isEmailValid) {
        CustomToast.showToast("Please enter a valid email", true);
        return;
      }
    }
    CustomLoader.showLoader();
    var res = await _authRepo.forgetPassword(forgetEmailController.text);
    Get.back();
    if (res.runtimeType == String) {
      CustomToast.showToast(res.toString(), true);
      return;
    }
    if (res == null) {
      CustomToast.showToast("Unexpected error occurred", true);
      return;
    } else {
      CustomToast.showToast("Password reset link sent to your email", false);
    }

  }



  validateLoginForm() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      CustomToast.showToast("Please enter email and password", true);
      return false;
    }
    if (emailController.text.isNotEmpty) {
      bool isEmailValid = EmailValidator.validate(emailController.text);
      if (!isEmailValid) {
        CustomToast.showToast("Please enter a valid email", true);
        return false;
      }
    }
    if (passwordController.text.length < 4) {
      CustomToast.showToast("Password must be 6 characters long", true);
      return false;
    }
    return true;
  }

  bool initializedd = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initializedd = false;
    Future.delayed(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(StorageKeys.REFRESH_TOKEN);
      if (token == null) {
        bool? remember = prefs.getBool(StorageKeys.REMEMBER);
        if (remember != null && remember) {
          // emailController.text = _prefs.getString(StorageKeys.EMAIL)!;
          // passwordController.text = _prefs.getString(StorageKeys.PASSWORD)!;
        }
        showLogin.value = true;
      } else {
        try {
          await locator<NumbersService>().getUpdatedNumbersList();
        } catch (e) {
          showLogin.value = true;
          return;
        }
        if (Get.currentRoute == Routes.LOGIN_SCREEN_ROUTE) {
          Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
        }
        initializedd = true;
      }
      bool? isDark = SharedPreferencesMethod.storage.getBool(StorageKeys.DARK_THEME);
      if (isDark == true) {
        Get.changeThemeMode(ThemeMode.dark);
      } else {
        Get.changeThemeMode(ThemeMode.light);
      }
    });
  }
}
