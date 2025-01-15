import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itp_voice/repo/contacts_repo.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/base_screen_controller.dart';
import 'package:itp_voice/controllers/call_history_controller.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/call_history_shimmer.dart';
import 'package:itp_voice/widgets/custom_widgets/dialpad/flutter_dialpad.dart';
import 'package:itp_voice/widgets/search_textfield.dart';
import 'package:itp_voice/widgets/text_container.dart';
import 'package:itp_voice/temp_data.dart' as repo;

import '../widgets/custom_widgets/LisTTile.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  CallHistoryController con = Get.put(CallHistoryController());
  BaseScreenController baseController = Get.find<BaseScreenController>();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();
    return GetBuilder(
        init: con,
        builder: (CallHistoryController value) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: cc.bgcolor.value,
              floatingActionButton: SizedBox(
                height: 62.h,
                width: 62.h,
                child: FloatingActionButton(
                    backgroundColor: cc.purplecolor.value,
                    onPressed: () {
                      
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // This allows the bottom sheet to cover the full screen
                        backgroundColor: Colors
                            .transparent, // Transparent background to avoid rounded corners
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            initialChildSize:
                                1.0, // Full screen height initially
                            minChildSize:
                                0.3, // Minimum height when swiped down
                            maxChildSize: 1.0, // Maximum height
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                child: DialPad(
                                  enableDtmf: false,
                                  initialValue: '',
                                  outputMask: "00000000000",
                                  backspaceButtonIconColor: Colors.red,
                                  makeCall: (number) async {
                                    print(number);
                                    baseController.handleCall(number, context);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.dialpad,
                      size: 33.sp,
                    )),
              ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                // leading: Container(
                //   margin: EdgeInsets.only(top: 10.h, left: 0.w),
                //   child: GestureDetector(
                //       onTap: () {
                //         Get.back();
                //       },
                //       child: Icon(Icons.arrow_back_ios, color: AppTheme.colors(context)?.textColor, size: 18.sp)),
                // ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      showMenu(
                        color: cc.tabcolor.value,
                        context: context,
                        position: RelativeRect.fromLTRB(
                            100.w, 70.h, 0, 0), // Adjust position accordingly
                        items: [
                          PopupMenuItem(
                            value: 'clear_call_history',
                            child: Text(
                              "Clear Call History",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: cc.minitxt.value,
                              ),
                            ),
                          ),
                        ],
                      ).then((value) {
                        if (value == 'clear_call_history') {
                          Get.toNamed(Routes.CALL_HISTORY_SCREEN_ROUTE);
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.w, top: 10.h),
                      child: Icon(
                        Icons.more_vert,
                        color: cc.iconcolor.value,
                        size: 22.sp,
                      ),
                    ),
                  )
                ],
                elevation: 0,
                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                centerTitle: true,
                title: Container(
                  padding: EdgeInsets.only(top: 10.h),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () =>  con.refreshCallHistory(),
                child: SingleChildScrollView(
                  child: Container(
                      color: cc.bgcolor.value,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              height: 0,
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Searchbar(
                                controller: value.searchController,
                                onChanged: (val) {
                                  value.update();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: ButtonsTabBar(
                                // Customize the appearance and behavior of the tab bar
                                backgroundColor: cc.purplecolor.value,
                                unselectedBackgroundColor: cc.tabcolor.value,
                                radius: 50.r,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  color: cc.txtcolor.value,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                tabs: const [
                                  Tab(
                                    text: 'All', // Tab text for 'All'
                                  ),
                                  Tab(
                                    icon: Icon(
                                      Icons.call_missed,
                                      color: Colors.red,
                                    ),
                                    text: 'Missed', // Tab text for 'Missed'
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: SizedBox(
                                  // decoration:
                                  //     BoxDecoration(border: Border.all(width: 0.5)),
                                  height:
                                      MediaQuery.of(context).size.height * 0.699,
                                  child: TabBarView(children: [
                                    SingleChildScrollView(
                                      controller: con.scrollController,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          value.todayCallHistory.isEmpty
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          "Today",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                cc.txtcolor.value,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: value
                                                          .getDataList(
                                                              "today", false)
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTTile(
                                                          name: value
                                                              .getDataList(
                                                                  "today",
                                                                  false)[index]
                                                              .name,
                                                          isIncoming: value
                                                              .getDataList(
                                                                  "today",
                                                                  false)[index]
                                                              .isIncoming,
                                                          isMissed: value
                                                              .getDataList(
                                                                  "today",
                                                                  false)[index]
                                                              .isMissed,
                                                          time: value
                                                              .getDataList(
                                                                  "today",
                                                                  false)[index]
                                                              .time,
                                                          numberToDial: value
                                                              .getDataList(
                                                                  "today",
                                                                  false)[index]
                                                              .numberToDial,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          value
                                                      .getDataList(
                                                          "yesterday", false)
                                                      .length <
                                                  1
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          "Yesterday",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                cc.txtcolor.value,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: value
                                                          .getDataList(
                                                              "yesterday", false)
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTTile(
                                                          name: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  false)[index]
                                                              .name,
                                                          isIncoming: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  false)[index]
                                                              .isIncoming,
                                                          isMissed: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  false)[index]
                                                              .isMissed,
                                                          time: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  false)[index]
                                                              .time,
                                                          numberToDial: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  false)[index]
                                                              .numberToDial,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          value
                                                      .getDataList(
                                                          "earlier", false)
                                                      .length <
                                                  1
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          "Earlier",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                cc.txtcolor.value,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: value
                                                          .getDataList(
                                                              "earlier", false)
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTTile(
                                                          name: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  false)[index]
                                                              .name,
                                                          isIncoming: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  false)[index]
                                                              .isIncoming,
                                                          isMissed: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  false)[index]
                                                              .isMissed,
                                                          time: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  false)[index]
                                                              .time,
                                                          numberToDial: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  false)[index]
                                                              .numberToDial,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          value.isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                )
                                              : const SizedBox(),
                                          value.isLoading
                                              ? const CircularProgressIndicator()
                                              : const SizedBox(),
                                          value.isLoading
                                              ? const SizedBox(
                                                  height: 15,
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          value
                                                      .getDataList("today", true)
                                                      .length <
                                                  1
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          "Today",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                cc.txtcolor.value,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: value
                                                          .getDataList(
                                                              "today", true)
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTTile(
                                                          name: value
                                                              .getDataList(
                                                                  "today",
                                                                  true)[index]
                                                              .name,
                                                          isIncoming: value
                                                              .getDataList(
                                                                  "today",
                                                                  true)[index]
                                                              .isIncoming,
                                                          isMissed: value
                                                              .getDataList(
                                                                  "today",
                                                                  true)[index]
                                                              .isMissed,
                                                          time: value
                                                              .getDataList(
                                                                  "today",
                                                                  true)[index]
                                                              .time,
                                                          numberToDial: value
                                                              .getDataList(
                                                                  "today",
                                                                  true)[index]
                                                              .numberToDial,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          value
                                                      .getDataList(
                                                          "yesterday", true)
                                                      .length <
                                                  1
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          "Yesterday",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                cc.txtcolor.value,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: value
                                                          .getDataList(
                                                              "yesterday", true)
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTTile(
                                                          name: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  true)[index]
                                                              .name,
                                                          isIncoming: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  true)[index]
                                                              .isIncoming,
                                                          isMissed: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  true)[index]
                                                              .isMissed,
                                                          time: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  true)[index]
                                                              .time,
                                                          numberToDial: value
                                                              .getDataList(
                                                                  "yesterday",
                                                                  true)[index]
                                                              .numberToDial,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          value
                                                      .getDataList(
                                                          "earlier", true)
                                                      .length <
                                                  1
                                              ? Container()
                                              : Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          "Earlier",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                cc.txtcolor.value,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: value
                                                          .getDataList(
                                                              "earlier", true)
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTTile(
                                                          name: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  true)[index]
                                                              .name,
                                                          isIncoming: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  true)[index]
                                                              .isIncoming,
                                                          isMissed: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  true)[index]
                                                              .isMissed,
                                                          time: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  true)[index]
                                                              .time,
                                                          numberToDial: value
                                                              .getDataList(
                                                                  "earlier",
                                                                  true)[index]
                                                              .numberToDial,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          value.isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                )
                                              : const SizedBox(),
                                          value.isLoading
                                              ? const CircularProgressIndicator()
                                              : const SizedBox(),
                                          value.isLoading
                                              ? const SizedBox(
                                                  height: 15,
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ])),
                            )
                          ])),
                ),
              ),
            ),
          );
        });
  }
}
