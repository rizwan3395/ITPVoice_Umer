

// GestureDetector(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 useRootNavigator: true,
//                 builder: (context) {
//                   return Container(
//                     height: 180.h,
//                     padding: EdgeInsets.symmetric(horizontal: 20.w),
//                     child: Column(children: [
//                       SizedBox(height: 10.h),
//                       Divider(
//                         color: Colors.grey.shade400,
//                         thickness: 3,
//                         indent: 140.w,
//                         endIndent: 140.w,
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           "Actions",
//                           style: TextStyle(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.secondary),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Get.toNamed(Routes.CALL_HISTORY_SCREEN_ROUTE);

//                           // CallHistoryRepo().getCallHistory();
//                         },
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Call History",
//                             style: TextStyle(
//                                 fontSize: 18.sp,
//                                 color: Theme.of(context).colorScheme.secondary),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Get.toNamed(Routes.SETTINGS_SCREEN_ROUTE);
//                         },
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Settings",
//                             style: TextStyle(
//                                 fontSize: 18.sp,
//                                 color: Theme.of(context).colorScheme.secondary),
//                           ),
//                         ),
//                       )
//                     ]),
//                   );
//                 },
//               );
//             },
//             child: Container(
//               margin: EdgeInsets.only(right: 20.w, top: 10.h),
//               child:
//                   Icon(Icons.more_vert, color: const Color(0xff6B6F80), size: 22.sp),
//             ),
//           )


          




