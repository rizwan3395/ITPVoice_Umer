import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/chat_controller.dart';
import 'package:itp_voice/controllers/messages_controller.dart';
import 'package:itp_voice/controllers/settings_controller.dart';
import 'package:itp_voice/models/message.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/screens/home_screen.dart';
import 'package:itp_voice/widgets/app_button.dart';
import 'package:itp_voice/widgets/chat_message_tile.dart';
import 'package:itp_voice/widgets/custom_widgets/date_seprator.dart';
import 'package:itp_voice/widgets/phone_number_field.dart';
import 'package:timezone/timezone.dart';
import '../repo/shares_preference_repo.dart';
import '../storage_keys.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final double minValue = 8.0.h;

  List<Message> myMessagesList = myMessages;

  bool isCurrentUserTyping = false;

  ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  bool hasMoreMessages = true;

  final double iconSize = 28.0;

  ChatController con = Get.put(ChatController());
  ColorController cc = Get.find<ColorController>();
  MessagesController mcon = Get.find<MessagesController>();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore &&
          hasMoreMessages) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    setState(() {
      isLoadingMore = true;
    });

    await con.loadMoreMessages(); // Load new messages

    setState(() {
      isLoadingMore = false;
      // You might want to set hasMoreMessages to false if no more messages are available
      // hasMoreMessages = result;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      bottomSheet: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: cc.bgcolor.value,
          border: Border(
            top: BorderSide(
              color: cc.chatBorderColor.value,
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    margin: EdgeInsets.only(left: 10.w),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: cc.tabcolor.value, // Light blue background
                      borderRadius:
                          BorderRadius.circular(25), // Rounded corners
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Centers vertically
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            con.sendMessage(isImage: true);
                          },
                          icon: Icon(
                            Icons.attach_file,
                            color: cc.chatbartxt.value,
                            size: 20.h,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: con.messageController,
                            style: TextStyle(fontSize: 14.sp),
                            decoration: InputDecoration(
                              hintText: "Type your message...",
                              hintStyle: TextStyle(
                                  fontSize: 14.sp, color: cc.chatbartxt.value),
                              border: InputBorder.none, // No visible border
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0), // Center the text
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => con.sendMessage(),
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w, left: 10.w),
                    width: 40.h,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: cc.purplecolor.value,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 55.h,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(top: 10.h, left: 5.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            color: cc.iconcolor.value,
            iconSize: 24.sp,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        elevation: 0,
        backgroundColor: cc.bgcolor.value,
        centerTitle: false,
        title: Obx(
          () => con.loadTitle.value
              ? const SizedBox.shrink()
              : Container(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    con.threadName ?? "",
                    style: TextStyle(
                      color: cc.txtcolor.value,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => Scaffold(
                        body: Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: HomeScreen(
                            initialValue: con.threadNumber ?? "",
                          ),
                        ),
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 7),
              child: Icon(
                Icons.phone,
                color: cc.iconcolor.value,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.CHAT_DETAIL_ROUTE,
                  arguments: con.threadNumber ?? "");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 7),
              child: Icon(
                Icons.info_outline,
                color: cc.iconcolor.value,
              ),
            ),
          )
        ],
      ),
      body: Obx(
        () => con.isLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: Color.fromARGB(60, 0, 0, 0),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(cc.purplecolor.value),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Obx(
                      () => Stack(
                        children: [
                          ListView.separated(
                            separatorBuilder: (context, index) {
                              // Parse the date using DateTime.parse()
                              DateTime currentMessageDate = DateTime.parse(con
                                  .messages!
                                  .result!
                                  .messages![index]
                                  .messageTimestamp!);

                              // For the first message, always show the separator
                              if (index == 0) {
                                return DateSeparator(currentMessageDate);
                              }

                              // Get the previous message date
                              DateTime previousMessageDate = DateTime.parse(con
                                  .messages!
                                  .result!
                                  .messages![index - 1]
                                  .messageTimestamp!);

                              // Check if the current message is from a different day
                              if (!DateSeparator.isSameDate(
                                  currentMessageDate, previousMessageDate)) {
                                return DateSeparator(
                                    currentMessageDate); // Show separator if the date is different
                              }

                              // If the date is the same as the previous message, return an empty space
                              return SizedBox.shrink();
                            },
                            reverse: true,
                            shrinkWrap: true,
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                                vertical: minValue * 7, horizontal: 0),
                            itemCount:
                                con.messages?.result?.messages?.length ?? 0,
                            itemBuilder: (context, index) {
                              String? apiId = SharedPreferencesMethod.getString(
                                  StorageKeys.API_ID);
                              String token = SharedPreferencesMethod.getString(
                                  StorageKeys.ACCESS_TOKEN)!;
                              String? timeZone =
                                  SharedPreferencesMethod.getString(
                                      StorageKeys.TIME_ZONE);
                              final zone = getLocation(timeZone ?? '');
                              final time = TZDateTime.from(
                                  DateTime.parse(con.messages!.result!
                                      .messages![index].messageTimestamp!),
                                  zone);
                              final bool isVoice = con.messages?.result!
                                      .messages?[index].itemType ==
                                  "voicemail";
                              final int voiceMailId = con.messages?.result!
                                      .messages?[index].voiceMailId ??
                                  0;
                              final bool isCall = con.messages?.result
                                      ?.messages?[index].itemType ==
                                  "call";
                              final String callStat = con.messages?.result
                                      ?.messages?[index].callStatus ??
                                  "";
                              final String callStatus = callStat == "answered"
                                  ? "Answered Call"
                                  : "Missed Call";
                              final String callDirection = con.messages?.result
                                      ?.messages?[index].callDirection ??
                                  "";
                              final bool hasRecording = con
                                          .messages
                                          ?.result
                                          ?.messages![index]
                                          .cdr
                                          ?.callRecordingFilename ==
                                      null
                                  ? false
                                  : true;
                                  final int recordingId = con.messages?.result
                                      ?.messages?[index].cdr?.pk ?? 0;

                              final int callDuration = con.messages?.result
                                      ?.messages?[index].cdr?.duration ??
                                  0;
                              final String callDurationString = callDuration > 0
                                  ? _secondsToMinutes(callDuration)
                                  : "";
                              return MyMessageChatTile(
                                isDelivered: con.messages?.result
                                    ?.messages?[index].isDelivered,
                                media: con.messages?.result?.messages?[index]
                                            .messageMmsMedia ==
                                        null
                                    ? null
                                    : "https://api.itpscorp.com/portal/itpvoice/v2/$apiId/my-extension/chat/media/${con.messages?.result?.messages?[index].messageMmsMedia}?token=$token",
                                fileName: con.messages?.result?.messages?[index]
                                    .messageMmsMedia,
                                hasRecording: hasRecording,
                                recordingId: recordingId.toString(),
                                message: con.messages?.result?.messages?[index]
                                        .messageBody ??
                                    '',
                                isCurrentUser: (con
                                            .messages
                                            ?.result
                                            ?.messages?[index]
                                            .messageParticipant ??
                                        '') ==
                                    con.myNumber,
                                isVoice: isVoice,
                                voiceMailId: voiceMailId,
                                deliveryTime:
                                    '${time.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}',
                                isCall: isCall,
                                callStatus: callStatus,
                                callDirection: callDirection,
                                callTime: callDurationString,
                              );
                            },
                          ),
                          if (isLoadingMore)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.transparent,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                             ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _secondsToMinutes(int seconds) {
    int minutes = seconds ~/ 60; // Get total minutes
    int remainingSeconds = seconds % 60; // Get remaining seconds

    // Format to "MM:SS" with leading zeros
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
