import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:shimmer/shimmer.dart';

class ContactListShimmer extends StatelessWidget {
  const ContactListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();
    return Shimmer.fromColors(
        baseColor: cc.tabcolor.value,
        highlightColor: cc.tabcolor.value==const Color.fromARGB(255,1, 47, 85) ?Color.fromARGB(255, 2, 65, 117):Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.only(
                bottom: 8.0.w, left: 20.w, right: 20.w, top: 20.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                SizedBox(
                  width: 200.w,
                  height: 20.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          itemCount: 5,
        ));
  }
}
