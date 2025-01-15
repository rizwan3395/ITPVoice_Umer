import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/edit_contact_controller.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_button.dart';
import 'package:itp_voice/widgets/app_textfield.dart';
import 'package:itp_voice/widgets/phone_number_field.dart';

class EditContactScreen extends StatelessWidget {
  EditContactScreen({super.key});

  EditContactController con = Get.put(EditContactController());
  ColorController cc = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: _buildBackButton(context),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: _buildAppBarTitle(context, "Edit Contact"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  _buildTextLabel(context, "First Name"),
                  SizedBox(height: 8.h),
                  AppTextField(
                    textController: con.firstNameController,
                    hint: "Jhon",
                  ),
                  SizedBox(height: 32.h),
                  _buildTextLabel(context, "Last Name"),
                  SizedBox(height: 8.h),
                  AppTextField(
                    textController: con.lastNameController,
                    hint: "Doe",
                  ),
                  SizedBox(height: 30.h), 
                  _buildPhoneNumberSection(context),
                  SizedBox(height: 8.h),
                  GetBuilder<EditContactController>(
                    init: con,
                    builder: (EditContactController value) {
                      return _buildContactList(value);
                    },
                  ),
                  SizedBox(height: 32.h),
                  _buildTextLabel(context, "Email"),
                  SizedBox(height: 8.h),
                  GetBuilder<EditContactController>(
                    init: con,
                    builder: (EditContactController value) {
                      return _buildEmailList(value);
                    },
                  ),
                  SizedBox(height: 40.h),
                  GestureDetector(
                    onTap: () {
                      con.saveContact();
                    },
                    child: AppButton(text: "Update"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: cc.iconcolor.value,
          size: 18.sp,
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.only(top: 10.h),
      child: Text(
        title,
        style: TextStyle(
          color: cc.txtcolor.value,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextLabel(BuildContext context, String label) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              color: cc.minitxt.value,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Phone Number",
                style: TextStyle(
                  color: cc.minitxt.value,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactList(EditContactController value) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 5.h),
      shrinkWrap: true,
      itemCount: value.contactFieldsData.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                PhoneNumberField(
                  textController: value.contactFieldsData[index]['controller'],
                  hint: "xxx xxxxxxxx",
                  onChanged: (val) {
                    value.contactFieldsData[index]['code'] = val;
                  },
                ),
                if (index != 0)
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        value.removeContactField(index);
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cc.tabcolor.value,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 15.sp,
                          color: cc.iconcolor.value,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5.h),
          ],
        );
      },
    );
  }

  Widget _buildEmailList(EditContactController value) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 5.h),
      shrinkWrap: true,
      itemCount: value.emailFieldsData.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppTextField(
                  hint: "john@abc.com",
                  textController: value.emailFieldsData[index]['controller'],
                ),
                if (index != 0)
                  Positioned(
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        value.removeEmailField(index);
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cc.tabcolor.value,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 15.sp,
                          color: cc.iconcolor.value,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5.h),
          ],
        );
      },
    );
  }
}
