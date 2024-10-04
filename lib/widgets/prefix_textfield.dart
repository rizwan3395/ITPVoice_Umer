import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/screens/colors.dart';

class AppTextFieldWPrefix extends StatelessWidget {
  TextEditingController? textController;
  String? hint;
  bool isReadOnly;
  double? borderRadius;
  Widget? sufixIcon;
  TextAlign? textAlign;
  TextInputType keyboardType;

  AppTextFieldWPrefix(
      {super.key,
      @required this.textController,
      @required this.borderRadius = 10,
      @required this.hint,
      @required this.sufixIcon,
      @required this.isReadOnly = false,
      @required this.textAlign = TextAlign.left,
      @required this.keyboardType = TextInputType.name});

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();
    return TextField(
      
      readOnly: isReadOnly,
      textAlign: textAlign!,
      style: TextStyle(color: cc.txtcolor.value, fontSize: 14.sp),
      controller: textController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: cc.tabcolor.value,
        prefixIcon: sufixIcon ?? Container(),
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 12.w,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xff838799), fontSize: 14.sp),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius!,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius!,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
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
