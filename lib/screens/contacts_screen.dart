import 'dart:math';

import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/call_history_controller.dart';
import 'package:itp_voice/controllers/contacts_controller.dart';
import 'package:itp_voice/repo/call_history_repo.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/add_new_contact.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/storage_keys.dart';
import 'package:itp_voice/widgets/contact_list_shimmer.dart';
import 'package:itp_voice/widgets/search_textfield.dart';
import 'package:itp_voice/widgets/text_container.dart';
import 'package:itp_voice/temp_data.dart' as repo;

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

final List<AlphabetListViewItemGroup> animals = [
  for (var animalLetter in repo.animals.entries)
    AlphabetListViewItemGroup(
      tag: animalLetter.key,
      children: animalLetter.value
          .map(
            (animal) => GestureDetector(
              onTap: () {
                Get.toNamed(Routes.CONTACT_DETAIS_SCREEN_ROUTE);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 25.h,
                      width: 25.h,
                      color: Colors.green,
                      child: const Icon(
                        Icons.person_2_rounded,
                        color: Colors.white,
                      ),
                    ),
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
                                  animal,
                                  // style: ts(1, 0xff1B1A57, 14.sp, 5),
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ),
];

class _ContactsScreenState extends State<ContactsScreen> {
  ContactsController con = Get.put(ContactsController());
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    con.fetchContacts(
      '0',
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (con.totalPages.value > con.currentPage.value) {
          con.fetchContacts(con.conOffSet.value.toString());
        }
      }
    });
  }

  Color generateMidToneColor() {
    final Random random = Random();

    // Generate RGB values between 120 and 200 for decent and non-straining colors
    // Generate RGB values in a broader but controlled range for vibrancy and variation
    int red =
        180 + random.nextInt(156); // Range from 100 to 255 for good vibrancy
    int green = 100 + random.nextInt(156); // Same range for green
    int blue = 170 + random.nextInt(156); // Same range for blue

    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();

    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      // floatingActionButton: SizedBox(
      //   height: 50.h,
      //   width: 50.h,
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       Get.toNamed(Routes.ADD_NEW_CONTACT_ROUTE);
      //       // con.fetchContacts();
      //       // SharedPreferencesMethod.storage
      //       //     .setString(StorageKeys.REFRESH_TOKEN, "asdfadfasdfasdfa");
      //     },
      //     backgroundColor: Colors.transparent,
      //     shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(
      //         Radius.circular(6),
      //       ),
      //     ),
      //     child: Container(
      //       height: 50.h,
      //       width: 50.h,
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(colors: [
      //           Theme.of(context).colorScheme.primary.withOpacity(0.7),
      //           Theme.of(context).colorScheme.primary,
      //         ]),
      //         borderRadius: BorderRadius.circular(6),
      //       ),
      //       child: const Icon(
      //         Icons.add,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 18.w, top: 13.h),
          child: PopupMenuButton(
            color: cc.tabcolor.value,
            onSelected: (value) {
              if (value == 'contact_list') {
                Get.toNamed(Routes.CONTACTS_LIST_SCREEN_ROUTE);
              } else if (value == 'tags') {
                Get.toNamed(Routes.TAGS_SCREEN_ROUTE);
              }
            },
            
            itemBuilder: (BuildContext context) {
            
            return <PopupMenuEntry<String>>[
              
              PopupMenuItem<String>(
                
                value: 'contact_list',
                child: Text(
                  'Contact List',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: cc.txtcolor.value,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'tags',
                child: Text(
                  'Tags',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: cc.txtcolor.value,
                  ),
                ),
              ),
            ];
          }, icon: Icon(Icons.menu, color: cc.txtcolor.value,size: 25.sp,)),
        ),
        actions: [
          // Button color

          Container(
            margin: EdgeInsets.only(right: 22.w, top: 10.h),
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled:
                      true, // To allow full-screen height if needed
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.9,
                      expand: false,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Container(
                          color: cc.bgcolor.value,
                          padding: EdgeInsets.all(0),
                          height: MediaQuery.of(context).size.height *
                              0.8, // Adjustable height
                          child:
                              AddNewContactScreen(), // Your page content here
                        );
                      },
                    );
                  },
                );
                // _openAddNewContact(context);
              },
              icon: Icon(Icons.add, size: 16), // Add icon
              label: Text("Add"), // Add text
              style: ElevatedButton.styleFrom(
                backgroundColor: cc.purplecolor.value,
                foregroundColor: Colors.white, // Button color
                minimumSize: Size(80.w, 32.h), // Button width and height

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3), // Rounded corners
                ),
              ),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            "Contacts",
            style: TextStyle(
              color: cc.txtcolor.value,
              fontSize: 18.sp ,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: GetBuilder<ContactsController>(
          init: con,
          builder: (ContactsController value) {
            return SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 19.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 0,
                        ),
                        // SizedBox(
                        //   height: 20.h,
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Searchbar(
                            controller: value.searchController,
                            onChanged: (val) {
                              print('-------->>>>$val');
                              con.searchContacts("0".toString(), val);
                              // value.update();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          // padding: EdgeInsets.symmetric(horizontal: 20.w),
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: value.isContactsLoading
                              ? const ContactListShimmer()
                              : ListView.builder(
                                  controller: _scrollController,
                                  itemCount: con.getDataList().length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < con.getDataList().length) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              Routes
                                                  .CONTACT_DETAIS_SCREEN_ROUTE,
                                              arguments:
                                                  con.getDataList()[index]);
                                        },
                                        child: Container(
  margin: EdgeInsets.symmetric(vertical: 1.h),
  decoration: const BoxDecoration(
    border: Border(
      top: BorderSide(
        color: Color.fromARGB(255, 222, 226, 230),
        width: 0.3,
      ),
    ),
  ),
  padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: generateMidToneColor(),
        ),
        child: const Icon(
          Icons.person_2_outlined,
          color: Colors.white,
        ),
      ),
      SizedBox(width: 27.w),
      Expanded( // Use Expanded here to take up remaining space
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( // Make the name text expand to fill available space
              child: Text(
                "${con.getDataList()[index].firstname!} ${con.getDataList()[index].lastname!}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: cc.txtcolor.value,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Container(
              width: 20.w,
              child: PopupMenuButton<String>(
                color: cc.tabcolor.value, // Dark background color
                onSelected: (String value) {
                  if (value == 'edit') {
                    // Perform the edit action
                    Get.toNamed(Routes.EDIT_CONTACT_ROUTE, arguments: {
                      'contact': con.getDataList()[index]
                    });
                  } else if (value == 'delete') {
                    // Show the confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: cc.tabcolor.value,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          title: Center(
                            child: Text(
                              "Delete Contact",
                              style: TextStyle(color: cc.minitxt.value),
                            ),
                          ),
                          content: Text(
                            "Are You Sure?",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: cc.minitxt.value),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      color: cc.txtcolor.value,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cc.purplecolor.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text("Yes", style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    // Perform the delete action
                                    con.deleteContact(con.getDataList()[index]!.pk);
                                    Navigator.of(context).pop(); // Close the dialog after deleting
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
                      child: Text('Edit', style: TextStyle(fontSize: 18.sp, color: cc.txtcolor.value)),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(fontSize: 18.sp, color: cc.txtcolor.value)),
                    ),
                  ];
                },
                icon: Icon(Icons.more_vert, color: cc.txtcolor.value),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)

                                      );
                                    } else {
                                      return con.totalPages.value >
                                              con.currentPage.value
                                          ? const Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20),
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 60),
                                                ],
                                              ),
                                            )
                                          : const SizedBox();
                                    }
                                  }),
                        )
                      ])),
            );
          }),
    );
  }
}
