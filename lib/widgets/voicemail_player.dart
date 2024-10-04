import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/storage_keys.dart';
import 'package:itp_voice/widgets/custom_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceMailPlayer extends StatefulWidget {
  String? id;
  int size = 2;
  bool inchat = false;
  bool isRecording= false;
  VoiceMailPlayer({
    this.id,
    super.key,
    this.isRecording=false,
    this.size = 2,
    this.inchat = false,
  });

  @override
  State<VoiceMailPlayer> createState() => _VoiceMailPlayerState();
}

class _VoiceMailPlayerState extends State<VoiceMailPlayer> {
  late final PlayerController playerController1;
  ColorController cc = Get.find<ColorController>();
  String? path;
  String? musicFile;
  bool isRecording = false;
  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
    
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    if(widget.isRecording){
      print("0))_________________________________--${widget.id}");
    _downloadAndPlayCall(widget.id);  
    }
    else{
      print("I Am in Else Section______________________________________________");
      print("${widget.isRecording}");
    _downloadAndPlay(widget.id);
  }
  }

  void _initialiseControllers() {
    playerController1 = PlayerController()..updateFrequency = UpdateFrequency.high
      
      ..addListener(() {
        if (mounted) {
          setState(() {
            playerController1
                .getDuration(DurationType.current)
                .then((value) => print("DURATION: $value"));
          });
        }
      });
  }

  void _downloadAndPlay(String? id) async {
  // Ensure app directory is defined
  appDirectory = await getApplicationDocumentsDirectory();
  String savePath = "${appDirectory.path}/voicemail_$id.mp3";
  String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);
  String? token = SharedPreferencesMethod.getString(StorageKeys.REFRESH_TOKEN);
  
  // Request storage permission
  if (await _requestPermission()) {
    try {
      await Dio().download(
        "${Endpoints.DOWNLOAD_VOICE_MAIL_MESSAGES(apiId)}/$id?token=$token",
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("${(received / total * 100).toStringAsFixed(0)}%");
            // Optionally, you can build a progress bar feature here
          }
        },
      );
      // Prepare the player after download is complete
      playerController1.preparePlayer(path: savePath);
    } catch (e) {
      print(e.toString());
      CustomToast.showToast("Failed to download voicemail.", true);
    }
  } else {
    CustomToast.showToast("Please allow storage permission to download voicemail", true);
  }
}


void _downloadAndPlayCall(String? id) async {
  // Ensure app directory is defined
  appDirectory = await getApplicationDocumentsDirectory();
  String savePath = "${appDirectory.path}/callRecording_$id.mp3";
  String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);
  String? token = SharedPreferencesMethod.getString(StorageKeys.REFRESH_TOKEN);
  
  // Request storage permission
  if (await _requestPermission()) {
      print("_______________________________________________________-$id");
    try {
      await Dio().download(
        
        "${Endpoints.GET_CALL_RECORDING(apiId,id)}token=$token",
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("${(received / total * 100).toStringAsFixed(0)}%");
            // Optionally, you can build a progress bar feature here
          }
        },
      );
      // Prepare the player after download is complete
      playerController1.preparePlayer(path: savePath);
    } catch (e) {
      print(e.toString());
      CustomToast.showToast("Failed to download voicemail.", true);
    }
  } else {
    CustomToast.showToast("Please allow storage permission to download voicemail", true);
  }
}


  void _disposeControllers() {
    playerController1.stopAllPlayers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _playOrPlausePlayer(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);

    // controller.getDuration();
  }

  String getDuration(Duration duration) {
    var components = <String>[];

    var days = duration.inDays;
    if (days != 0) {
      components.add('${days}d');
    }
    var hours = duration.inHours % 24;
    if (hours != 0) {
      components.add('${hours}h');
    }
    var minutes = duration.inMinutes % 60;
    if (minutes != 0) {
      components.add('${minutes}m');
    }

    var seconds = duration.inSeconds % 60;
    var centiseconds = (duration.inMilliseconds % 1000) ~/ 10;
    if (components.isEmpty || seconds != 0 || centiseconds != 0) {
      components.add('$seconds');
      if (centiseconds != 0) {
        components.add('.');
        components.add(centiseconds.toString().padLeft(2, '0'));
      }
      components.add('s');
    }
    return components.join();
  }
// didC
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.detached) {
  //     _disposeControllers();
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }


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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (playerController1.playerState != PlayerState.stopped) ...[
          Align(
            // alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              // padding: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.inchat ?Colors.transparent:cc.purplecolor.value,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.inchat?
                  Container(
                    width: 40.h,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: cc.purplecolor.value,
                      borderRadius: BorderRadius.circular(50),
                    ),

                    child: IconButton(
                      onPressed: () {
                        _playOrPlausePlayer(playerController1);
                      },
                      icon: Icon(
                          playerController1.playerState == PlayerState.playing
                              ? Icons.pause
                              : Icons.play_arrow),
                      color: Colors.white,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  ):IconButton(
                      onPressed: () {
                        _playOrPlausePlayer(playerController1);
                      },
                      icon: Icon(
                          playerController1.playerState == PlayerState.playing
                              ? Icons.pause
                              : Icons.play_arrow),
                      color: Colors.white,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  AudioFileWaveforms(
                    
                    size: Size(MediaQuery.of(context).size.width / widget.size.w, 30),
                    playerController: playerController1,
                    playerWaveStyle: PlayerWaveStyle(
                      seekLineColor: cc.txtcolor.value,
                      showTop: true,
                      scaleFactor: 1,
                      
                      fixedWaveColor:widget.inchat?cc.txtcolor.value: Colors.white30,
                      liveWaveColor: widget.inchat?cc.purplecolor.value: Colors.white,
                      waveCap: StrokeCap.round,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  FutureBuilder(
                    future: playerController1.getDuration(DurationType.max),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          getDuration(
                            Duration(milliseconds: snapshot.data as int),
                          ),
                          style:
                              TextStyle(color: widget.inchat?cc.txtcolor.value:Colors.white, fontSize: 14.sp),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                ],
              ),
            ),
          )
        ] else ...[
          const CircularProgressIndicator()
        ],
      ],
    );
  }
}
