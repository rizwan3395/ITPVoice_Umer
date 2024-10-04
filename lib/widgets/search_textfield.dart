import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../screens/colors.dart';

class Searchbar extends StatelessWidget {
  TextEditingController? controller;
  Function? onChanged;
  Searchbar({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();
    return Container(
      padding: EdgeInsets.all(12.h),
      // margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 246, 247, 249),
        border: Border.all(color: const Color.fromARGB(255, 158, 158, 158),width: 0.5.w),
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          Image.asset("assets/images/search.png"),
          // Icon(
          //   Icons.search_rounded,
          //   color: Colors.grey.shade600,
          //   size: 24.w,
          // ),
          SizedBox(
            width: 10.w,
          ),
          SizedBox(
            width: 250.w,
            child: TextField(
              onChanged: (value) => onChanged!(value),
              controller: controller,
              style: TextStyle(color: cc.txtcolor.value),
              decoration: InputDecoration.collapsed(
                hintText: "Search",
                hintStyle: TextStyle(fontSize: 16.w, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
