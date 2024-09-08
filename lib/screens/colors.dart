import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/settings_controller.dart';

class ColorController extends GetxController {
  SettingsController con = Get.put(SettingsController());
  Rx<Color> bgcolor = Colors.white.obs;
  Rx<Color> textfcolor = Color.fromARGB(255, 232, 240, 254).obs;
  Rx<Color> minitxt = Color.fromARGB(204, 33, 37, 41).obs;
  Rx<Color> txtcolor = Colors.black.obs;
  Rx<Color> hintcolor = Colors.black.obs;
  Rx<Color> iconcolor = Color.fromARGB(204,33, 37, 41).obs;
  Rx<Color> purplecolor = Color.fromARGB(255,109, 40, 217).obs;


  
  @override
  void onInit() {
    super.onInit();
    if (con.isDark.value) {
      bgcolor = Color.fromARGB(255, 0, 35, 64).obs;
      textfcolor = Color.fromARGB(255, 0, 35, 64).obs;
      txtcolor = Colors.white.obs;
      iconcolor = Colors.white.obs;
      
      minitxt = Color.fromARGB(255, 232, 240, 254).obs;
    }
  }
}
