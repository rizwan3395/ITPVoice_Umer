import 'dart:async';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as flwebrtc;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/mic_controller.dart';
import 'package:itp_voice/routes.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../widgets/custom_toast.dart';

class CallScreenController extends GetxController
    implements SipUaHelperListener, WidgetsBindingObserver {
  RxBool showNumpad = false.obs;
  RxBool audioMuted = false.obs;
  RxBool videoMuted = false.obs;
  RxBool speakerOn = false.obs;
  RxBool hold = false.obs;
  RxString? holdOriginator = "".obs;
  RxBool? isIncomingCall = false.obs;
  RxBool? isIncomingCallAccepted = false.obs;
  Rx<CallStateEnum> state = CallStateEnum.NONE.obs;
  RxString timeLabel = ''.obs;
  Timer? timer;
  RTCVideoRenderer? localRenderer = RTCVideoRenderer();
  RTCVideoRenderer? remoteRenderer = RTCVideoRenderer();
  MediaStream? localStream;
  MediaStream? remoteStream;
  bool get voiceonly =>
      (localStream == null || localStream!.getVideoTracks().isEmpty) &&
      (remoteStream == null || remoteStream!.getVideoTracks().isEmpty);
  SIPUAHelper? helper;
  Call? call;
  late StreamSubscription proximityStream;
  RxBool isNear = false.obs;



  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    
    startMiccService();
    call = Get.arguments;
    if (call!.direction == "INCOMING") {
      isIncomingCall!.value = true;
      isIncomingCallAccepted!.value = false;
    }

    helper = Get.find<SIPUAHelper>();
    helper!.addSipUaHelperListener(this);

    proximityStream = ProximitySensor.events.listen((event) {
      isNear.value = (event > 0);
      if (isNear.value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // Dim screen
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Restore screen
      }
    });
    

    await AudioService.init(
      builder: () => MyAudioHandler(controller: this),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.yourpackage.app.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidResumeOnClick: true,
      ),
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    localStream?.dispose();
    timer?.cancel();
    MicServices.instance.stop();
    proximityStream.cancel();
    super.onClose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state)async {
    if (state == AppLifecycleState.resumed || state == AppLifecycleState.inactive) {
      localStream?.getAudioTracks().forEach((track) => track.enabled = true);
    }
    else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // FlutterForegroundTask.startService(notificationTitle: "Voice ITP is running in background", notificationText: "Voice ITP is running in background", notificationIcon: NotificationIcon(metaDataName: "ic_launcher"));
      localStream?.getAudioTracks().forEach((track) => track.enabled = true);
    
    }
  }



  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      Duration duration = Duration(seconds: timer.tick) ;
      if (Get.routing.current == Routes.CALL_SCREEN_ROUTE) {
        timeLabel.value = [duration.inMinutes, duration.inSeconds]
            .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
            .join(':');
      } else {
        timer.cancel();
      }
    });
  }

  void handelStreams(CallState event) async {
    MediaStream? stream = event.stream;
    event.stream?.getAudioTracks().first.enableSpeakerphone(false);
    localStream = stream;

    if (event.originator == 'remote') {
      if (remoteRenderer != null) {
        remoteRenderer!.srcObject = stream;
      }
      remoteStream = stream;
    }
  }

  @override
  void callStateChanged(Call call, CallState callState) {
    if (callState.state == CallStateEnum.HOLD ||
        callState.state == CallStateEnum.UNHOLD) {
      hold.value = callState.state == CallStateEnum.HOLD;
      holdOriginator!.value = callState.originator!;
      return;
    }

    if (callState.state == CallStateEnum.MUTED) {
      if (callState.audio!) audioMuted.value = true;
      if (callState.video!) videoMuted.value = true;
      return;
    }

    if (callState.state == CallStateEnum.UNMUTED) {
      if (callState.audio!) audioMuted.value = false;
      if (callState.video!) videoMuted.value = false;
      return;
    }

    if (callState.state != CallStateEnum.STREAM) {
      state.value = callState.state;
    }

    if (callState.state == CallStateEnum.FAILED) {
      Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
    }

    if (call.session.start_time != null) {
      startTimer();
    }

    switch (callState.state) {
      case CallStateEnum.STREAM:
        handelStreams(callState);
        break;
      case CallStateEnum.ENDED:
        Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
        break;
      default:
        break;
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {}

  @override
  void registrationStateChanged(RegistrationState state) {}

  @override
  void transportStateChanged(TransportState state) {}

  void handleDtmf(String tone) {
    
    call!.sendDTMF(tone);
  }


  
  
  
  void handleHangup({bool goBack = false}) {
    
    try {
      call!.hangup();
      timer?.cancel();
      if (goBack) {Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);}
    } catch (e) {
      timer?.cancel();
      if (goBack) {Get.offAllNamed(Routes.BASE_SCREEN_ROUTE);}
    }
  }

  void toggleSpeaker() {
    speakerOn.value = !speakerOn.value;
    localStream?.getAudioTracks().forEach((track) {
      track.enableSpeakerphone(speakerOn.value);
    });
  }

  void turnOffSpeaker() {
    speakerOn.value = false;
    localStream?.getAudioTracks().forEach((track) {
      track.enableSpeakerphone(false);
    });
  }

  void handleAccept() async {
    bool remoteHasVideo = call!.remote_has_video;
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': remoteHasVideo
    };
    MediaStream mediaStream;

    if (kIsWeb && remoteHasVideo) {
      mediaStream = await flwebrtc.navigator.mediaDevices
          .getDisplayMedia(mediaConstraints);
      mediaConstraints['video'] = false;
      MediaStream userStream =
          await flwebrtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
      mediaStream.addTrack(userStream.getAudioTracks()[0], addToNative: true);
    } else {
      mediaConstraints['video'] = remoteHasVideo;
      mediaStream =
          await flwebrtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
    }

    call!.answer(helper!.buildCallOptions(!remoteHasVideo),
        mediaStream: mediaStream);
    isIncomingCallAccepted!.value = true;
  }

  void switchCamera() {
    if (localStream != null) {
      Helper.switchCamera(localStream!.getVideoTracks()[0]);
    }
  }
  void startMiccService() async {
    try {
      // already started\\

      
      if (await MicServices.instance.isRunningService) {
        return;
      }

      MicServices.instance.start();
    } catch (e, s) {
      print(e);
    }
  }


  void muteAudio() {
    if (audioMuted.value) {
      call!.unmute(true, false);
    } else {
      call!.mute(true, false);
    }
  }

  void muteVideo() {
    if (videoMuted.value) {
      call!.unmute(false, true);
    } else {
      call!.mute(false, true);
    }
  }

  void handleHold() {
    if (hold.value) {
      call!.unhold();
    } else {
      call!.hold();
    }
  }

  @override
  void onNewNotify(Object ntf) {}

  @override
  void onNewReinvite(ReInvite event) {}

  @override
  void didChangeAccessibilityFeatures() {
    // TODO: implement didChangeAccessibilityFeatures
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // TODO: implement didChangeLocales
  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
  }

  @override
  void didChangeTextScaleFactor() {
    // TODO: implement didChangeTextScaleFactor
  }

  @override
  void didChangeViewFocus(ViewFocusEvent event) {
    // TODO: implement didChangeViewFocus
  }

  @override
  void didHaveMemoryPressure() {
    // TODO: implement didHaveMemoryPressure
  }

  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    // TODO: implement didPushRouteInformation
    throw UnimplementedError();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() {
    // TODO: implement didRequestAppExit
    throw UnimplementedError();
  }

  @override
  void handleCancelBackGesture() {
    // TODO: implement handleCancelBackGesture
  }

  @override
  void handleCommitBackGesture() {
    // TODO: implement handleCommitBackGesture
  }

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    // TODO: implement handleStartBackGesture
    throw UnimplementedError();
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    // TODO: implement handleUpdateBackGestureProgress
  }
}



class MyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final CallScreenController controller;
  MyAudioHandler({required this.controller});

  @override
  Future<void> play() async {
    if (controller.state.value == CallStateEnum.CONNECTING &&
        controller.call!.direction == 'INCOMING') {
      try {
        controller.handleAccept();
      } catch (e) {
        CustomToast.showToast(e.toString(), true);
      }
    }
  }

  @override
  Future<void> stop() async {
    try {
      controller.handleHangup();
    } catch (e) {
      CustomToast.showToast(e.toString(), true);
    }
  }
}


@pragma('vm:entry-point')
void startMicService() {
  FlutterForegroundTask.setTaskHandler(MicService());
}

class MicService extends TaskHandler {

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // not use
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // not use
  }






  @override
  Future<void> onDestroy(DateTime timestamp) async {

  }

}
