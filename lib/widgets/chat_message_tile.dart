import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/widgets/voicemail_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import '../screens/colors.dart';
import '../widgets/custom_toast.dart';

class MyMessageChatTile extends StatefulWidget {
  final String? message;
  final bool isCurrentUser;
  final String deliveryTime;
  final bool? isDelivered;
  final String? media;
  final String? fileName;
  final bool? isCall;
  final bool? isVoice;
  final bool? hasRecording;
  final String? recordingId;
  final int? voiceMailId;
  final String? callStatus;
  final String? callTime;
  final String? callDirection;

  const MyMessageChatTile({
    Key? key,
    this.message,
    required this.isCurrentUser,
    required this.deliveryTime,
    this.isDelivered,
    this.media,
    this.isVoice = false,
    this.voiceMailId = 0,
    this.fileName,
    this.isCall = false,
    this.hasRecording= false,
    this.recordingId="",
    this.callStatus = "Answered Call",
    this.callTime = "00:00",
    this.callDirection = "outbound",
  }) : super(key: key);

  @override
  State<MyMessageChatTile> createState() => _MyMessageChatTileState();
}

class _MyMessageChatTileState extends State<MyMessageChatTile> {
  bool isDownloading = false;
  ColorController cc = Get.put(ColorController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.isCurrentUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: [
            Column(
              crossAxisAlignment: widget.isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: widget.isCurrentUser ? 70.w : 15.w,
                    right: widget.isCurrentUser ? 15.w : 70.w,
                  ),
                  padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                      border: Border.all(
                        color: widget.isCurrentUser
                            ? Colors.transparent
                            : cc.chatBorderColor.value,
                      ),
                      color: widget.isCurrentUser
                          ? cc.purplecolor.value
                          : cc.bgcolor.value,
                      gradient: widget.isCurrentUser
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF8F85F3),
                                Color(0xFF7468F0),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.only(
                        bottomLeft: const Radius.circular(17),
                        bottomRight: const Radius.circular(17),
                        topLeft: widget.isCurrentUser
                            ? const Radius.circular(17)
                            : const Radius.circular(0),
                        topRight: widget.isCurrentUser
                            ? const Radius.circular(0)
                            : const Radius.circular(17),
                      ),
                    ),
                    child: Bubble(
                      showNip: true,
                      elevation: 0,
                      color: Colors.transparent,
                      style: const BubbleStyle(
                          shadowColor: Colors.black,
                          radius: Radius.circular(15),
                          padding: BubbleEdges.all(7)),
                      nip: widget.isCurrentUser
                          ? BubbleNip.rightTop
                          : BubbleNip.leftTop,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 5.w),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: widget.isCurrentUser ? 15.w : 0,
                                ),
                                child: widget.media == null
                                    ? widget.isCall == true
                                        ? _buildCallMessage(recordingId: widget.recordingId,hasRecording:widget.hasRecording==true )
                                        : widget.isVoice == true
                                            ? VoiceMailPlayer(
                                                id: widget.voiceMailId
                                                    .toString(),
                                                size: 4,
                                                inchat: true,
                                              )
                                            : SelectableText(
                                                "${widget.message}",
                                                minLines: 1,
                                                textWidthBasis:
                                                    TextWidthBasis.longestLine,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.sp,
                                                  color: widget.isCurrentUser
                                                      ? Colors.white
                                                      : cc.txtcolor
                                                          .value, // Ensure text is visible
                                                ),
                                              )
                                    : GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (childContext) => Scaffold(
                                              body: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onVerticalDragUpdate:
                                                        (details) {
                                                      if (details.delta.dy >
                                                          20) {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: PhotoView(
                                                      imageProvider:
                                                          NetworkImage(
                                                              widget.media!),
                                                      minScale:
                                                          PhotoViewComputedScale
                                                              .contained,
                                                      maxScale:
                                                          PhotoViewComputedScale
                                                              .covered,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 40,
                                                    left: 20,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.white),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          width: 210.w,
                                          height: 210.h,
                                          child: Image.network(
                                            widget.media!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          if (widget.media != null)
                            Positioned(
                              bottom: 3,
                              left: widget.isCurrentUser ? 3 : null,
                              right: !widget.isCurrentUser ? 3 : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: isDownloading
                                    ? Padding(
                                        padding: EdgeInsets.all(1.w),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                            color: cc.purplecolor.value,
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            isDownloading = true;
                                          });
                                          try {
                                            if (await _requestPermission()) {
                                              Directory dcimDirectory = Directory(
                                                  '/storage/emulated/0/DCIM/itpvoice');
                                              if (!(await dcimDirectory
                                                  .exists())) {
                                                await dcimDirectory.create(
                                                    recursive: true);
                                              }
                                              String savePath =
                                                  "${dcimDirectory.path}/${widget.fileName}";

                                              await Dio().download(
                                                  widget.media!, savePath);
                                              CustomToast.showToast(
                                                  "Downloaded ${widget.fileName}",
                                                  false);
                                            } else {
                                              CustomToast.showToast(
                                                  "Storage permission denied",
                                                  true);
                                            }
                                          } catch (e) {
                                            print(e.toString());
                                            CustomToast.showToast(
                                                "Failed to download file.",
                                                true);
                                          } finally {
                                            setState(() {
                                              isDownloading = false;
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.download,
                                            color: Colors.white)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: widget.isCurrentUser ? 0 : 25.w,
                    right: widget.isCurrentUser ? 25.w : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: widget.isCurrentUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.deliveryTime,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      if (widget.isDelivered != null &&
                          widget.isCurrentUser == true)
                        Icon(
                          widget.isDelivered == true
                              ? Icons.done_all
                              : Icons.check,
                          size: 14.sp,
                          color: widget.isCurrentUser
                              ? const Color.fromRGBO(55, 163, 222, 1)
                              : Colors.white,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true; // Permission already granted
      } else {
        if (Platform.isAndroid && Platform.version.compareTo("11.0.0") >= 0) {
          if (await Permission.manageExternalStorage.isGranted) {
            return true; // MANAGE_EXTERNAL_STORAGE already granted
          }
          PermissionStatus status =
              await Permission.manageExternalStorage.request();
          return status.isGranted;
        } else {
          PermissionStatus status = await Permission.storage.request();
          return status.isGranted;
        }
      }
    } else {
      return true;
    }
  }

  Widget _buildCallMessage({bool hasRecording = false, recordingId = ""}) {
    print("--------------------------------------------------------$hasRecording");
    print("--------------------------------------------------------$recordingId");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.callStatus == "Missed Call"
                        ? "Missed Call"
                        : widget.callDirection == "outbound"
                            ? "Outgoing Call"
                            : "Incoming Call",
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.isCurrentUser
                          ? Colors.white
                          : cc.txtcolor.value,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        widget.callDirection == "outbound"
                            ? Icons.call_made
                            : Icons.call_received,
                        size: 14,
                        color: widget.callStatus != "Missed Call"
                            ? const Color.fromARGB(255, 9, 252, 17)
                            : Colors.red,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.callTime == "" ? "00:00" : widget.callTime!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: widget.callStatus == "Answered Call"
                              ? const Color.fromARGB(255, 9, 252, 17)
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 40.w),
              CircleAvatar(
                backgroundColor: widget.callStatus == "Missed Call"
                    ? Colors.red
                    : const Color.fromARGB(255, 68, 223, 73),
                radius: 18,
                child: Icon(
                  widget.callStatus == "Missed Call"
                      ? Icons.call_end
                      : Icons.call,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          if(hasRecording)
          VoiceMailPlayer(
            id: recordingId,
            isRecording: hasRecording,
            size: 5,
            inchat: true,
          )
        ],
      ),
    );
  }
}
