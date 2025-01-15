import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/profile_controller.dart';
import 'package:itp_voice/repo/auth_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_textfield.dart';
import 'package:itp_voice/widgets/custom_widgets/country_phone_code_picker/core/country_phone_code_picker_widget.dart';
import 'package:itp_voice/widgets/custom_widgets/country_phone_code_picker/models/country.dart';
import 'package:itp_voice/widgets/custom_widgets/profile_option.dart';
import 'package:itp_voice/widgets/phone_number_field.dart';
import 'package:itp_voice/widgets/prefix_textfield.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  String profileImage =
      "https://images.unsplash.com/photo-1640951613773-54706e06851d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80";

  ProfileController con = Get.put(ProfileController());
  ColorController cc = Get.put(ColorController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            "My Profile",
            style: TextStyle(
              color: cc.txtcolor.value,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Obx(
        () => con.isloading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileOption(
                        isSetting: false,
                          text: "Settings",
                          onTap: () async {
                            await Get.toNamed(Routes.SETTINGS_SCREEN_ROUTE,
                                arguments: con.mobileController.text);
                            con.fetchUserProfile();
                          },
                          icon: Icons.settings_outlined),
                      Divider(
                          height: 0.5,
                          indent: 20.w,
                          endIndent: 17.w,
                          color: Color.fromRGBO(222, 226, 230, 1)),
                      ProfileOption(
                          isSetting: false,
                          text: "Edit Profile",
                          onTap: () {
                            Get.toNamed(Routes.EDIT_PROFILE_SCREEN_ROUTE);
                          },
                          icon: Icons.co_present_outlined),
                      Divider(
                          height: 0.5,
                          indent: 20.w,
                          endIndent: 17.w,
                          color: Color.fromRGBO(222, 226, 230, 1)),
                      ProfileOption(
                        isSetting: false,
                          text: "Change Password",
                          onTap: () {Get.toNamed(Routes.CHANGE_PASSWORD_ROUTE);},
                          icon: Icons.lock),
                      Divider(
                          height: 0.5,
                          indent: 20.w,
                          endIndent: 17.w,
                          color: Color.fromRGBO(222, 226, 230, 1)),
                      
                      ProfileOption(
                        isSetting: false,
                          text: "Privacy policy",
                          onTap: () {Get.toNamed(Routes.PRIVACY_POLICY_SCREEN_ROUTE);},
                          icon: Icons.lock_outline_rounded),
                      Divider(
                          height: 0.5,
                          indent: 20.w,
                          endIndent: 17.w,
                          color: Color.fromRGBO(222, 226, 230, 1)),
                      ProfileOption(
                        isSetting: false,
                          text: "Logout",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: cc.tabcolor.value,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 30.w),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  content: Text(
                                    "Are you sure you want to logout?",
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        "Yes",
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () async {
                                        // Navigator.of(context).pop();
                                        await AuthRepo().logoutUser();
                                        Get.offAllNamed(
                                            Routes.LOGIN_SCREEN_ROUTE);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icons.logout),
                      Divider(
                          height: 0.5,
                          indent: 20.w,
                          endIndent: 17.w,
                          color: Color.fromRGBO(222, 226, 230, 1))
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
