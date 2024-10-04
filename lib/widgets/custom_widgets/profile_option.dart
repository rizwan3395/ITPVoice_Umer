import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/screens/colors.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;
  final String text;
  bool isSetting ;
  EdgeInsetsGeometry padding = EdgeInsets.symmetric(vertical:25.h, horizontal: 10.w);
  EdgeInsetsGeometry settingPadding = EdgeInsets.symmetric(vertical:10.h, horizontal: 10.w);
  ProfileOption(
      {super.key, required this.text, required this.onTap, required this.icon,required this.isSetting});
  ColorController cc = Get.find<ColorController>();
  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: onTap,
      child: Container(

        padding: isSetting == true ? settingPadding : padding,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10.w),
              height: 50,
              width: 50,
              child: Icon(
                icon,
                color:cc.minitxt.value,
                size: 25.h,
              ),
            ),
            SizedBox(
              width: 32.w,
            ),
            Text("$text",style: TextStyle(color: cc.minitxt.value,fontSize: 16.sp),),
            
          ],
        ),
      ),
    );
  }
}
