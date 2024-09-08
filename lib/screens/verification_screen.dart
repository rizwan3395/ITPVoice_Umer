import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/signup_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController pinController = TextEditingController();
  Timer? _timer;
  int _start = 30; // Set the initial time for 30 seconds

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer when the screen is initialized
  }

  // Function to start the timer
  void startTimer() {
    _start = 30; // Reset the time for every resend
    _timer?.cancel(); // Cancel any previous timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel(); // Stop the timer when it reaches 0
        });
      } else {
        setState(() {
          _start--; // Decrease the timer by 1 second
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignupController con = Get.put(SignupController());
    ColorController cc = Get.put(ColorController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: cc.bgcolor.value,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: cc.iconcolor.value),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              // Heading Text
              Text(
                'Verify Your Account!',
                style: TextStyle(
                  color: cc.txtcolor.value,
                  fontSize: 33.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'We sent a code to your Email',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: cc.minitxt.value,
                ),
              ),
              Text(
                con.emailController.text,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: cc.minitxt.value,
                ),
              ),
              SizedBox(height: 40.h),
              
              // Pinput for the OTP code
              Pinput(
                controller: pinController,
                length: 4,
                defaultPinTheme: PinTheme(
                  width: 56.w,
                  height: 56.h,
                  textStyle: TextStyle(
                    fontSize: 17.sp,
              
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: BoxDecoration(
                    
                    color: cc.textfcolor.value,
                    border: Border.all(
                      color: Color.fromARGB(255,232, 240, 254),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 56.w,
                  height: 56.h,
                  textStyle: TextStyle(
                    fontSize: 17.sp,
                    color: cc.txtcolor.value,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: BoxDecoration(
                    color:cc.textfcolor.value ,
                    border: Border.all(
                      color: Color.fromARGB(255,232, 240, 254),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: cc.purplecolor.value.withOpacity(0.5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 56.w,
                  height: 56.h,
                  textStyle: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.white,
                    fontFamily: "Poppins-Regular",
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: BoxDecoration(
                    color: cc.purplecolor.value,
                    border: Border.all(
                      color: Color.fromARGB(255,232, 240, 254),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onCompleted: (pin) => print('Completed: $pin'),
              ),
              
              SizedBox(height: 30.h),
              
              // Resend Timer and Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend',
                    style: TextStyle(color: Color.fromARGB(255,67, 112, 151),fontSize: 16.sp,fontWeight: FontWeight.w500),
                    
                  ),
                  Text(
                    ' in 00:${_start.toString().padLeft(2, '0')}', // Display dynamic countdown
                    style: TextStyle(color: cc.minitxt.value,fontSize: 16.sp),
                    
                  ),
                ],
              ),
              
              SizedBox(height: 20.h),
              
              // Resend Button
              TextButton(
                onPressed: _start == 0
                    ? () {
                        startTimer(); // Restart the timer when Resend is clicked
                        // Handle the OTP resend logic here
                        print("Resend OTP");
                      }
                    : null, // Disable button while countdown is running
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: _start == 0
                        ? Colors.blueAccent
                        : Colors.grey, // Change color based on timer
                  ),
                ),
              ),
              
              SizedBox(height: 40.h),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cc.purplecolor.value,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                    // Handle continue button logic
                    print('Continue pressed with PIN: ${pinController.text}');
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
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
