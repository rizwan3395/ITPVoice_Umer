import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:itp_voice/controllers/base_screen_controller.dart';

class ListTTile extends StatelessWidget {
  final String? name;
  final bool? isIncoming;
  final bool? isMissed;
  final DateTime? time;
  final String? numberToDial;

  const ListTTile({
    super.key,
    required this.name,
    required this.isIncoming,
    required this.isMissed,
    required this.time,
    required this.numberToDial,
  });

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();
    BaseScreenController baseController = Get.find<BaseScreenController>();
    return Container(
      height: 80.h, // Adjust height as needed
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(width: 0.5,color: Color.fromARGB(255,222, 226, 230)))
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading profile icon
            Container(
              height: 62, // Adjust as needed
              width: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                // border: Border.all(width: 2),
                color: cc.purplecolor.value,
              ),
              child: Image.asset("assets/images/contactProfile.png" ,), // You can replace this with actual profile image logic
            ),
            SizedBox(width: 20.w), // Space between image and text

            // Text and subtitle section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name or title
                  Text(
                    name ?? "", // Use the passed name parameter
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Row for call type and label (incoming, outgoing, missed)
                  Row(
                    children: [
                      isIncoming! && isMissed!
                            ? Icon(Icons.call_missed, size: 18.sp,color: const Color.fromARGB(255,220, 53, 69))
                            : isIncoming! && !isMissed!
                                ? Icon(Icons.call_received, size: 18.sp,color: const Color.fromARGB(255,55, 163, 222))
                                : Icon(Icons.call_made,size: 18.sp,color: const Color.fromARGB(255,76, 175, 80),),
                                
                        
                      SizedBox(width: 9.w),
                      Text(
                        "Mobile", // You can modify this as needed
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isIncoming! && isMissed!
                            ?  const Color.fromARGB(255,220, 53, 69)
                            : isIncoming! && !isMissed!
                                ? const Color.fromARGB(255,55, 163, 222)
                                :  const Color.fromARGB(255,76, 175, 80),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w), // Space between text and trailing section

            // Trailing section with time and dial button
            SizedBox(
              height: 40.h,
              width: 140.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Display time ago using timeago
                  Text(
                    timeago.format(time!), // Use the passed time parameter
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // Dial button
                  GestureDetector(
                    onTap: () {
                      baseController.handleCall(numberToDial!, context);
                    },
                    child: SizedBox(
                      height: 20.h,
                      child: Icon(
                        Icons.call,
                        size: 20.sp,
                        color: cc.iconcolor.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
