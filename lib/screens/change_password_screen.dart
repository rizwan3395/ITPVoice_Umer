import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/profile_controller.dart';
import 'package:itp_voice/controllers/settings_controller.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_button.dart';
import 'package:itp_voice/widgets/password_textfield.dart';
import 'package:itp_voice/widgets/phone_number_field.dart';

class ChangePassordScreen extends StatelessWidget {
  ChangePassordScreen({super.key});

  SettingsController con = Get.put(SettingsController());
  ProfileController conn = Get.put(ProfileController());
  ColorController cc = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(top: 10.h, left: 0.w),
          child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios,
                  color: AppTheme.colors(context)?.textColor, size: 18.sp)),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            "Change Password",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            const Divider(
              height: 0,
            ),
            SizedBox(
              height: 30.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "New Password",
                          style: TextStyle(
                            color: AppTheme.colors(context)?.textColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: " *",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  PasswordTextField(
                    hint: "Enter New Password",
                    textController: conn.passwordController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Confirm New Password",
                          style: TextStyle(
                            color: AppTheme.colors(context)?.textColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: " *",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  PasswordTextField(
                    hint: "Confirm New Password",
                    textController: conn.confirmPasswordController,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (conn.passwordController.text ==
                            conn.confirmPasswordController.text) {
                          conn.changePassword();
                          Get.back();
                        } else {
                          Get.snackbar("Error", "Passwords do not match");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cc.purplecolor.value,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text("Change Password",
                          style:
                              TextStyle(color: Colors.white, fontSize: 13.sp)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            )
          ],
        ),
      ),
    );
  }
}
