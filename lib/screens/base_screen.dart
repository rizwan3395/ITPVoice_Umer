import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/base_screen_controller.dart';
import 'package:itp_voice/controllers/settings_controller.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/screens/contacts_screen.dart';
import 'package:itp_voice/screens/home_screen.dart';
import 'package:itp_voice/screens/messages_screen.dart';
import 'package:itp_voice/screens/profile_screen.dart';
import 'package:itp_voice/screens/voice_mail_screen.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});
  BaseScreenController con = Get.put(BaseScreenController());
  ColorController cc = Get.put(ColorController());

  Widget navIcon({sel, unsel, index}) {
    return con.currentTab.value == index
        ? Icon(sel,size: 25.sp,color: cc.purplecolor.value,
          )
        : Icon(unsel,size: 25.sp,color: cc.iconcolor.value,
          );
  }

  @override
  Widget build(BuildContext context) {
    
    ColorController cc = Get.put(ColorController());
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: Color.fromARGB(255, 222, 226, 230),
              ),
            ),
          ),
          child: Obx(
            () => BottomNavigationBar(
              
              
              onTap: (index) {
                con.updateCurrentTab(index);
              },
              currentIndex: con.currentTab.value,
              type: BottomNavigationBarType.fixed,
              iconSize: 24.sp,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: const Color(0xffA6B0CF),
              selectedLabelStyle: TextStyle(
                fontSize: 12.sp,
                color: cc.txtcolor.value,
                
              ),
              unselectedLabelStyle:
                  TextStyle(fontSize: 11.sp, color: cc.txtcolor.value),
              backgroundColor: cc.bgcolor.value,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: navIcon(
                      sel: Icons.home_filled,
                      unsel: Icons.home_outlined,
                      index: 0),
                  label: ('Home'),
                ),
                BottomNavigationBarItem(
                  icon: navIcon(
                      sel: Icons.account_circle_rounded ,
                      unsel: Icons.account_circle_outlined,
                      index: 1),
                  label: ('Contacts'),
                ),
                BottomNavigationBarItem(
                  icon: navIcon(
                      sel: Icons.mail_rounded,
                      unsel: Icons.mail_outline,
                      index: 2),
                  label: ('Messages'),
                ),
                BottomNavigationBarItem(
                  icon: navIcon(
                      sel: Icons.voice_chat,
                      unsel: Icons.voice_chat,
                      index: 3),
                  label: ('My Voicemails'),
                ),
                BottomNavigationBarItem(
                  icon: navIcon(
                      sel: Icons.person,
                      unsel: Icons.person_outline,
                      index: 4),
                  label: ('Profile'),
                ),
              ],
            ),
          )),
      body: Obx(() => con.currentTab.value == 0
          ? HomeScreen()
          : con.currentTab.value == 2
              ? MessagesScreen()
              : con.currentTab.value == 3
                  ? VoiceMailScreen()
                  : con.currentTab.value == 1
                      ? ContactsScreen()
                      : ProfileScreen()),
    ));
  }
}
