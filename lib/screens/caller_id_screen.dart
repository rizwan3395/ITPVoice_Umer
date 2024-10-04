import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/call_settings_controller.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_textfield.dart';

import '../controllers/messages_controller.dart';

class CallerIdScreen extends StatefulWidget {
  CallerIdScreen({super.key});

  @override
  State<CallerIdScreen> createState() => _CallerIdScreenState();
}

class _CallerIdScreenState extends State<CallerIdScreen> {
  CallSettingsController con = Get.put(CallSettingsController());
  ColorController cc = Get.find<ColorController>();
  MessagesController mcon = Get.put(MessagesController());
  TextEditingController numberController = TextEditingController();
  List numbers = []; 

  @override
  void initState() {
    super.initState();
    con.getSettings();
    numbers =
        mcon.numbers;
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
            "Caller Id",
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
                                  "Adjust your outbound caller ID settings when placing calls",
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
                                  "Override Default Caller ID Settings",
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
                                    value: con.overrideDefaultCallerIdSettings,
                                    onToggle: (val) {
                                      con.overrideDefaultCallerIdSettings = val;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Obx(() => con.overrideDefaultCallerIdSettings
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Caller ID Name",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: cc.minitxt.value,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " *",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      AppTextField(
                                        hint: "John Doe",
                                        textController:
                                            con.callerNameController,
                                        
                                            
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Caller ID Number",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: cc.minitxt.value,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " *",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      // Dropdown for Caller ID Number
                                      DropdownButtonFormField<String>(
                                        value: numbers.isNotEmpty
                                            ? numbers[0]
                                            : null,
                                        items: numbers
                                            .map<DropdownMenuItem<String>>(
                                          (number) {
                                            return DropdownMenuItem<String>(
                                              value: number,
                                              child: Text(number),
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (newValue) {
                                          con.callerNnumberController.text =
                                              newValue ?? "";
                                          
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Select a phone number',
                                          hintStyle: TextStyle(color: cc.minitxt.value),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 12.w),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.info_outline),
                                          SizedBox(width: 5.w,),
                                          Container(
                                            width: 200.w,
                                            child: Text(
                                                "The data would not save until you press the save button",style: TextStyle(color: cc.txtcolor.value),),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h,),
                                      Center(
                                          child: ElevatedButton(
                                        onPressed: () {
                                          con.updateOverriddenCallerData();
                                          con.setCallerId();
                                          
                                        },
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(backgroundColor: cc.purplecolor.value),
                                      ))
                                    ],
                                  )
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 19.w, vertical: 24.h),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline),
                                        SizedBox(width: 28.w),
                                        Container(
                                          width: 270.w,
                                          height: 80.h,
                                          child: Text(
                                            "Enabling this option will force your devices to use a specific phone number when placing a call",
                                          ),
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