// Unread messages tab in messages screen.

          // ListView.separated(
          //                   primary: false,
          //                   padding: const EdgeInsets.only(
          //                       bottom: 10, top: 10),
          //                   separatorBuilder: (context, index) {
          //                     return const Divider();
          //                   },
          //                   shrinkWrap: true,
          //                   itemCount: con.threads
          //                       .where((element) =>
          //                           element.threadRead == false)
          //                       .toList()
          //                       .length,
          //                   itemBuilder: (context, index) {
          //                     String? timeZone =
          //                         SharedPreferencesMethod.getString(
          //                             StorageKeys.TIME_ZONE);
          //                     final zone = getLocation(timeZone ?? '');
          //                     MessageThreads item = con.threads
          //                         .where((element) =>
          //                             element.threadRead == false)
          //                         .toList()[index];
          //                     final time = TZDateTime.from(
          //                         DateTime.parse(item.lastUpdated!),
          //                         zone);
                      
          //                     return item.participants!
          //                             .where((element) =>
          //                                 element.isSelf != true)
          //                             .toList()
          //                             .isEmpty
          //                         ? const SizedBox.shrink()
          //                         : GestureDetector(
          //                             onTap: () {
          //                               Get.toNamed(
          //                                   Routes.CHAT_SCREEN_ROUTE,
          //                                   arguments: [
          //                                     item.participants![0]
          //                                         .messageThreadId,
          //                                     con.selectedNumber,
          //                                     item.participants
          //                                         ?.firstWhere(
          //                                             (participant) =>
          //                                                 participant
          //                                                     .isSelf ==
          //                                                 false)
          //                                         .number,
          //                                   ]);
          //                             },
          //                             child: Container(
          //                               margin: EdgeInsets.symmetric(
          //                                   horizontal: 10.w,
          //                                   vertical: 5.h),
          //                               alignment: Alignment.center,
          //                               child: Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment
          //                                         .spaceBetween,
          //                                 children: [
          //                                   Row(
          //                                     mainAxisSize:
          //                                         MainAxisSize.max,
          //                                     children: [
          //                                       Stack(
          //                                         clipBehavior: Clip.none,
          //                                         children: [
          //                                           Container(
          //                                             padding:
          //                                                 EdgeInsets.all(
          //                                                     2.h),
          //                                             alignment: Alignment
          //                                                 .topCenter,
          //                                             decoration:
          //                                                 BoxDecoration(
          //                                               color:
          //                                                   Colors.grey,
          //                                               boxShadow: [
          //                                                 BoxShadow(
          //                                                   color: Colors
          //                                                       .black
          //                                                       .withOpacity(
          //                                                           0.1),
          //                                                   spreadRadius:
          //                                                       2,
          //                                                   blurRadius: 4,
          //                                                   offset: const Offset(
          //                                                       0,
          //                                                       3), // changes position of shadow
          //                                                 ),
          //                                               ],
          //                                               shape: BoxShape
          //                                                   .circle,
          //                                             ),
          //                                             child: Container(
          //                                               height: 50.h,
          //                                               width: 50.w,
          //                                               decoration:
          //                                                   const BoxDecoration(
          //                                                 borderRadius:
          //                                                     BorderRadius
          //                                                         .all(
          //                                                   Radius
          //                                                       .circular(
          //                                                     6,
          //                                                   ),
          //                                                 ),
          //                                                 // image: DecorationImage(
          //                                                 //   image: AssetImage('assets/images/profile.png'),
          //                                                 //   fit: BoxFit.cover,
          //                                                 // ),
          //                                               ),
          //                                               child: const Icon(
          //                                                 Icons.person,
          //                                                 size: 30,
          //                                               ),
          //                                             ),
          //                                           ),
          //                                           // index == 0
          //                                           //     ? Positioned(
          //                                           //         bottom: 0,
          //                                           //         right: 0,
          //                                           //         child: Container(
          //                                           //           padding: EdgeInsets.all(4.h),
          //                                           //           decoration: BoxDecoration(
          //                                           //             border: Border.all(color: Colors.white),
          //                                           //             shape: BoxShape.circle,
          //                                           //             color: Theme.of(context).colorScheme.primary,
          //                                           //           ),
          //                                           //           child: Text(
          //                                           //             "5",
          //                                           //             style: TextStyle(color: Colors.white, fontSize: 12.h),
          //                                           //           ),
          //                                           //         ),
          //                                           //       )
          //                                           //     : Container()
          //                                         ],
          //                                       ),
          //                                       SizedBox(width: 15.w),
          //                                       Container(
          //                                           alignment: Alignment
          //                                               .centerLeft,
          //                                           child: Column(
          //                                             mainAxisAlignment:
          //                                                 MainAxisAlignment
          //                                                     .center,
          //                                             crossAxisAlignment:
          //                                                 CrossAxisAlignment
          //                                                     .start,
          //                                             children: [
          //                                               Row(
          //                                                 children: [
          //                                                   Text(
          //                                                     item.participants!
          //                                                         .where((element) =>
          //                                                             element.isSelf !=
          //                                                             true)
          //                                                         .toList()[
          //                                                             0]
          //                                                         .number!, //"Mathew Murdock",
          //                                                     // style: ts(1, 0xff1B1A57, 14.sp, 5),
          //                                                     style:
          //                                                         TextStyle(
          //                                                       fontWeight: item.threadRead ==
          //                                                               false
          //                                                           ? FontWeight
          //                                                               .w600
          //                                                           : FontWeight
          //                                                               .w400,
          //                                                       fontSize:
          //                                                           15.sp,
          //                                                     ),
          //                                                   ),
          //                                                   SizedBox(
          //                                                     width: 5.w,
          //                                                   ),
          //                                                 ],
          //                                               ),
          //                                               SizedBox(
          //                                                   height: 3.h),
          //                                               SizedBox(
          //                                                 width: 215.w,
          //                                                 child: Text(
          //                                                   item.lastMessage ??
          //                                                       'Empty chat',
          //                                                   // style: ts(1, 0xff4F5E7B, 12.sp, 4),
          //                                                   style: TextStyle(
          //                                                       fontSize:
          //                                                           13.sp,
          //                                                       color: Theme.of(
          //                                                               context)
          //                                                           .colorScheme
          //                                                           .tertiary),
          //                                                   maxLines: 2,
          //                                                   overflow:
          //                                                       TextOverflow
          //                                                           .ellipsis,
          //                                                 ),
          //                                               ),
          //                                             ],
          //                                           ))
          //                                     ],
          //                                   ),
          //                                   Column(
          //                                     mainAxisAlignment:
          //                                         MainAxisAlignment
          //                                             .center,
          //                                     children: [
          //                                       Container(
          //                                         alignment:
          //                                             Alignment.topCenter,
          //                                         child: Text(
          //                                           '${time.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}',
          //                                           style: TextStyle(
          //                                                   fontSize:
          //                                                       13.sp,
          //                                                   color: Theme.of(
          //                                                           context)
          //                                                       .colorScheme
          //                                                       .tertiary)
          //                                               .copyWith(
          //                                                   color: item
          //                                                               .threadRead ==
          //                                                           false
          //                                                       ? AppTheme.colors(
          //                                                               context)
          //                                                           ?.textColor
          //                                                       : const Color(
          //                                                           0xFF6B6F80)),
          //                                           // ((index == 0 || index == 1 || index == 2)
          //                                           //         ? "${DateFormat('hh:mm').format(DateTime.now())}"
          //                                           //         : (index == 3 || index == 4)
          //                                           //             ? "Yesterday"
          //                                           //             : (index == 5)
          //                                           //                 ? "2 days ago"
          //                                           //                 : "Sat 9 March") +
          //                                           //     "",
          //                                         ),
          //                                       ),
          //                                       Opacity(
          //                                         opacity:
          //                                             item.unreadMessages! >
          //                                                     0
          //                                                 ? 1
          //                                                 : 0,
          //                                         child: Container(
          //                                           width: 20,
          //                                           height: 20,
          //                                           alignment:
          //                                               Alignment.center,
          //                                           margin:
          //                                               const EdgeInsets
          //                                                   .only(top: 5),
          //                                           decoration:
          //                                               BoxDecoration(
          //                                             color: item.unreadMessages! >
          //                                                     0
          //                                                 ? Theme.of(
          //                                                         context)
          //                                                     .colorScheme
          //                                                     .primary
          //                                                 : Colors
          //                                                     .transparent,
          //                                             shape:
          //                                                 BoxShape.circle,
          //                                           ),
          //                                           child: Text(
          //                                             item.unreadMessages! >
          //                                                     99
          //                                                 ? '99'
          //                                                 : item
          //                                                     .unreadMessages!
          //                                                     .toString(),
          //                                             style: TextStyle(
          //                                                 fontSize: 13.sp,
          //                                                 color: AppColors
          //                                                     .white),
          //                                           ),
          //                                         ),
          //                                       )
          //                                     ],
          //                                   ),
          //                                 ],
          //                               ),
          //                             ),
          //                           );
          //                   })




