import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  String? text;
  AppButton({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15.r),
        ),
        color: Color.fromARGB(255,109, 40, 217),
        
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
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
