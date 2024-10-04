import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/call_settings_controller.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_textfield.dart';

import '../controllers/messages_controller.dart';

class VoiceMailSettingScreen extends StatefulWidget {
  VoiceMailSettingScreen({super.key});

  @override
  State<VoiceMailSettingScreen> createState() => _VoiceMailSettingScreenState();
}

class _VoiceMailSettingScreenState extends State<VoiceMailSettingScreen> {
  CallSettingsController con = Get.put(CallSettingsController());
  ColorController cc = Get.find<ColorController>();

  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    con.getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(top: 10.h, left: 0.w),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
              color: cc.iconcolor.value,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            "Voice Mail",
            style: TextStyle(
              color: cc.txtcolor.value,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Obx(
        () => con.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      const Divider(
                        height: 0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Voicemail",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: cc.txtcolor.value,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => FlutterSwitch(
                                    height: 22.h,
                                    width: 50.w,
                                    activeColor: cc.purplecolor.value,
                                    padding: 0,
                                    value: con.voiceMail.value,
                                    onToggle: (val) {
                                      print(
                                          "-__________________________________----------------");
                                      print(val);
                                      con.voiceMail.value = val;
                                      con.setEnableVoice(
                                          "sendvoicemail",
                                          val ? "enabled" : "disabled");
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 19.w, vertical: 24.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline),
                                  SizedBox(width: 28.w),
                                  Expanded(
                                    child: Text(
                                      "Send email when a voicemail is received to your direct mailbox",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: cc.minitxt.value),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delete Voicemail",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: cc.txtcolor.value,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => FlutterSwitch(
                                    height: 22.h,
                                    width: 50.w,
                                    activeColor:
                                        cc.purplecolor.value,
                                    padding: 0,
                                    value: con.deleteVoiceMail.value,
                                    onToggle: (val) {
                                      con.deleteVoiceMail.value = val;
                                      con.setEnableVoice(
                                          "deletevoicemail",
                                          val ? "yes" : "no");
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 19.w, vertical: 24.h),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline),
                                  SizedBox(width: 28.w),
                                  Expanded(
                                    child: Text(
                                      "Automatically delete messages when a user leaves a message from my mailbox.",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: cc.minitxt.value),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}





// Container(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 "Call Recording",
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 20.h,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Call Recording Internal",
//                                   style: TextStyle(
//                                       fontSize: 14.sp,
//                                       color:
//                                           Theme.of(context).colorScheme.tertiary
//                                       // fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                                 Obx(() => FlutterSwitch(
//                                       height: 22.h,
//                                       width: 50.w,
//                                       activeColor:
//                                           Theme.of(context).colorScheme.primary,
//                                       padding: 0,
//                                       value: con.callRecordingInternal.value,
//                                       onToggle: (val) {
//                                         con.callRecordingInternal.value = val;
//                                       },
//                                     )),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 20.h,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "Call Recording External",
//                                   style: TextStyle(
//                                       fontSize: 14.sp,
//                                       color:
//                                           Theme.of(context).colorScheme.tertiary
//                                       // fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                                 Obx(() => FlutterSwitch(
//                                       height: 22.h,
//                                       width: 50.w,
//                                       activeColor:
//                                           Theme.of(context).colorScheme.primary,
//                                       padding: 0,
//                                       value: con.callRecordingExternal.value,
//                                       onToggle: (val) {
//                                         con.callRecordingExternal.value = val;
//                                       },
//                                     )),
//                               ],
//                             ),