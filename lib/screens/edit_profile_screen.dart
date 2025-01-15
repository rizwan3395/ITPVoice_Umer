import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/profile_controller.dart';
import 'package:itp_voice/screens/colors.dart';
import '../routes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ColorController cc = Get.put(ColorController());
  ProfileController con = Get.put(ProfileController());

  List<String> timezone = [
    "US/Alaska",
    "US/Arizona",
    "US/Central",
    "US/Eastern",
    "US/Hawaii",
    "US/Indiana-Starke",
    "US/Michigan",
    "US/Mountain",
    "US/Pacific",
    "US/Samoa",
    "Asia/Kolkata",
    "Asia/Shanghai",
    "Asia/Tokyo",
    "Asia/Dubai",
    "Asia/Hong_Kong",
    "Asia/Singapore",
    "Asia/Seoul",
    "Europe/Berlin",
    "Europe/Madrid",
    "Europe/Paris",
    "Europe/Rome",
    "Europe/London",
    "Europe/Moscow",
    "America/Bogota",
    "America/Sao_Paulo", // Fixed typo from Sau_Paulo to Sao_Paulo
    "America/Toronto",
    "America/Mexico_City",
    "Africa/Cairo",
    "Africa/Johannesburg",
    "Australia/Sydney",
    "Australia/Perth",
    "Pacific/Auckland",
    "UTC"
  ];

  // Default selected timezone
  String? selectedTimezone;

  @override
  void initState() {
    super.initState();
    selectedTimezone = con.userProfile!.timeZone;
    con.timezone = selectedTimezone!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: cc.bgcolor.value,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Edit Profile"),
          backgroundColor: cc.bgcolor.value,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: cc.bgcolor.value,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 33.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "First Name",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppTextField(
                    textController: con.firstNameController,
                    hint: 'Fox',
                    borderRadius: 8.r,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Last Name",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppTextField(
                    textController: con.lastNameController,
                    hint: 'Red',
                    borderRadius: 8.r,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Phone",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppTextField(
                    textController: con.phoneController,
                    hint: '',
                    borderRadius: 8.r,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Mobile",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppTextField(
                    textController: con.mobileController,
                    hint: '',
                    borderRadius: 8.r,
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.only(bottom: 7.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "TimeZone",
                              style: TextStyle(
                                color: cc.minitxt.value,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedTimezone, // Set default value
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    items: timezone.map((String timeZone) {
                      return DropdownMenuItem<String>(
                        value: timeZone,
                        child: Text(timeZone),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedTimezone = newValue!;
                        con.timezone = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      if (con.validateForm()) {
                        con.updateProfile();
                      }
                      Get.back();
                    },
                    child: AppButton(
                      text: "Update Profile",
                    ),
                  ),
                  SizedBox(height: 20.h),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
