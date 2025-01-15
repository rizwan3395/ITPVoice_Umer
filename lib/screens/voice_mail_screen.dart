import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/voicemails_controller.dart';
import 'package:itp_voice/models/get_voice_mails_response_model/result.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/search_textfield.dart';
import 'package:itp_voice/widgets/voice_mails_shimmer.dart';

class VoiceMailScreen extends StatelessWidget {
  VoiceMailScreen({super.key});

  VoiceMailsController con = VoiceMailsController();
  ColorController cc = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cc.bgcolor.value,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            "Voicemail",
            style: TextStyle(
              color: cc.txtcolor.value,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: GetBuilder<VoiceMailsController>(
        init: con,
        builder: (VoiceMailsController value) {
          // Group voicemails by caller name
          Map<String, List<VoiceMails>> groupedVoicemails = {};
          for (var voicemail in value.getDataList()) {
            String callerName = voicemail.callerid!
                .split("<")[0]
                .replaceAll('"', ""); // Extract caller name
            if (!groupedVoicemails.containsKey(callerName)) {
              groupedVoicemails[callerName] = [];
            }
            groupedVoicemails[callerName]!.add(voicemail);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  const Divider(
                    height: 0,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Searchbar(
                    controller: value.searchController,
                    onChanged: (val) {
                      value.update();
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  value.isVoiceMailsLoading
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.64,
                          child: const VoiceMailsShimmer(),
                        )
                      : groupedVoicemails.isEmpty // Check if the result is empty
                          ? Center( // Show message if no voicemails are found
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Text(
                                  "There are no Voicemails",
                                  style: TextStyle(
                                    color: cc.txtcolor.value,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: groupedVoicemails.keys.length,
                                  itemBuilder: (context, index) {
                                    String callerName = groupedVoicemails.keys.elementAt(index);
                                    List<VoiceMails> voicemails = groupedVoicemails[callerName]!;

                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.VOICE_MAIL_DETAILS_ROUTE,
                                            arguments: {'voicemails': voicemails});
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          color: cc.tabcolor.value,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: 10.h),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: cc.tabcolor.value,
                                                      borderRadius: BorderRadius.circular(50),
                                                      border: Border.all(color: cc.tabcolor.value)),
                                                  padding: EdgeInsets.all(10.w),
                                                  child: Icon(Icons.voicemail),
                                                ), // Initial of caller
                                                SizedBox(width: 15.w),
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            callerName,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15.sp,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 3.h),
                                                      SizedBox(
                                                        width: 215.w,
                                                        child: Text(
                                                          voicemails.first.usertime!
                                                                  .split(" ")[0] +
                                                              " | " +
                                                              voicemails.first.usertime!
                                                                  .split(" ")[1],
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              color: cc.minitxt.value),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
