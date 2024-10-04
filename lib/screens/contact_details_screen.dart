import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/base_screen_controller.dart';
import 'package:itp_voice/controllers/contacts_controller.dart';
import 'package:itp_voice/controllers/messages_controller.dart';
import 'package:itp_voice/controllers/tag_list_controller.dart';
import 'package:itp_voice/models/contact_list_data_model.dart';
import 'package:itp_voice/models/tag_model.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/add_contact_tag.dart';
import 'package:itp_voice/screens/add_tag_screen.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/search_textfield.dart';
import 'package:itp_voice/widgets/text_container.dart';
import 'package:itp_voice/temp_data.dart' as repo;

import '../models/get_contacts_reponse_model/contact_response.dart';

class ContactDetailsScreen extends StatefulWidget {
  const ContactDetailsScreen({
    super.key,
  });

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  Contact? contact;
  BaseScreenController baseController = Get.find<BaseScreenController>();
  ContactsController con = Get.find<ContactsController>();
  ColorController cc = Get.find<ColorController>();
  MessagesController conn = Get.put(MessagesController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contact = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: con,
        builder: (ContactsController value) {
          return Scaffold(
            backgroundColor: cc.bgcolor.value,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: Container(
                margin: EdgeInsets.only(top: 10.h, left: 15.w),
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios,
                        color: cc.iconcolor.value, size: 22.sp)),
              ),
              actions: [
                PopupMenuButton<String>(
                  color: cc.tabcolor.value, // Dark background color
                  onSelected: (String value) {
                    if (value == 'edit') {
                      // Perform the edit action
                      Get.toNamed(Routes.EDIT_CONTACT_ROUTE,
                          arguments: {'contact': contact!});
                    } else if (value == 'delete') {
                      // Show the confirmation dialog before deleting
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor:
                                cc.tabcolor.value, // Dark background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // Rounded corners
                            ),
                            title: Center(
                              child: Text(
                                "Delete Contact",
                                style: TextStyle(
                                    color:
                                        cc.minitxt.value), // White text color
                              ),
                            ),
                            content: Text(
                              "Are You Sure?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: cc
                                      .minitxt.value), // Light gray text color
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: cc.txtcolor
                                            .value, // White text color for "No"
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: cc.purplecolor
                                          .value, // Purple background for "Yes"
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8), // Rounded button
                                      ),
                                    ),
                                    child: Text("Yes"),
                                    onPressed: () {
                                      // Perform the delete action
                                      con.deleteContact(contact!.pk);
                                      Navigator.of(context)
                                          .pop(); // Close the dialog after deleting
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit',
                            style: TextStyle(
                                fontSize: 18.sp, color: cc.txtcolor.value)),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete',
                            style: TextStyle(
                                fontSize: 18.sp, color: cc.txtcolor.value)),
                      ),
                    ];
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: cc.iconcolor.value,
                  ),
                )
              ],
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  "Contact Details",
                  style: TextStyle(
                    color: cc.txtcolor.value,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: 0,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                          radius: 50.h,
                          backgroundColor: cc.purplecolor.value,
                          child: Icon(Icons.person,
                              size: 70.h, color: Colors.white)),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        "${contact!.firstname} ${contact!.lastname}",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Divider(
                      color: Color.fromARGB(255, 158, 158, 158),
                      indent: 10.w,
                      endIndent: 10.w,
                    ),
                    ListView.builder(
                      itemCount: 1, //contact!.numbers!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 20.w,
                                    right: 20.w,
                                    top: 10.h,
                                    bottom: 10.h),
                                tileColor: cc.tabcolor.value,
                                title: GestureDetector(
                                  onLongPress: () {
                                    if (contact!.phone != null &&
                                        contact!.phone!.isNotEmpty) {
                                      Clipboard.setData(
                                          ClipboardData(text: contact!.phone!));
                                      Get.snackbar('Copied',
                                          'Phone number copied to clipboard',
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  },
                                  onDoubleTap: () {
                                    if (contact!.phone != null &&
                                        contact!.phone!.isNotEmpty) {
                                      Clipboard.setData(
                                          ClipboardData(text: contact!.phone!));
                                      Get.snackbar('Copied',
                                          'Phone number copied to clipboard',
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  },
                                  child: Text(
                                    contact!.phone ?? '',
                                    style: TextStyle(
                                      color: cc.txtcolor.value,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                dense: true,
                                trailing: SizedBox(
                                  // color: Colors.blue,
                                  width: 100.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          baseController.handleCall(
                                              contact!.phone!, context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(7.h),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                            color: Color.fromARGB(
                                                255, 76, 175, 80),
                                          ),
                                          child: SizedBox(
                                            height: 22.h,
                                            width: 22.h,
                                            child: Icon(Icons.call,
                                                color: Colors.white,
                                                size: 22.sp),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print(
                                              "_______________________________" +
                                                  contact!.phone!);
                                          conn.sendNewMessage(context,
                                              numberr: contact!.phone);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(7.h),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(50),
                                              ),
                                              color: Color.fromARGB(
                                                  255, 76, 175, 80)),
                                          child: SizedBox(
                                            height: 22.h,
                                            width: 22.h,
                                            child: Icon(Icons.message,
                                                color: Colors.white,
                                                size: 22.sp),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 20.w,
                                    right: 20.w,
                                    top: 10.h,
                                    bottom: 10.h),
                                tileColor: cc.tabcolor.value,
                                title: GestureDetector(
                                  onLongPress: () {
                                    if (contact!.email != null &&
                                        contact!.email!.isNotEmpty) {
                                      Clipboard.setData(
                                          ClipboardData(text: contact!.email!));
                                      Get.snackbar('Copied',
                                          'Phone number copied to clipboard',
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  },
                                  onDoubleTap: () {
                                    if (contact!.email != null &&
                                        contact!.email!.isNotEmpty) {
                                      Clipboard.setData(
                                          ClipboardData(text: contact!.email!));
                                      Get.snackbar('Copied',
                                          'Phone number copied to clipboard',
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  },
                                  child: Text(
                                    "Email: ${contact!.email}",
                                    style: TextStyle(
                                      color: cc.txtcolor.value,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                dense: true,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.purple, // Purple button color
                            ),
                            onPressed: () {
                              // Navigate to AddTagScreen and handle tag addition
                              Get.to(() => AddTag(
                                    cont: contact,
                                  ));
                            },
                            child: Text("Edit Tag",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20.h,
                    ),
                    Text("Tags"),
                    SizedBox(
                      height: 10.h,
                    ),
                    //list tags
                    Wrap(
                      children: List.generate(
                        contact!.tags!.length,
                        (index) {
                          return Chip(
                              label:
                                  Text(contact!.tags![index].tag.name ?? ''),
                                  backgroundColor: hexToColor(contact!.tags![index].tag.tagColor ?? '#FFFFFF'),

                                  );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
    Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
