import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/settings_controller.dart';

import '../screens/colors.dart';

class AppTextField extends StatelessWidget {
  TextEditingController? textController;
  String? hint;
  IconData? iccon;
  bool isReadOnly;
  double? borderRadius;
  TextAlign? textAlign;
  Function(String)? onChanged;
  String? flagImage; // Path to the country flag image

  AppTextField({
    super.key,
    @required this.textController,
    @required this.borderRadius = 10,
    @required this.hint,
    @required this.isReadOnly = false,
    @required this.textAlign = TextAlign.left,
    this.iccon,
    this.onChanged,
    this.flagImage, // New flag image parameter
  });

  SettingsController con = Get.put(SettingsController());
  Color? dark = const Color.fromARGB(255, 0, 35, 64);
  Color? light = const Color.fromARGB(255, 232, 240, 254);
  ColorController cc = Get.put(ColorController());

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: isReadOnly,
      textAlign: textAlign!,
      style: TextStyle(color: cc.txtcolor.value),
      controller: textController,
      onChanged: onChanged,
      
      decoration: InputDecoration(
        filled: true,
        fillColor: con.isDark.value ? dark : light,
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 12.w,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: cc.minitxt.value, fontSize: 14.sp,fontWeight: FontWeight.w400,),
        prefixIcon: flagImage != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  flagImage!, // Flag image path
                  width: 30.w, // Adjust size accordingly
                  height: 30.h,
                ),
              )
            : null, // You can leave it null if you don't want a flag
        suffixIcon: Icon(iccon, color:cc.iconcolor.value),

        // Focused border - set a visible color here
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255,232, 240, 254), width: 1), // Change the color and width for visibility
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius!,
            ),
          ),
        ),

        // Enabled border - set a visible color here
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255,232, 240, 254), width: 0.5), // Change the color and width for visibility
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius!,
            ),
          ),
        ),

        // Default border (for when neither focused nor enabled)
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255,232, 240, 254), width: 0.5), // Default border style
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius!,
            ),
          ),
        ),
      ),
    );
  }
}
