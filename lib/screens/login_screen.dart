import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/login_controller.dart';
import 'package:itp_voice/controllers/settings_controller.dart';
import 'package:itp_voice/notification_service.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_button.dart';
import 'package:itp_voice/widgets/app_textfield.dart';
import 'package:itp_voice/widgets/password_textfield.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController con = Get.put(LoginController());

  ColorController cc = Get.put(ColorController());

  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          if (message.data != null) {
            final notificationData = message.data;
            if ((notificationData as Map<String, dynamic>)
                .containsKey("message_thread_id")) {
              await Get.toNamed(Routes.CHAT_SCREEN_ROUTE, arguments: [
                notificationData["message_thread_id"],
                notificationData["to_phone_number"],
                null
              ]);
              if (con.initializedd == true) {
                Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
              }
            }
          }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          if (Get.currentRoute == Routes.CHAT_SCREEN_ROUTE) {
          } else {
            LocalNotificationService.createanddisplaynotification(message);
          }
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data}");
          if (message != null) {
            if (message.data != null) {
              final notificationData = message.data;
              if ((notificationData as Map<String, dynamic>)
                  .containsKey("message_thread_id")) {
                Get.toNamed(Routes.CHAT_SCREEN_ROUTE, arguments: [
                  notificationData["message_thread_id"],
                  notificationData["to_phone_number"],
                  null
                ]);
              }
            }
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(() => SafeArea(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cc.bgcolor.value,
                // Set background color
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => con.showLogin.value
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: Align(
                                // alignment: Alignment.center,

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/images/voice360.png",
                                      width: 184,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      height: 87.h,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Hello Again!",
                                          style: TextStyle(
                                            fontSize: 33.sp,
                                            color: cc.txtcolor.value,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Roboto",
                                          ),
                                        ),

                                        SizedBox(height: 28.h),
                                        Container(
                                          alignment: Alignment.center,
                                          // padding: const EdgeInsets.symmetric(horizontal: 30),
                                          // margin: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            "Welcome Back! Securely access your account and explore the world of automated communication. ",
                                            style: TextStyle(
                                              color: cc.minitxt.value,
                                              fontSize: 17.sp,
                                              fontFamily: "Roboto",
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Container(
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
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        AppTextField(
                                          textController: con.emailController,
                                          hint: "Rebort.Itp.Com",
                                          borderRadius: 15.r,
                                          iccon: Icons.email,
                                        ),
                                        SizedBox(
                                          height: 24.h,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Password",
                                                  style: TextStyle(
                                                    color: cc.minitxt.value,
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        PasswordTextField(
                                          textController:
                                              con.passwordController,
                                          hint: "***********",
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        // Row(
                                        //   mainAxisSize: MainAxisSize.max,
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.start,
                                        //   children: [
                                        //     Obx(
                                        //       () => Checkbox(
                                        //         side: const BorderSide(
                                        //             color: Color(0xffC4C4C4)),
                                        //         // activeColor: Colors.red,
                                        //         shape: RoundedRectangleBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(3),
                                        //         ),
                                        //         checkColor: Colors.white,
                                        //         fillColor:
                                        //             MaterialStateProperty.all(
                                        //                 Theme.of(context)
                                        //                     .colorScheme
                                        //                     .primary),
                                        //         value: con.isRemember.value,
                                        //         onChanged: (v) {
                                        //           con.isRemember.value = v!;
                                        //         },
                                        //       ),
                                        //     ),
                                        //     Text(
                                        //       "Remember Me",
                                        //       style: TextStyle(
                                        //         fontSize: 15.sp,
                                        //         color: const Color(0xffA6B0CF),
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        SizedBox(height: 10.h),
                                        GestureDetector(
                                          onTap: () {
                                            con.login();
                                            // AuthRepo().getAllPosts();

                                            // Get.toNamed(Routes.BASE_SCREEN_ROUTE);
                                            // CustomLoader.showLoader();
                                          },
                                          child: AppButton(
                                            text: "Log In",
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 14.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  navigator?.pushNamed(
                                                      Routes.SIGNUP_SCREEN_ROUTE);
                                                },
                                                child: Text(
                                                  "Sign Up ",
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 67, 112, 151),
                                                    fontSize: 15.sp,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // get.toNamed(
                                                  //     Routes.CHANGE_PASSWORD_ROUTE);
                                                },
                                                child: Text(
                                                  "Forget Password",
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 67, 112, 151),
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Inter",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 50.h),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Align(
                              child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 37.w),
                              child:
                                  Image.asset("assets/images/splash-logo.png"),
                            )),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
