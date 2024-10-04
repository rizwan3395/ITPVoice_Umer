import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itp_voice/locator.dart';
import 'package:itp_voice/models/get_message_threads_response_model/get_message_threads_response_model.dart';
import 'package:itp_voice/repo/messages_repo.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/services/numbers_service.dart';
import 'package:itp_voice/widgets/app_button.dart';
import 'package:itp_voice/widgets/app_textfield.dart';
import 'package:itp_voice/widgets/phone_number_field.dart';

import '../widgets/custom_toast.dart';

class MessagesController extends GetxController {
  MessagesRepo repo = MessagesRepo();

  List<MessageThreads> get threads =>
      filteredThreads.isEmpty ? allThreads : filteredThreads;
  List<MessageThreads> allThreads = <MessageThreads>[];
  List<MessageThreads> filteredThreads = <MessageThreads>[];

  TextEditingController searchController = TextEditingController();

  List<String> get numbers => locator<NumbersService>().chatNumbers;

  Rx<String> selectedchip = "All".obs;
  Rx<String> selectedNumber ="".obs;
  
  int offset = 0; // Initialize offset
  // Number of threads per page
  bool hasMoreData = true;

  RxBool isloading = false.obs;
  RxBool isloadinMore = false.obs;
  String filter="";

  loadThreads({bool isLoadMore = false}) async {
    
    print(selectedNumber);
    // Apply filter based on the selected chip
     filter = selectedchip.value == "All"
        ? ""
        : selectedchip.value == "Unread"
            ? "&threads_read=false"
            : selectedchip.value == "AI Chats"
                ? "&ai_enabled=true"
                : selectedchip.value == "Archived"
                    ? "&archived=true"
                    : "";
    hasMoreData = true;
    isloading.value = true;
    
      allThreads.clear();
      filteredThreads.clear();
      threads.clear();

    
      

    

    
    final res = await repo.getMessageThreads(
      selectedNumber.value ?? '',
      filter: filter,
      offset: 0,
    );

    // Check if the response is valid
    if (res.runtimeType == GetMessageThreadsResponseModel) {
      GetMessageThreadsResponseModel model = res;
      List<MessageThreads> newThreads = model.result?.messageThreads ?? [];

      // Append new data to existing threads
      if (newThreads.isNotEmpty) {
        print(newThreads.length);
        allThreads.addAll(newThreads);
      } else {
        
      }
    }
    isloading.value = false;
    offset=15;
  }

  loadMoreThreads({bool isLoadMore = true}) async {
    if (isloading.value || !hasMoreData)
      return; // Avoid multiple simultaneous requests or if there's no more data    
      isloadinMore.value = true;
    
    final res = await repo.getMessageThreads(
      selectedNumber.value ?? '',
      filter: filter,
      offset: offset,
    );

    if (res.runtimeType == GetMessageThreadsResponseModel) {
      GetMessageThreadsResponseModel model = res;
      List<MessageThreads> newThreads = model.result?.messageThreads ?? [];

      // Append new data to existing threads
      if (newThreads.isNotEmpty) {
        print(newThreads.length);
        allThreads.addAll(newThreads);
      } else {
        // If no new data, stop further requests
        hasMoreData = false;
      }
    }

    
    offset += 15;

    isloadinMore.value = false;
  }









  filterThreads() {
    isloading.value = true;
    filteredThreads.clear();
    for (MessageThreads thread in allThreads) {
      if (thread.participants!
          .where((element) => element.isSelf != true)
          .toList()[0]
          .number!
          .contains(searchController.text)) {
        filteredThreads.add(thread);
      }
    }
    isloading.value = false;
  }

  sendNewMessage(BuildContext context, {String? numberr}) async {
    print(numberr);

    final res = await showDialog(
      context: context,
      builder: (childContext) => AddThreadDialog(mynum: numberr),
    );
    print(res);
    if (res is List) {
      isloading.value = true;
      String numberString = "{\"list\": [\"${res[0]}\"]}";
      await repo.sendMessage(
          selectedNumber.value ??
              CustomToast.showToast(
                  "Please select a number to send from first", true),
          res[1],
          numberString);
      await loadThreads();
    }
  }

  @override
  void onInit() async {
    if (numbers.isEmpty) {
      await locator<NumbersService>().getUpdatedNumbersList();
    }
    if (numbers.isNotEmpty) {
      selectedNumber.value = selectedNumber.value==""?numbers[0]:selectedNumber.value;
    }
    loadThreads();
    super.onInit();
  }
}

class AddThreadDialog extends StatelessWidget {
  String? mynum = "";
  ColorController cc = Get.find<ColorController>();
  AddThreadDialog({
    super.key,
    this.mynum,
  });

  @override
  Widget build(BuildContext context) {
    String code = "";

    TextEditingController number =
        TextEditingController(text: mynum?.substring(1) ?? "");
    String message = "";
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: cc.bgcolor.value,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "To",
                style: TextStyle(
                  color: cc.minitxt.value,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              PhoneNumberField(
                hint: "XXXXXXXXXX",
                textController: number,
                onChanged: (value) {
                  code = value;
                },
              ),
              const SizedBox(height: 15),
              Text(
                "Message",
                style: TextStyle(
                  color: cc.minitxt.value,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppTextField(
                hint: "Enter message",
                onChanged: (value) => message = value,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () => Navigator.of(context).pop([
                        "+$code${number.text}",
                        message,
                      ]),
                  child: AppButton(
                    text: "Send",
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
