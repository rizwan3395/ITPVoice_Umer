import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/voicemails_controller.dart';
import 'package:itp_voice/models/get_voice_mails_response_model/result.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/text_container.dart';
import 'package:itp_voice/widgets/search_textfield.dart';
import 'package:itp_voice/widgets/voicemail_player.dart';

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

class VoiceMailDetailsScreen extends StatelessWidget {
  VoiceMailDetailsScreen({super.key});

  final VoiceMailsController con = Get.find<VoiceMailsController>();

  // Retrieve all voicemails for the specific contact.
  final List<VoiceMails> voicemails = Get.arguments['voicemails'];
  ColorController cc = Get.find<ColorController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoiceMailsController>(
      init: con,
      builder: (VoiceMailsController value) {
        return Scaffold(
          backgroundColor: cc.bgcolor.value,
          appBar: AppBar(
            
            leading: IconButton(onPressed: (){
              Get.back();
            }, icon: Icon(Icons.arrow_back_ios, color: cc.iconcolor.value,size: 18.sp,)),
            elevation: 0,
            backgroundColor: cc.bgcolor.value,
            centerTitle: true,
            title: Text(
              "Voicemails",
              style: TextStyle(
                color: cc.txtcolor.value,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: voicemails.length,
            itemBuilder: (context, index) {
              final voicemail = voicemails[index];
              return Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.all(value.isVoiceMailsLoading ? 0 : 10.w),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                      tileColor: cc.tabcolor.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      leading: TextBox(
                        text: voicemail.callerid!
                            .split("<")[0]
                            .replaceAll('"', "")[0],
                      ),
                      title: Text(
                        voicemail.callerid!.split("<")[0].replaceAll('"', ""),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                      subtitle: Text(
                        "${voicemail.usertime!.split(" ")[0]} | ${voicemail.usertime!.split(" ")[1]}",
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: cc.minitxt.value),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          if (value == 'Delete') {
                            con.deleteVoiceMail(voicemail.pk.toString());
                          } else if (value == 'Download') {
                            con.downloadVoicemail(voicemail.pk.toString());
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'Delete',
                              child: Text('Delete'),
                            ),
                            const PopupMenuItem(
                              value: 'Download',
                              child: Text('Download'),
                            ),
                          ];
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: cc.iconcolor.value,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                      height: 100.h,
                      child: VoiceMailPlayer(
                          id: voicemail.pk
                              .toString())), // Display voicemail player
                  const Divider(thickness: 0.5),
                  SizedBox(height: 10.h),
                ],
              );
            },
          ),
        );
      },
    );
  }
}


