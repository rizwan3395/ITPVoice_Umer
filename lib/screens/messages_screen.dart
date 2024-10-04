import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/messages_controller.dart';
import 'package:itp_voice/models/get_message_threads_response_model/get_message_threads_response_model.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/storage_keys.dart';
import 'package:itp_voice/widgets/search_textfield.dart';
import 'package:timezone/timezone.dart';

List avatarImages = [
  "https://i.imgur.com/Fur0AUt.png",
  "https://i.imgur.com/kL7WMgG.png",
  "https://i.imgur.com/Bwf87Tv.png",
  "https://i.imgur.com/Fur0AUt.png",
  "https://i.imgur.com/kL7WMgG.png",
  "https://i.imgur.com/Bwf87Tv.png",
  "https://i.imgur.com/Fur0AUt.png",
  "https://i.imgur.com/kL7WMgG.png",
  "https://i.imgur.com/Bwf87Tv.png",
  "https://i.imgur.com/Fur0AUt.png",
  "https://i.imgur.com/kL7WMgG.png",
  "https://i.imgur.com/Bwf87Tv.png",
];

class MessagesScreen extends StatefulWidget {
  MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  MessagesController con = Get.put(MessagesController());
  ScrollController _scrollControlller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollControlller.addListener(() {
      if (_scrollControlller.position.pixels >=
              _scrollControlller.position.maxScrollExtent &&
          !con.isloading.value) {
        con.loadMoreThreads(isLoadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();

    // List of filters (you can customize this)
    final List<String> filters = ['All', 'Unread', 'AI Chats', 'Archived'];
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 16.w, top: 12.h),
          child: PopupMenuButton<String>(
            icon: Icon(
              Icons.menu,
              color: cc.iconcolor.value,
            ), // Hamburger menu icon
            onSelected: (String selectedValue) {
              
              con.selectedNumber.value = selectedValue; // Set selected number
              con.loadThreads(); // Reload the threads based on the selected number
            },
            itemBuilder: (BuildContext context) {
              return List.generate(con.numbers.length, (index) {
                return PopupMenuItem<String>(
                  value: con.numbers[index],
                  child: Text(
                    con.numbers[index],
                    style: TextStyle(
                      color: cc.txtcolor.value,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              });
            },
          ),
        ),
        actions: [
          // Button color

          Container(
            margin: EdgeInsets.only(right: 22.w, top: 10.h),
            child: ElevatedButton.icon(
              onPressed: () {
                con.sendNewMessage(context);
              },
              icon: const Icon(Icons.add, size: 16), // Add icon
              label: const Text("Add"), // Add text
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
            "Messages",
            style: TextStyle(
              color: cc.txtcolor.value,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Obx(
        () => con.isloading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: const Color.fromARGB(60, 0, 0, 0),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(cc.purplecolor.value),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.only(top: 12.h, bottom: 10.h),
                      child: Searchbar(
                        controller: con.searchController,
                        onChanged: (text) {
                          con.filterThreads();
                        },
                      ),
                    ),
                    Padding(
  padding: EdgeInsets.only(bottom: 10.h),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: filters.map((filter) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0), // Reduce horizontal spacing
          child: ChoiceChip(
            side: const BorderSide(color: Colors.transparent),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)), // Reduce radius for smaller chips
            ),
            label: Text(
              filter,
              style: TextStyle(
                color: con.selectedchip.value == filter ? Colors.white : cc.txtcolor.value,
                fontSize: 14.sp, // Reduce font size
              ),
            ),
            selected: filter == con.selectedchip.value,
            onSelected: (bool isSelected) {
              setState(() {
                print("Selected: $filter");
                con.selectedchip.value = filter;
                loadFilter();
              });
            },
            selectedColor: cc.purplecolor.value,
            backgroundColor: cc.tabcolor.value,
          ),
        );
      }).toList(),
    ),
  ),
),

                    Expanded(
                      child: RefreshIndicator(
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        color: cc.purplecolor.value,
                        onRefresh: () async {
                          con.loadThreads();
                        },
                        child: con.allThreads.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.emoji_emotions,
                                    size: 35.sp,
                                    color: cc.iconcolor.value,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    "There are no messages",
                                    style: TextStyle(
                                        color: cc.txtcolor.value,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],

                                // https://api.itpscorp.com/portal/itpvoice/v2/6/my-extension/chat/sms/+18882744529?offset=0&limit=15&ai_enabled=true
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: cc.bgcolor.value,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromARGB(39, 0, 0, 0),
                                        offset: Offset(0, 1),
                                        blurRadius: 10,
                                        spreadRadius: 0)
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ListView.separated(
                                        controller: _scrollControlller,
                                        primary: false,
                                        // controller: ,
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 10),
                                        separatorBuilder: (context, index) {
                                          return const Divider();
                                        },
                                        shrinkWrap: true,
                                        itemCount: con.threads.length,
                                        itemBuilder: (context, index) {
                                          print(con.threads.length);
                                          String? timeZone =
                                              SharedPreferencesMethod.getString(
                                                  StorageKeys.TIME_ZONE);
                                          final zone =
                                              getLocation(timeZone ?? '');
                                          final time = TZDateTime.from(
                                              DateTime.parse(con
                                                  .threads[index].lastUpdated!),
                                              zone);
                                          return con
                                                  .threads[index].participants!
                                                  .where((element) =>
                                                      element.isSelf != true)
                                                  .toList()
                                                  .isEmpty
                                              ? const SizedBox.shrink()
                                              : GestureDetector(
                                                  onTap: () async {
                                                    await Get.toNamed(
                                                        Routes
                                                            .CHAT_SCREEN_ROUTE,
                                                        arguments: [
                                                          con
                                                              .threads[index]
                                                              .participants![0]
                                                              .messageThreadId,
                                                          con.selectedNumber
                                                              .value,
                                                          con.threads[index]
                                                              .participants
                                                              ?.firstWhere(
                                                                  (participant) =>
                                                                      participant
                                                                          .isSelf ==
                                                                      false)
                                                              .number,
                                                          con.threads[index]
                                                                      .participants!
                                                                      .where((element) =>
                                                                          element
                                                                              .isSelf !=
                                                                          true)
                                                                      .toList()[
                                                                          0]
                                                                      .contact !=
                                                                  null
                                                              ? "${con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact!.firstname ?? ''} ${con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact!.lastname ?? ''}"
                                                                  .trim()
                                                              : con
                                                                      .threads[
                                                                          index]
                                                                      .participants!
                                                                      .where((element) =>
                                                                          element
                                                                              .isSelf !=
                                                                          true)
                                                                      .toList()[
                                                                          0]
                                                                      .number ??
                                                                  'Unknown',
                                                        ]);
                                                    con.onInit();
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 5.h),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Stack(
                                                              clipBehavior:
                                                                  Clip.none,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(2
                                                                              .h),
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        76,
                                                                        109,
                                                                        40,
                                                                        217),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            4,
                                                                        offset: const Offset(
                                                                            0,
                                                                            3), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        50.h,
                                                                    width: 50.w,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius
                                                                            .circular(
                                                                          6,
                                                                        ),
                                                                      ),
                                                                      // image: DecorationImage(
                                                                      //   image: AssetImage('assets/images/profile.png'),
                                                                      //   fit: BoxFit.cover,
                                                                      // ),
                                                                    ),
                                                                    child: con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact != null &&
                                                                            con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact!.firstname !=
                                                                                null &&
                                                                            con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact!.firstname!.isNotEmpty
                                                                        ? Center(
                                                                            child:
                                                                                Text(
                                                                              con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact!.firstname![0].toUpperCase(),
                                                                              style: TextStyle(
                                                                                color: cc.msgAvatarClr.value,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 20.sp,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const Icon(
                                                                            Icons.person,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                  ),
                                                                ),
                                                                // index == 0
                                                                //     ? Positioned(
                                                                //         bottom: 0,
                                                                //         right: 0,
                                                                //         child: Container(
                                                                //           padding: EdgeInsets.all(4.h),
                                                                //           decoration: BoxDecoration(
                                                                //             border: Border.all(color: Colors.white),
                                                                //             shape: BoxShape.circle,
                                                                //             color: Theme.of(context).colorScheme.primary,
                                                                //           ),
                                                                //           child: Text(
                                                                //             "5",
                                                                //             style: TextStyle(color: Colors.white, fontSize: 12.h),
                                                                //           ),
                                                                //         ),
                                                                //       )
                                                                //     : Container()
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                width: 15.w),
                                                            Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact != null
                                                                              ? "${con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact!.firstname ?? ''} ${con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].contact!.lastname ?? ''}".trim()
                                                                              : con.threads[index].participants!.where((element) => element.isSelf != true).toList()[0].number ?? 'Unknown',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight: con.threads[index].threadRead == false
                                                                                ? FontWeight.w600
                                                                                : FontWeight.w400,
                                                                            fontSize:
                                                                                16.sp,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5.w,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            3.h),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(2.h),
                                                                          child:
                                                                              Icon(
                                                                            con.threads[index].lastEventType == "call"
                                                                                ? Icons.call
                                                                                : con.threads[index].lastEventType == "voicemail"
                                                                                    ? Icons.mic
                                                                                    : Icons.message,
                                                                            size:
                                                                                15.sp,
                                                                            color:
                                                                                cc.iconcolor.value,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              200.w,
                                                                          child:
                                                                              Text(
                                                                            con.threads[index].lastMessage ??
                                                                                'Empty chat',
                                                                            // style: ts(1, 0xff4F5E7B, 12.sp, 4),
                                                                            style:
                                                                                TextStyle(fontSize: 13.sp, color: Theme.of(context).colorScheme.tertiary),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ))
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .topCenter,
                                                              child: Text(
                                                                '${time.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}',
                                                                style: TextStyle(
                                                                        fontSize: 13
                                                                            .sp,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .tertiary)
                                                                    .copyWith(
                                                                        fontWeight: con.threads[index].threadRead ==
                                                                                false
                                                                            ? FontWeight.w600
                                                                            : FontWeight.normal),
                                                                // ((index == 0 || index == 1 || index == 2)
                                                                //         ? "${DateFormat('hh:mm').format(DateTime.now())}"
                                                                //         : (index == 3 || index == 4)
                                                                //             ? "Yesterday"
                                                                //             : (index == 5)
                                                                //                 ? "2 days ago"
                                                                //                 : "Sat 9 March") +
                                                                //     "",
                                                              ),
                                                            ),
                                                            Opacity(
                                                              opacity: con
                                                                          .threads[
                                                                              index]
                                                                          .unreadMessages! >
                                                                      0
                                                                  ? 1
                                                                  : 0,
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: con.threads[index].unreadMessages! >
                                                                          0
                                                                      ? Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary
                                                                      : Colors
                                                                          .transparent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Text(
                                                                  con.threads[index].unreadMessages! >
                                                                          99
                                                                      ? '99'
                                                                      : con
                                                                          .threads[
                                                                              index]
                                                                          .unreadMessages!
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13.sp,
                                                                      color: AppColors
                                                                          .white),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                        }),
                                    if (con.isloadinMore.value)
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          color: cc.bgcolor.value,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  loadFilter() async {
    await con.loadThreads(isLoadMore: false);
  }

  @override
  void dispose() {
    _scrollControlller.dispose();
    super.dispose();
  }
}
