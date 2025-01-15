import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/login_controller.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ColorController cc = Get.find<ColorController>();
  LoginController con = Get.put(LoginController());
  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        title:
            Text('Forgot Password', style: TextStyle(color: cc.txtcolor.value)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/voice360.png',
              height: 200.h,
            ),
        
            Container(
              
              padding: EdgeInsets.all(18.h),
              child: AppTextField(
                  textController: con.forgetEmailController,
                  borderRadius: 5,
                  hint: "Enter your email"),
            ),
            ElevatedButton(
                onPressed: () {
                  con.forgetPassword();
                  Get.back();
                },
                child: Text(
                  'Send Verification Email',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: cc.purplecolor.value,
                ),)
          ],
        ),
      ),
    );
  }
}
