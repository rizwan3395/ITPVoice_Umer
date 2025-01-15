import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/settings_controller.dart';
import 'package:itp_voice/repo/auth_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_button.dart';
import 'package:itp_voice/widgets/custom_widgets/profile_option.dart';
import 'package:itp_voice/widgets/phone_number_field.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  SettingsController con = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(top: 10.h, left: 0.w),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
              color: cc.iconcolor.value,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            "Settings",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Obx(
        () => con.isLoading.value == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  children: [
                    ProfileOption(
                        text: "Call Forwarding",
                        onTap: () {
                          Get.toNamed(Routes.CALL_SETTINGS_ROUTE);
                        },
                        icon: Icons.phone,
                        isSetting: true),
                    ProfileOption(
                        text: "Caller Id",
                        onTap: () {
                          Get.toNamed(Routes.CALLER_ID_SCREEN_ROUTE);
                        },
                        icon: Icons.account_circle_outlined,
                        isSetting: true),
                    ProfileOption(
                        text: "Call Recording",
                        onTap: () {
                          Get.toNamed(Routes.CALL_RECORDING_SETTING_SCREEN);
                        },
                        icon: Icons.mic,
                        isSetting: true),
                    ProfileOption(
                        text: "Voicemail",
                        onTap: () {Get.toNamed(Routes.VOICE_MAIL_SETTING_ROUTE);},
                        icon: Icons.voice_chat,
                        isSetting: true),
                    
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: ListTile(
                        title: Text(
                          "Dark mode",
                          style: TextStyle(
                            color: cc.minitxt.value,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Obx(
                          () => SizedBox(
                            width: 70,
                            child: FlutterSwitch(
                              height: 22.h,
                              width: 50.w,
                              activeColor: cc.purplecolor.value,
                              padding: 0,
                              value: con.isDark.value,
                              onToggle: (val) {
                                con.isDark.value = val;
                                con.changeTheme(val);
                                cc.toggledark();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
      ),
    );
  }
}
