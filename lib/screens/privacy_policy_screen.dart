import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itp_voice/screens/colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
  ColorController cc = Get.find<ColorController>();
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Privacy Policy"),
      ),
      body: Center(
        child: Text("Privacy Policy"),
      ),
    );
  }
}