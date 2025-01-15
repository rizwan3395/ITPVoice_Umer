import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/settings_controller.dart';

class ColorController extends GetxController {
  SettingsController con = Get.put(SettingsController());
  Rx<Color> bgcolor = Colors.white.obs;
  Rx<Color> textfcolor = const Color.fromARGB(255, 232, 240, 254).obs;
  Rx<Color> minitxt = const Color.fromARGB(204, 33, 37, 41).obs;
  Rx<Color> txtcolor = Colors.black.obs;
  Rx<Color> hintcolor = Colors.black.obs;
  Rx<Color> iconcolor = const Color.fromARGB(204,33, 37, 41).obs;
  Rx<Color> purplecolor = const Color.fromARGB(255,109, 40, 217).obs;
  Rx<Color> tabcolor = const Color.fromARGB(255, 232, 240, 254).obs;
  Rx<Color> msgAvatarClr = const Color.fromARGB(255,109, 40, 217).obs;
  Rx<Color> chatBorderColor = const Color.fromARGB(255,222, 226, 230).obs;
  Rx<Color> chatbartxt = const Color.fromRGBO(33, 37, 41, 0.8).obs;
 
  

  



void toggledark(){
  if (con.isDark.value) {
    chatBorderColor = const Color.fromARGB(255,67, 112, 151).obs;
    bgcolor = const Color.fromARGB(255, 0, 35, 64).obs;
    chatbartxt = const Color.fromRGBO(158, 158, 158, 1).obs;
    textfcolor = const Color.fromARGB(255, 0, 35, 64).obs;
    txtcolor = Colors.white.obs;
    tabcolor = const Color.fromARGB(255,1, 47, 85).obs;
    iconcolor = Colors.white.obs;
    minitxt = const Color.fromARGB(255, 232, 240, 254).obs;
    msgAvatarClr = Colors.white.obs;
    
    

  } else {
    chatbartxt = const Color.fromRGBO(33, 37, 41, 0.8).obs;
    chatBorderColor = const Color.fromARGB(255,222, 226, 230).obs;
    bgcolor = Colors.white.obs;
    msgAvatarClr = const Color.fromARGB(255,109, 40, 217).obs;
    tabcolor = const Color.fromARGB(255, 232, 240, 254).obs;
    textfcolor = const Color.fromARGB(255, 232, 240, 254).obs;
    txtcolor = Colors.black.obs;
    iconcolor = const Color.fromARGB(204,33, 37, 41).obs;
    minitxt = const Color.fromARGB(204, 33, 37, 41).obs;
  }
}

  Color randomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}
  
  @override
  void onInit() {
    super.onInit();
    if (con.isDark.value) {
      chatBorderColor = const Color.fromARGB(255,67, 112, 151).obs;
      bgcolor = const Color.fromARGB(255, 0, 35, 64).obs;
      chatbartxt = const Color.fromRGBO(158, 158, 158, 1).obs;
      tabcolor = const Color.fromARGB(255,1, 47, 85).obs;
      textfcolor = const Color.fromARGB(255, 0, 35, 64).obs;
      txtcolor = Colors.white.obs;
      iconcolor = Colors.white.obs;
      msgAvatarClr = Colors.white.obs;
      
      minitxt = const Color.fromARGB(255, 232, 240, 254).obs;
    }
  }
}
