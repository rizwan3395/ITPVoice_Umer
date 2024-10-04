import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/password_textfield.dart';

import '../controllers/signup_controller.dart';
import '../routes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_textfield.dart';

class SignupScreen1 extends StatefulWidget {
  const SignupScreen1({super.key});

  @override
  State<SignupScreen1> createState() => _SignupScreen1State();
}

class _SignupScreen1State extends State<SignupScreen1> {
  ColorController cc = Get.put(ColorController());
  SignupController con = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cc.bgcolor.value,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: cc.bgcolor.value,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/voice360.png",
                    width: 184.w,
                    height: 40.h,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 9.h),
                    // padding: const EdgeInsets.symmetric(horizontal: 30),
                    // margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Let's create account together",
                      style: TextStyle(
                        color: cc.minitxt.value,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    // padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Full Name",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                // background: rgba(255,108, 117, 125);
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppTextField(
                    textController: con.fullNameController,
                    hint: 'Fox',
                    iccon: Icons.person,
                    borderRadius: 15.r,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    // padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Email",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                // background: rgba(255,108, 117, 125);
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppTextField(
                    textController: con.emailController,
                    hint: 'Robert.itp.com',
                    iccon: Icons.email,
                    borderRadius: 15.r,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    // padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Password",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                // background: rgba(255,108, 117, 125);
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  PasswordTextField(
                    textController: con.passwordController,
                    hint: '****************',
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    // padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Phone Number",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                // background: rgba(255,108, 117, 125);
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppTextField(
                    textController: con.phoneController,
                    hint: '+446273821964',
                    iccon: Icons.phone,
                    flagImage: "assets/images/us.png",
                    borderRadius: 15.r,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (con.validateForm()) {
                        // If the form is valid, proceed with the sign-up process
                        Navigator.pushNamed(context, Routes.VERIFY_OTP_ROUTE);
                      }
                      // Get.toNamed(Routes.VERIFY_OTP_ROUTE);
                      
                      // con.login();
                      // AuthRepo().getAllPosts();

                      // Get.toNamed(Routes.BASE_SCREEN_ROUTE);
                      // CustomLoader.showLoader();
                    },
                    child: AppButton(
                      text: "Sign Up",
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Get.offAllNamed(Routes.LOGIN_SCREEN_ROUTE);
                        },
                        child: const Text('Sign in'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// https://app.dev.voice360.app/sign-up
// /^[^\s@]+@[^\s@]+\.[^\s@]+$/