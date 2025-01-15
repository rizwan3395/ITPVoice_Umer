import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/base_screen_controller.dart';
import 'package:itp_voice/repo/contacts_repo.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/screens/call_history_screen.dart';
import 'package:itp_voice/storage_keys.dart';
import 'package:itp_voice/widgets/custom_widgets/dialpad/flutter_dialpad.dart';

import '../app_theme.dart';

class HomeScreen extends StatefulWidget {
  final String? initialValue;
  const HomeScreen({
    super.key,
    this.initialValue,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showDialpad = true;
  BaseScreenController con = Get.find<BaseScreenController>();

  @override
  Widget build(BuildContext context) {
    return  CallHistoryScreen();
  }
}
