import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextBox extends StatelessWidget {
  String text;
  double? height;
  double? width;
  double? singleCharFontSize;
  double? doubleCharFontSize;
  TextBox({
    super.key,
    required this.text,
    this.height,
    this.width,
    this.singleCharFontSize,
    this.doubleCharFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50.h,
      width: width ?? 50.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xffF5F8FF),
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xff2960EC),
          fontWeight: FontWeight.bold,
          fontSize: text.length > 1
              ? doubleCharFontSize ?? 17.sp
              : singleCharFontSize ?? 24.sp,
        ),
      ),
    );
  }
}
