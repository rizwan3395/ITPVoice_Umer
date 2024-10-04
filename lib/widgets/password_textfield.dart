import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/settings_controller.dart';

import '../repo/shares_preference_repo.dart';
import '../screens/colors.dart';
import '../storage_keys.dart';

class PasswordTextField extends StatefulWidget {
  TextEditingController? textController;
  String? hint;
  double borderRadius = 10;
  PasswordTextField({
    super.key,
    @required this.textController,
    this.hint,
  });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObsecure = true;
  final double borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    ColorController con = Get.put(ColorController());
    return TextField(
      controller: widget.textController,
      obscureText: isObsecure,
      style: TextStyle(color: con.txtcolor.value),
      decoration: InputDecoration(
        filled: true,
        fillColor: con.textfcolor.value,
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 12.w,
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(color: con.minitxt.value, fontSize: 14.sp),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isObsecure = !isObsecure;
            });
          },
          child: Icon(isObsecure ? Icons.visibility : Icons.visibility_off ,
              color: con.iconcolor.value),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 232, 240, 254),
              width: 1), // Change the color and width for visibility
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius,
            ),
          ),
        ),


        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 232, 240, 254),
              width: 0.5), // Change the color and width for visibility
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius,
            ),
          ),
        ),


        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 232, 240, 254),
              width: 0.5), // Default border style
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius,
            ),
          ),
        ),
      ),
    );
  }
}
