import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/call_settings_controller.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_textfield.dart';
import 'package:itp_voice/widgets/phone_number_field.dart';

class CallSettingsScreen extends StatefulWidget {
  CallSettingsScreen({super.key});

  @override
  State<CallSettingsScreen> createState() => _CallSettingsScreenState();
}

class _CallSettingsScreenState extends State<CallSettingsScreen> {
  CallSettingsController con = Get.put(CallSettingsController());
  ColorController cc = Get.find<ColorController>();
  
  @override
  void initState() {
    // TODO: implement initState
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
            "Call Forwarding",
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
                            Center(
                              child: Container(
                                width: 270.w,
                                child: Text(
                                  "Adjust call forwarding settings for direct calls or queue calls",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: cc.minitxt.value),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Enable Call Forwarding",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(() => FlutterSwitch(
                                      height: 22.h,
                                      width: 50.w,
                                      activeColor: cc.purplecolor.value,
                                      padding: 0,
                                      value: con.callForwarding.value,
                                      onToggle: (val) {
                                        con.callForwarding.value = val;
                                        con.setEnableCallForwarding(
                                            "callforward_enable",
                                            con.callForwarding.value);
                                      },
                                    )),
                              ],
                            ),
                            Obx(() => con.callForwarding.value
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Number or extension to forward calls to",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: cc.minitxt.value,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      AppTextField(
                                          textController: con.numberController,
                                          borderRadius: 8,
                                          hint: "+1xxxxxxxx33"),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (con.validate(
                                              con.numberController.text)) {
                                            con.setCallForwardingNumber(
                                                con.numberController.text);
                                          } else {}
                                        },
                                        child: Text(
                                          "Save Number",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                cc.purplecolor.value),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Forward Direct Calls\n(Ignore queues, ring groups,etc)",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              // fontWeight: FontWeight.bold,
                                              color: cc.minitxt.value,
                                            ),
                                          ),
                                          Obx(() => FlutterSwitch(
                                                height: 22.h,
                                                width: 50.w,
                                                activeColor:
                                                    cc.purplecolor.value,
                                                padding: 0,
                                                value: con
                                                    .forwardDirectCallsOnly
                                                    .value,
                                                onToggle: (val) {
                                                  con.forwardDirectCallsOnly
                                                      .value = val;
                                                  con.setEnableCallForwarding(
                                                      "callforward_queue_calls",
                                                      con.forwardDirectCallsOnly
                                                          .value);
                                                },
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Keep original caller-ID",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              // fontWeight: FontWeight.bold,
                                              color: cc.minitxt.value,
                                            ),
                                          ),
                                          Obx(() => FlutterSwitch(
                                                height: 22.h,
                                                width: 50.w,
                                                activeColor:
                                                    cc.purplecolor.value,
                                                padding: 0,
                                                value: con
                                                    .keepOriginalCallerId.value,
                                                onToggle: (val) {
                                                  con.keepOriginalCallerId
                                                      .value = val;
                                                  con.setEnableCallForwarding(
                                                      "callforward_keep_caller_caller_id",
                                                      con.keepOriginalCallerId
                                                          .value);
                                                },
                                              )),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(
                                  margin: EdgeInsets.symmetric(horizontal: 19.w,vertical: 24.h),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline),
                                        SizedBox(width: 28.w),
                                        Container(
                                          width: 270.w,
                                          height: 80.h,
                                          child: Text(
                                              "Enabling this option will forward any incoming calls to your user and will not ring any of your devices, including the web phone",),
                                        )
                                      ],
                                    ),
                                  )),
                            SizedBox(
                              height: 10.h,
                            ),
                            const Divider(),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