//           {
//     "error": null,
//     "errors": false,
//     "item_count": 15,
//     "item_offset": 0,
//     "items_per_page": 15,
//     "message": "SMS Threads for User.",
//     "result": {
//         "message_threads": [
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": null,
//                     "call_status": null,
//                     "item_type": "sms"
//                 },
//                 "last_event_type": "sms",
//                 "last_message": "zeyhahahahah ",
//                 "last_updated": "2024-09-17 15:37:41",
//                 "last_updated_utc": "2024-09-17T19:37:41.185405",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "is_self": true,
//                         "message_thread_id": "127173",
//                         "number": "+17866340769",
//                         "pk": 254813
//                     },
//                     {
//                         "contact": {
//                             "Birthdate": "",
//                             "account_id": 71,
//                             "address": null,
//                             "city": null,
//                             "contact_guid": null,
//                             "contact_list_id": 327,
//                             "country": null,
//                             "date_added": "2024-09-14T20:40:37.722332+00:00",
//                             "date_modified": "2024-09-14T20:40:37.722384+00:00",
//                             "dnd_sms": false,
//                             "email": "abc@hotmail.com",
//                             "firstname": "Scooby Doo",
//                             "import_job_id": null,
//                             "last_activity_time": null,
//                             "last_activity_type": null,
//                             "lastname": "",
//                             "owner_id": null,
//                             "phone": "+922251234568",
//                             "pinned": false,
//                             "pk": 227169,
//                             "state": null,
//                             "tags": [],
//                             "zipcode": null
//                         },
//                         "is_self": false,
//                         "message_thread_id": "127173",
//                         "number": "+922251234568",
//                         "pk": 254814
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 127173,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": null,
//                     "call_status": null,
//                     "item_type": "sms"
//                 },
//                 "last_event_type": "sms",
//                 "last_message": "message testing",
//                 "last_updated": "2024-09-17 15:20:53",
//                 "last_updated_utc": "2024-09-17T19:20:53.240608",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "91285",
//                         "number": "+13052990233",
//                         "pk": 182969
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "91285",
//                         "number": "+17866340769",
//                         "pk": 182970
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 91285,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": null,
//                     "call_status": null,
//                     "item_type": "sms"
//                 },
//                 "last_event_type": "sms",
//                 "last_message": "..",
//                 "last_updated": "2024-09-15 17:10:11",
//                 "last_updated_utc": "2024-09-15T21:10:11.347731",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "is_self": true,
//                         "message_thread_id": "127172",
//                         "number": "+17866340769",
//                         "pk": 254811
//                     },
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "127172",
//                         "number": "++922257894561",
//                         "pk": 254812
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 127172,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": null,
//                     "call_status": null,
//                     "item_type": "sms"
//                 },
//                 "last_event_type": "sms",
//                 "last_message": "hi",
//                 "last_updated": "2024-09-15 15:50:53",
//                 "last_updated_utc": "2024-09-15T19:50:53.215709",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": {
//                             "Birthdate": "",
//                             "account_id": 71,
//                             "address": null,
//                             "city": null,
//                             "contact_guid": null,
//                             "contact_list_id": 327,
//                             "country": null,
//                             "date_added": "2024-09-15T10:30:40.287003+00:00",
//                             "date_modified": "2024-09-15T10:31:54.352705+00:00",
//                             "dnd_sms": false,
//                             "email": "nobita@gmail.com",
//                             "firstname": "Nobita sukehiro",
//                             "import_job_id": null,
//                             "last_activity_time": null,
//                             "last_activity_type": null,
//                             "lastname": "",
//                             "owner_id": null,
//                             "phone": "+13077620176",
//                             "pinned": false,
//                             "pk": 227989,
//                             "state": null,
//                             "tags": [],
//                             "zipcode": null
//                         },
//                         "is_self": false,
//                         "message_thread_id": "127169",
//                         "number": "+13077620176",
//                         "pk": 254805
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "127169",
//                         "number": "+17866340769",
//                         "pk": 254806
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 127169,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": null,
//                     "call_status": null,
//                     "item_type": "sms"
//                 },
//                 "last_event_type": "sms",
//                 "last_message": "Who's this ",
//                 "last_updated": "2024-09-15 15:24:37",
//                 "last_updated_utc": "2024-09-15T19:24:37.690198",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "127167",
//                         "number": "+17028885127",
//                         "pk": 254801
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "127167",
//                         "number": "+17866340769",
//                         "pk": 254802
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 127167,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": true
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "inbound",
//                     "call_status": "missed",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You missed a call from +582129857497",
//                 "last_updated": "2024-09-13 15:13:14",
//                 "last_updated_utc": "2024-09-13T19:13:14.782838",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "is_self": true,
//                         "message_thread_id": "127023",
//                         "number": "+17866340769",
//                         "pk": 254513
//                     },
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "127023",
//                         "number": "+582129857497",
//                         "pk": 254514
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 127023,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "outbound",
//                     "call_status": "answered",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You made a call to +13333",
//                 "last_updated": "2024-09-11 12:48:19",
//                 "last_updated_utc": "2024-09-11T16:48:19.617411",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "124812",
//                         "number": "+13333",
//                         "pk": 250091
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "124812",
//                         "number": "+17866340769",
//                         "pk": 250092
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 124812,
//                 "thread_read": false,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "outbound",
//                     "call_status": "answered",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You made a call to +166",
//                 "last_updated": "2024-09-11 12:37:57",
//                 "last_updated_utc": "2024-09-11T16:37:57.790365",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "124807",
//                         "number": "+166",
//                         "pk": 250081
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "124807",
//                         "number": "+17866340769",
//                         "pk": 250082
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 124807,
//                 "thread_read": false,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": null,
//                     "call_status": null,
//                     "item_type": "sms"
//                 },
//                 "last_event_type": "sms",
//                 "last_message": "We Are Hiring, earn the highest  And Become part of the biggest Agency \nSend YES for Info\nSend STOP to Opt Out",
//                 "last_updated": "2024-09-06 11:57:31",
//                 "last_updated_utc": "2024-09-06T15:57:31.370032",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "is_self": true,
//                         "message_thread_id": "123028",
//                         "number": "+17866340769",
//                         "pk": 246521
//                     },
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "123028",
//                         "number": "+19379607243",
//                         "pk": 246522
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 123028,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": true
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "outbound",
//                     "call_status": "answered",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You made a call to +1000",
//                 "last_updated": "2024-09-05 06:52:38",
//                 "last_updated_utc": "2024-09-05T10:52:38.785210",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "119178",
//                         "number": "+1000",
//                         "pk": 238821
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "119178",
//                         "number": "+17866340769",
//                         "pk": 238822
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 119178,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "outbound",
//                     "call_status": "answered",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You made a call to +15588",
//                 "last_updated": "2024-09-03 19:42:24",
//                 "last_updated_utc": "2024-09-03T23:42:24.905219",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "is_self": true,
//                         "message_thread_id": "120249",
//                         "number": "+17866340769",
//                         "pk": 240963
//                     },
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "120249",
//                         "number": "+15588",
//                         "pk": 240964
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 120249,
//                 "thread_read": false,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "outbound",
//                     "call_status": "answered",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You made a call to +10033",
//                 "last_updated": "2024-09-03 19:39:12",
//                 "last_updated_utc": "2024-09-03T23:39:12.130597",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "120248",
//                         "number": "+10033",
//                         "pk": 240961
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "120248",
//                         "number": "+17866340769",
//                         "pk": 240962
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 120248,
//                 "thread_read": false,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "outbound",
//                     "call_status": "answered",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You made a call to +16699",
//                 "last_updated": "2024-09-03 19:38:33",
//                 "last_updated_utc": "2024-09-03T23:38:33.457404",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "120247",
//                         "number": "+16699",
//                         "pk": 240959
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "120247",
//                         "number": "+17866340769",
//                         "pk": 240960
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 120247,
//                 "thread_read": false,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "outbound",
//                     "call_status": "answered",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You made a call to +10708",
//                 "last_updated": "2024-09-03 19:27:24",
//                 "last_updated_utc": "2024-09-03T23:27:24.595624",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "is_self": true,
//                         "message_thread_id": "119183",
//                         "number": "+17866340769",
//                         "pk": 238831
//                     },
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "119183",
//                         "number": "+10708",
//                         "pk": 238832
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 119183,
//                 "thread_read": true,
//                 "unread_messages": 0,
//                 "user_responded": false
//             },
//             {
//                 "ai_enabled": false,
//                 "archived": false,
//                 "event_metadata": {
//                     "call_direction": "outbound",
//                     "call_status": "answered",
//                     "item_type": "call"
//                 },
//                 "last_event_type": "call",
//                 "last_message": "You made a call to +1234",
//                 "last_updated": "2024-09-03 19:26:49",
//                 "last_updated_utc": "2024-09-03T23:26:49.516340",
//                 "number_of_participants": 2,
//                 "participants": [
//                     {
//                         "contact": null,
//                         "is_self": false,
//                         "message_thread_id": "120246",
//                         "number": "+1234",
//                         "pk": 240957
//                     },
//                     {
//                         "is_self": true,
//                         "message_thread_id": "120246",
//                         "number": "+17866340769",
//                         "pk": 240958
//                     }
//                 ],
//                 "pinned": false,
//                 "pk": 120246,
//                 "thread_read": false,
//                 "unread_messages": 0,
//                 "user_responded": false
//             }
//         ]
//     }
// // }

