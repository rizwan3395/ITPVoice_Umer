import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:itp_voice/models/get_voice_mails_response_model/get_voice_mails_response_model.dart';
import 'package:itp_voice/models/get_voice_mails_response_model/result.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/repo/voice_mails_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/storage_keys.dart';
import 'package:itp_voice/widgets/custom_loader.dart';
import 'package:itp_voice/widgets/custom_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceMailsController extends GetxController {
  List<VoiceMails> voiceMails = [];
  RxBool downloadingVoicemail = true.obs;
  PlayerController? playerController;
  bool voiceMailDownload = false;
  String savePath = "";
  int tappedIndex = 0;
  late VoiceMails voiceMail;
  // final player = AudioPlayer();
  Duration? voiceMailDuration;
  bool isVoiceMailsLoading = false;
  VoiceMailsRepo repo = VoiceMailsRepo();
  TextEditingController searchController = TextEditingController();

  fetchVoiceMails() async {
  voiceMails.clear(); 
  isVoiceMailsLoading = true;
  update(); 

  final res = await repo.getVoiceMails(); 
  isVoiceMailsLoading = false;
  update(); 

  if (res.runtimeType == GetVoiceMailsResponseModel) {
    GetVoiceMailsResponseModel model = res;

    
    model.result?.forEach((callerId, mails) {
      for (var mail in mails) {
        voiceMails.add(mail);
      }
    });
  } else {
    
    
  }

  update(); // Notify UI of changes
}



  deleteVoiceMail(id) async {
    Get.back();
    CustomLoader.showLoader();
    var res = await repo.deleteVoicemail(id);
    Get.back();

    if (res.runtimeType == String) {
      CustomToast.showToast(res, true);
    } else {
      fetchVoiceMails();
    }
  }

  getDataList() {
    if (searchController.text.isEmpty) {
      return voiceMails;
    }
    if (searchController.text.isNotEmpty) {
      return voiceMails
          .where((element) => element.callerid!
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    playerController = PlayerController();
    fetchVoiceMails();
  }

  Future<void> downloadVoicemail(String id) async {
  String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);
  String? token = SharedPreferencesMethod.getString(StorageKeys.REFRESH_TOKEN);

  // Ensure app directory is defined
  Directory appDirectory = await getApplicationDocumentsDirectory();
  String savePath = "${appDirectory.path}/voicemail_$id.mp3";

  // Request storage permission
  if (await _requestPermission()) {
    try {
      Get.back(); // Close any open dialogs
      CustomLoader.showLoader();

      await Dio().download(
        "${Endpoints.DOWNLOAD_VOICE_MAIL_MESSAGES(apiId)}/$id?token=$token",
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("${(received / total * 100).toStringAsFixed(0)}%");
            // Optionally, you can show download progress here
          }
        },
      );

      Get.back(); // Dismiss loader

      // Show success toast
      CustomToast.showToast(
        "Voicemail saved to ${appDirectory.path}/voicemail_$id.mp3",
        false,
      );
    } catch (e) {
      Get.back(); // Dismiss loader
      print(e.toString());

      // Show error toast
      CustomToast.showToast("Failed to download voicemail.", true);
    }
  } else {
    // Permission denied
    CustomToast.showToast(
      "Please allow storage permission to download voicemail",
      true,
    );
  }
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

  // initialiseAudio(String id) async {
  //   String? apiId = await SharedPreferencesMethod.getString(StorageKeys.API_ID);
  //   String? token =
  //       await SharedPreferencesMethod.getString(StorageKeys.REFRESH_TOKEN);

  //   voiceMailDuration = await player.setAudioSource(AudioSource.uri(Uri.parse(
  //       "${Endpoints.DOWNLOAD_VOICE_MAIL_MESSAGES(apiId)}/${id}?token=${token}")));
  // }
}
