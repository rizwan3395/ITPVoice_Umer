import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:itp_voice/screens/colors.dart';

class AppButton extends StatelessWidget {
  ColorController cc = Get.find<ColorController>();
  String? text;
  AppButton({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57.h,
      
      padding: EdgeInsets.symmetric(vertical: 12.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(14.r),
        ),
        color: cc.purplecolor.value,
        
        // gradient: LinearGradient(
        //   colors: [
        //     Theme.of(context).colorScheme.primary.withOpacity(0.7),
        //     Theme.of(context).colorScheme.primary,
        //   ],
        // ),
      ),
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
