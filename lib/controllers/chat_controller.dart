import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itp_voice/models/get_thread_messages_response_model/get_thread_messages_response_model.dart';
import 'package:itp_voice/notification_service.dart';
import 'package:itp_voice/routes.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../repo/messages_repo.dart';
import '../repo/shares_preference_repo.dart';
import '../storage_keys.dart';
import '../widgets/custom_toast.dart';

class ChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isMessageLoading = false.obs;
  MessagesRepo repo = MessagesRepo();
  String myNumber = Get.arguments[1];
  String? threadNumber = Get.arguments[2];
  String get threadId => Get.arguments[0];
  String get threadName => Get.arguments[3];
  final Rx<GetThreadMessagesResponseModel?> _messages = Rx(null);
  

  GetThreadMessagesResponseModel? get messages => _messages.value;
  TextEditingController messageController = TextEditingController();
  StreamSubscription? channelSubscription;

  bool socketConnected = false;
  Timer? reconnector;

  @override
  void onClose() {
    reconnector?.cancel();
    channelSubscription?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    fetchChat("0");
    repo.markAsRead(threadId, myNumber);
    channelSubscription?.cancel();
    reconnector?.cancel();
    channelSubscription = messageSocketConnect().listen((body) {
      try {
        repo.markAsRead(threadId, myNumber);
      } catch (e) {
        
        print(e.toString());
      }
      handleWebsocketResponce(body);
    }, onDone: () {
      print("Closed");
      socketConnected = false;
      reconnector = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        if (socketConnected == false) {
          socketConnected = true;
          channelSubscription?.cancel();
          channelSubscription = messageSocketConnect().listen(
            (body) {
              try {
                repo.markAsRead(threadId, myNumber);
              } catch (e) {
                print(e.toString());
              }
              handleWebsocketResponce(body);
            },
            onDone: () {
              socketConnected = false;
              print("Closed");
            },
          );
          print("Reconnected");
        }
      });
    });
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          if (Get.currentRoute == Routes.CHAT_SCREEN_ROUTE) {
            // fetchChat();
          } else {
            LocalNotificationService.createanddisplaynotification(message);
          }
        }
      },
    );

    super.onInit();
  }

  handleWebsocketResponce(dynamic bod) {
    dynamic body = jsonDecode(bod);
    try {
      print(body);
      if (body["payload"] == "Unauthorized") {
        CustomToast.showToast("User Unauthorized Websocket Connection failed", true);
        Get.back();
      }
      socketConnected = true;
      if (body["message_type"] == "sms-status" || body["message_type"] == "sms") {
        if (jsonDecode(body["payload"])["message_status"] != null) {
          print(jsonDecode(body["payload"]) as Map<String, dynamic>);
          // _messages.value?.result?.messages
          //     ?.insert(0, Messages.fromPayload(jsonDecode(body["payload"]) as Map<String, dynamic>));
          int? index = messages?.result?.messages?.indexWhere(
              (element) => element.messageProviderId == jsonDecode(body["payload"])["message_provider_id"]);
          if (index != -1 && index != null) {
            _messages.value!.result!.messages![index].isDelivered = true;
          } else {
            try {
              if (jsonDecode(body["payload"])["from_number"] == threadNumber) {
                _messages.value?.result?.messages
                    ?.insert(0, Messages.fromPayload(jsonDecode(body["payload"]) as Map<String, dynamic>));
              }
            } catch (e) {
              null;
            }
          }
          isLoading.value = true;
          isLoading.value = false;
        } else {
          CustomToast.showToast("Message status from web socket: failed", true);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    // print("RECIEVED FROM WEB SOCKET ${body}");
    // _messages.value?.result?.messages
    //     ?.insert(0, Messages.fromPayload(body["payload"]));
  }

  Stream messageSocketConnect() {
    final apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    final connection = WebSocketChannel.connect(
      Uri.parse("wss://websockets.api.itp247.com/sms"),
      // headers: {
      //   "action": "login",
      //   "payload": {
      //     "account_id": "$apiId",
      //     "jwt_token":
      //         "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NjYzMjQ4NjksImlkIjoiNzYiLCJpYXQiOjE2NjYyMzg0NjksImFjY291bnRfbnVtYmVyIjoiMTY5NTUzMTgiLCJ1c2VyX2NvbnRhY3QiOnsibW9iaWxlIjoiIiwiZmlyc3RuYW1lIjoiRGF2aWQiLCJiaWxsaW5nX2dyb3VwIjp0cnVlLCJsYW5ndWFnZSI6ImVuIiwicGsiOjc2LCJlbWFpbCI6ImRhdmlkcmljYXJkb2xvcGV6YmFycmlvc0BnbWFpbC5jb20iLCJsYXN0bmFtZSI6IkxvcGV6IiwidGVjaG5pY2FsX2dyb3VwIjp0cnVlLCJhY2NvdW50X2lkIjo0MzksImFjY291bnQiOm51bGwsImFkbWluX2dyb3VwIjp0cnVlLCJtb2JpbGVfZGV2aWNlX2lkIjpudWxsLCJ1aV9jb2xvcl9tb2RlIjoiZGFyayIsInRpbWVfem9uZSI6IlVUQyJ9LCJjb250YWN0X2FjbCI6e30sInNlcnZpY2VzX2FwaV9pZF9saXN0IjpbIjk4NDNhMjQ0YmViODQ3MDhiZTA3ZGQ4ZDk2YWUwY2MzIiwiNjEiXSwic2VydmljZXNfdXNlcl9vYmplY3RzIjp7IjYxIjp7InZvaWNlbWFpbF9lbmFibGVkIjp0cnVlLCJwcml2X2xldmVsIjoidXNlciIsInN0YXR1cyI6bnVsbCwiZGVmYXVsdF9vdXRib3VuZF9jYWxsZXJpZF9uYW1lIjpudWxsLCJjYWxsZm9yd2FyZF9udW1iZXIiOiIxMjMiLCJ2bV90b19lbWFpbF9lbmFibGVkIjp0cnVlLCJjYWxsX3JlY29yZGluZ19leHRlcm5hbCI6ImVuYWJsZWQiLCJjYWxsZm9yd2FyZF9lbmFibGUiOnRydWUsImNhbGxmb3J3YXJkX3F1ZXVlX2NhbGxzIjp0cnVlLCJjYWxsZm9yd2FyZF9rZWVwX2NhbGxlcl9jYWxsZXJfaWQiOnRydWUsImNybV9jb250YWN0X2lkIjo3NiwicGsiOjE2MiwicHJlc2VuY2VfaWQiOiIxMDkiLCJ2b2ljZW1haWxfYm94X2lkIjoiMTMwIiwiY2FsbF9yZWNvcmRpbmdfaW50ZXJuYWwiOiJlbmFibGVkIiwiZGVmYXVsdF9vdXRib3VuZF9jYWxsZXJpZF9udW1iZXIiOm51bGwsInVzZXJfdm9sdW1lX3ByZWZlcmVuY2UiOjEwMCwiYWNjb3VudF9pZCI6NjF9fX0.OOrgj9LlK26kTEhJi3BfGAKlyNfZGAHIXIatV1WsJHQ",
      //     "phone_number": "+18637580072"
      //   }
      // },
    );
    // channelSubscription = connection.stream.listen((body) {
    //   print("RECIEVED FROM WEB SOCKET ${jsonDecode(body)}");
    // });
    final String token = SharedPreferencesMethod.getString(StorageKeys.REFRESH_TOKEN)!;
    connection.sink.add(jsonEncode({
      "action": "login",
      "payload": {"account_id": "$apiId", "jwt_token": token, "phone_number": myNumber}
    }));
    // connection.sink.add(jsonEncode({
    //   "action": "login",
    //   "payload": {
    //     "account_id": "$apiId",
    //     "jwt_token":
    //         "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NjYzMjQ4NjksImlkIjoiNzYiLCJpYXQiOjE2NjYyMzg0NjksImFjY291bnRfbnVtYmVyIjoiMTY5NTUzMTgiLCJ1c2VyX2NvbnRhY3QiOnsibW9iaWxlIjoiIiwiZmlyc3RuYW1lIjoiRGF2aWQiLCJiaWxsaW5nX2dyb3VwIjp0cnVlLCJsYW5ndWFnZSI6ImVuIiwicGsiOjc2LCJlbWFpbCI6ImRhdmlkcmljYXJkb2xvcGV6YmFycmlvc0BnbWFpbC5jb20iLCJsYXN0bmFtZSI6IkxvcGV6IiwidGVjaG5pY2FsX2dyb3VwIjp0cnVlLCJhY2NvdW50X2lkIjo0MzksImFjY291bnQiOm51bGwsImFkbWluX2dyb3VwIjp0cnVlLCJtb2JpbGVfZGV2aWNlX2lkIjpudWxsLCJ1aV9jb2xvcl9tb2RlIjoiZGFyayIsInRpbWVfem9uZSI6IlVUQyJ9LCJjb250YWN0X2FjbCI6e30sInNlcnZpY2VzX2FwaV9pZF9saXN0IjpbIjk4NDNhMjQ0YmViODQ3MDhiZTA3ZGQ4ZDk2YWUwY2MzIiwiNjEiXSwic2VydmljZXNfdXNlcl9vYmplY3RzIjp7IjYxIjp7InZvaWNlbWFpbF9lbmFibGVkIjp0cnVlLCJwcml2X2xldmVsIjoidXNlciIsInN0YXR1cyI6bnVsbCwiZGVmYXVsdF9vdXRib3VuZF9jYWxsZXJpZF9uYW1lIjpudWxsLCJjYWxsZm9yd2FyZF9udW1iZXIiOiIxMjMiLCJ2bV90b19lbWFpbF9lbmFibGVkIjp0cnVlLCJjYWxsX3JlY29yZGluZ19leHRlcm5hbCI6ImVuYWJsZWQiLCJjYWxsZm9yd2FyZF9lbmFibGUiOnRydWUsImNhbGxmb3J3YXJkX3F1ZXVlX2NhbGxzIjp0cnVlLCJjYWxsZm9yd2FyZF9rZWVwX2NhbGxlcl9jYWxsZXJfaWQiOnRydWUsImNybV9jb250YWN0X2lkIjo3NiwicGsiOjE2MiwicHJlc2VuY2VfaWQiOiIxMDkiLCJ2b2ljZW1haWxfYm94X2lkIjoiMTMwIiwiY2FsbF9yZWNvcmRpbmdfaW50ZXJuYWwiOiJlbmFibGVkIiwiZGVmYXVsdF9vdXRib3VuZF9jYWxsZXJpZF9udW1iZXIiOm51bGwsInVzZXJfdm9sdW1lX3ByZWZlcmVuY2UiOjEwMCwiYWNjb3VudF9pZCI6NjF9fX0.OOrgj9LlK26kTEhJi3BfGAKlyNfZGAHIXIatV1WsJHQ",
    //     "phone_number": "+18637580072"
    //   }
    // }));
    print('CONNECTED TO WEB SOCKET');
    return connection.stream;
  }

  RxBool loadTitle = false.obs;

  fetchChat(String offset) async {
    isLoading.value = true;
    final res = await repo.getThreadMessages(threadId, myNumber , "15");
    if (res.runtimeType == GetThreadMessagesResponseModel) {
      _messages.value = res;
      print("-----------__________________-------------------");
      print(messages?.pageSize);
      if (threadNumber == null) {
        threadNumber = _messages.value?.result?.participants?.firstWhere((element) => element.isSelf != true).number;
        loadTitle.value = true;
        loadTitle.value = false;
      }
    }
    isLoading.value = false;
  }


 loadMoreMessages() async {
    

    // Increase page size or fetch more messages
    final res = await repo.getThreadMessages(threadId, myNumber, (messages!.pageSize + 20).toString());

    if (res.runtimeType == GetThreadMessagesResponseModel) {
      _messages.value = res;
    }

    
  }


  sendMessage({bool isImage = false}) async {
    if (isImage == true) {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        isMessageLoading.value = true;
        List numbers = [];
        messages!.result!.participants!.where((element) => element.number != myNumber).toList().forEach((element) {
          numbers.add(element.number);
        });
        String numberString = "{\"list\": [\"${numbers.join(',')}\"]}";
        await repo.sendMessage(myNumber, "", numberString, image.path).then((message) {
          if (message != null) {
            message.isDelivered = false;
            _messages.value!.result!.messages!.insert(0, message);
            isLoading.value = true;
            isLoading.value = false;
          } else {
            CustomToast.showToast("Please check your internet connvection", true);
          }
        });
        messageController.clear();
        isMessageLoading.value = false;
      }
    } else {
      if (isLoading.value != true && messageController.text.isNotEmpty && isMessageLoading.value != true) {
        isMessageLoading.value = true;
        List numbers = [];
        messages!.result!.participants!.where((element) => element.number != myNumber).toList().forEach((element) {
          numbers.add(element.number);
        });
        String numberString = "{\"list\": [\"${numbers.join(',')}\"]}";
        await repo.sendMessage(myNumber, messageController.text, numberString).then((message) {
          if (message != null) {
            message.isDelivered = false;
            _messages.value!.result!.messages!.insert(0, message);
            isLoading.value = true;
            isLoading.value = false;
          } else {
            CustomToast.showToast("Please check your internet connvection", true);
          }
        });
        messageController.clear();
        isMessageLoading.value = false;
      }
    }
  }
}



// {
//     "error": null,
//     "errors": false,
//     "item_count": 20,
//     "item_offset": 0,
//     "items_per_page": 20,
//     "message": "SMS Messages for Specific Thread.",
//     "result": {
//         "messages": [
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "just for testing .Dont reply",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1726565157872owfmvodio7raa5ue",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-09-17 05:25:57",
//                 "message_timestamp_utc": "2024-09-17T09:25:57.228554",
//                 "mms_file_type": null,
//                 "pk": 365371,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "Hi there ",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+13052990233",
//                 "message_participant_id": "182969",
//                 "message_provider_id": "b1d84023-886d-4ce5-9cc2-1aecd24dc476",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-09-15 13:35:27",
//                 "message_timestamp_utc": "2024-09-15T17:35:27.617098",
//                 "mms_file_type": null,
//                 "pk": 362707,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "111",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "172642027611842ulhs34i26kgno4",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-09-15 13:11:15",
//                 "message_timestamp_utc": "2024-09-15T17:11:15.586591",
//                 "mms_file_type": null,
//                 "pk": 362706,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "testing....",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1726420259162o4jwvhw33hctkfay",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-09-15 13:10:58",
//                 "message_timestamp_utc": "2024-09-15T17:10:58.166790",
//                 "mms_file_type": null,
//                 "pk": 362705,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": "inbound",
//                 "call_duration": 0,
//                 "call_status": "missed",
//                 "call_uniqueid": "ast01.itpvoice.net-1723024488.113120",
//                 "cdr": {
//                     "account_id": "71",
//                     "accountcode": null,
//                     "amaflags": 3,
//                     "billsec": 1,
//                     "call_recording_filename": null,
//                     "calldate": "1723024488.0",
//                     "channel": "PJSIP/sbc01-00007058",
//                     "clid": "\"ENGROBA\" <+13052990233>",
//                     "customer_cost": "0.0000",
//                     "dcontext": "from-external",
//                     "disposition": "NO ANSWER",
//                     "dnis": "+17866340769",
//                     "dst": "7866340769",
//                     "dstchannel": "Local/1202@from-queue-00004789;1",
//                     "duration": 1,
//                     "forwarded_original_caller_id": null,
//                     "forwarded_to_number": null,
//                     "from_user_id": null,
//                     "lastapp": "Queue",
//                     "lastdata": "100272,b(predialer-queue-call,s,1(100272^100272^113612))rc,,,60",
//                     "legs": [
//                         {
//                             "account_id": "71",
//                             "accountcode": null,
//                             "amaflags": 3,
//                             "billsec": 1,
//                             "call_recording_filename": null,
//                             "calldate": "1723024488.0",
//                             "channel": "PJSIP/sbc01-00007058",
//                             "clid": "\"ENGROBA\" <+13052990233>",
//                             "customer_cost": "0.0000",
//                             "dcontext": "from-external",
//                             "disposition": "NO ANSWER",
//                             "dnis": "+17866340769",
//                             "dst": "7866340769",
//                             "dstchannel": "Local/1202@from-queue-00004789;1",
//                             "duration": 1,
//                             "forwarded_original_caller_id": null,
//                             "forwarded_to_number": null,
//                             "from_user_id": null,
//                             "lastapp": "Queue",
//                             "lastdata": "100272,b(predialer-queue-call,s,1(100272^100272^113612))rc,,,60",
//                             "pk": 2271874,
//                             "src": "+13052990233",
//                             "to_user_id": null,
//                             "uniqueid": "ast01.itpvoice.net-1723024488.113120",
//                             "userfield": null
//                         },
//                         {
//                             "account_id": "71",
//                             "accountcode": null,
//                             "amaflags": 3,
//                             "billsec": 2,
//                             "call_recording_filename": null,
//                             "calldate": "1723024488.0",
//                             "channel": "PJSIP/sbc01-00007058",
//                             "clid": "\"ENGROBA\" <+13052990233>",
//                             "customer_cost": "0.0000",
//                             "dcontext": "from-external",
//                             "disposition": "NO ANSWER",
//                             "dnis": "+17866340769",
//                             "dst": "7866340769",
//                             "dstchannel": "Local/1202@from-queue-00004788;1",
//                             "duration": 5,
//                             "forwarded_original_caller_id": null,
//                             "forwarded_to_number": null,
//                             "from_user_id": null,
//                             "lastapp": "Queue",
//                             "lastdata": "100272,b(predialer-queue-call,s,1(100272^100272^113612))rc,,,60",
//                             "pk": 2271873,
//                             "src": "+13052990233",
//                             "to_user_id": null,
//                             "uniqueid": "ast01.itpvoice.net-1723024488.113120",
//                             "userfield": null
//                         }
//                     ],
//                     "pk": 2271874,
//                     "src": "+13052990233",
//                     "to_user_id": null,
//                     "uniqueid": "ast01.itpvoice.net-1723024488.113120",
//                     "userfield": null
//                 },
//                 "item_type": "call",
//                 "message_body": "You missed a call from +13052990233",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+13052990233",
//                 "message_participant_id": "182969",
//                 "message_provider_id": null,
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-08-07 05:55:03",
//                 "message_timestamp_utc": "2024-08-07T09:55:03.995396",
//                 "mms_file_type": null,
//                 "pk": 319924,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "Hi",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+13052990233",
//                 "message_participant_id": "182969",
//                 "message_provider_id": "a0ebb194-fe84-4f09-85a1-7863e53494c2",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-08-07 05:50:09",
//                 "message_timestamp_utc": "2024-08-07T09:50:09.598018",
//                 "mms_file_type": null,
//                 "pk": 319923,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "hii",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1723023391577dmxpih6qhbjrlcrg",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-08-07 05:36:30",
//                 "message_timestamp_utc": "2024-08-07T09:36:30.199581",
//                 "mms_file_type": null,
//                 "pk": 319922,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "rhgrhrhrhr",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1720816110132lpg6wb5gjdbsyb6t",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-12 16:28:29",
//                 "message_timestamp_utc": "2024-07-12T20:28:29.441505",
//                 "mms_file_type": null,
//                 "pk": 287895,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "Hi",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+13052990233",
//                 "message_participant_id": "182969",
//                 "message_provider_id": "4757a7a3-60b2-4021-9b9b-f9db3e592cfe",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-12 16:28:23",
//                 "message_timestamp_utc": "2024-07-12T20:28:23.970310",
//                 "mms_file_type": null,
//                 "pk": 287894,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "1",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1720277332221hmrmoesv7uww7u7b",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-06 10:48:51",
//                 "message_timestamp_utc": "2024-07-06T14:48:51.124359",
//                 "mms_file_type": null,
//                 "pk": 279245,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "1",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1720218922686ztp2szz3xzvsamzg",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-05 18:35:21",
//                 "message_timestamp_utc": "2024-07-05T22:35:21.886597",
//                 "mms_file_type": null,
//                 "pk": 279162,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "1",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1720218911960ttnumeejpjtmabpx",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-05 18:35:11",
//                 "message_timestamp_utc": "2024-07-05T22:35:11.129974",
//                 "mms_file_type": null,
//                 "pk": 279161,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "1",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1720218900347fobvntghvx36bmg6",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-05 18:34:59",
//                 "message_timestamp_utc": "2024-07-05T22:34:59.659611",
//                 "mms_file_type": null,
//                 "pk": 279160,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "gg",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "1720217937701qvqodqpt6slh333q",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-05 18:18:56",
//                 "message_timestamp_utc": "2024-07-05T22:18:56.809263",
//                 "mms_file_type": null,
//                 "pk": 279156,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "call_answered_user_id": null,
//                 "call_back_response": {},
//                 "call_direction": null,
//                 "call_duration": 0,
//                 "call_status": null,
//                 "call_uniqueid": null,
//                 "item_type": "sms",
//                 "message_body": "hi",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": "17202151842976tfevebyjpku4kzz",
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-05 17:33:03",
//                 "message_timestamp_utc": "2024-07-05T21:33:03.617016",
//                 "mms_file_type": null,
//                 "pk": 279144,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "answered_by": {
//                     "account_id": 71,
//                     "admin_advanced_call_flows": true,
//                     "admin_ai": true,
//                     "admin_analytics": false,
//                     "admin_api_keys": true,
//                     "admin_forms": true,
//                     "admin_general_settings": true,
//                     "admin_live_panel": true,
//                     "admin_phone_numbers": true,
//                     "admin_ten_dlc": true,
//                     "admin_troubleshooting": true,
//                     "admin_users": true,
//                     "admin_webhooks": true,
//                     "admin_workflows": true,
//                     "calendly_access_token": "eyJraWQiOiIxY2UxZTEzNjE3ZGNmNzY2YjNjZWJjY2Y4ZGM1YmFmYThhNjVlNjg0MDIzZjdjMzJiZTgzNDliMjM4MDEzNWI0IiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJodHRwczovL2F1dGguY2FsZW5kbHkuY29tIiwiaWF0IjoxNzI0NjkzMjQwLCJqdGkiOiIxODkyOTkzMi00OTQ3LTRjZWEtYjUxZS1iNzM4ZWU1NDczYWYiLCJ1c2VyX3V1aWQiOiI1OTc1OWZmNS0zM2U3LTQ2YzYtOWZlYy01YTEwMGNhMzcxYzciLCJhcHBfdWlkIjoiVkNsWWtveEQ3UmFRRTFWZWdqOC1vNURVM1FWWDhzVk1YSERPU1RibmNuVSIsImV4cCI6MTcyNDcwMDQ0MH0.Sj5vrspPmUQodFfa4CNYxG9m9CVhsqFsVi7d9IUgJ8osKH-quVAShKaAKLQcVLujj0ZuBmOWVSXA0oLOfu8HOA",
//                     "calendly_error_with_integration": false,
//                     "calendly_refresh_token": "i8XHaMHC3N-2l0SLibnkwe8hM6k3NfF9JYZed1jhj0k",
//                     "calendly_scope": "default",
//                     "calendly_token_expiry": "2024-08-26T19:27:21+00:00",
//                     "calendly_token_type": "Bearer",
//                     "calendly_user_id": "https://api.calendly.com/users/59759ff5-33e7-46c6-9fec-5a100ca371c7",
//                     "call_recording_external": "optional",
//                     "call_recording_internal": "optional",
//                     "callforward_call_confirmation": false,
//                     "callforward_enable": true,
//                     "callforward_keep_caller_caller_id": false,
//                     "callforward_number": "3052990233",
//                     "callforward_queue_calls": false,
//                     "contacts_settings_display_columns": {},
//                     "crm_contact_id": 786,
//                     "crm_filters": {},
//                     "default_outbound_callerid_name": null,
//                     "default_outbound_callerid_number": null,
//                     "faxing_settings_enable_notifications": true,
//                     "historical_information": {},
//                     "jitter_buffer": false,
//                     "leads_settings_display_columns": {},
//                     "operator_panel_group_id": null,
//                     "operator_panel_setting_parking_slot_panel_pos": 3,
//                     "operator_panel_setting_queues_panel_pos": 2,
//                     "operator_panel_setting_show_parking_lot": true,
//                     "operator_panel_setting_show_queues": true,
//                     "operator_panel_setting_show_users": true,
//                     "operator_panel_setting_users_panel_pos": 1,
//                     "operator_panel_settings_users_panel_card_positions": {},
//                     "pk": 1202,
//                     "presence_id": "100",
//                     "priv_level": "admin",
//                     "scheduling_ai_last_used": null,
//                     "status": null,
//                     "user_settings": null,
//                     "user_volume_preference": 100,
//                     "vm_to_email_enabled": true,
//                     "voicemail_box_id": "286",
//                     "voicemail_enabled": true,
//                     "web_phone_call_waiting": false,
//                     "web_phone_enabled": true
//                 },
//                 "call_answered_user_id": 1202,
//                 "call_back_response": {},
//                 "call_direction": "outbound",
//                 "call_duration": 0,
//                 "call_status": "answered",
//                 "call_uniqueid": "ast01.itpvoice.net-1720141017.10",
//                 "cdr": {
//                     "account_id": "71",
//                     "accountcode": null,
//                     "amaflags": 3,
//                     "billsec": 2,
//                     "call_recording_filename": null,
//                     "calldate": "1720141017.0",
//                     "channel": "PJSIP/km01-00000005",
//                     "clid": "\"None\" <+17866340769>",
//                     "customer_cost": "0.0000",
//                     "dcontext": "from-internal",
//                     "disposition": "ANSWERED",
//                     "dnis": null,
//                     "dst": "3052990233",
//                     "dstchannel": null,
//                     "duration": 2,
//                     "forwarded_original_caller_id": null,
//                     "forwarded_to_number": null,
//                     "from_user_id": 1202,
//                     "lastapp": "Dial",
//                     "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                     "legs": [
//                         {
//                             "account_id": "71",
//                             "accountcode": null,
//                             "amaflags": 3,
//                             "billsec": 2,
//                             "call_recording_filename": null,
//                             "calldate": "1720141017.0",
//                             "channel": "PJSIP/km01-00000005",
//                             "clid": "\"None\" <+17866340769>",
//                             "customer_cost": "0.0000",
//                             "dcontext": "from-internal",
//                             "disposition": "ANSWERED",
//                             "dnis": null,
//                             "dst": "3052990233",
//                             "dstchannel": null,
//                             "duration": 2,
//                             "forwarded_original_caller_id": null,
//                             "forwarded_to_number": null,
//                             "from_user_id": 1202,
//                             "lastapp": "Dial",
//                             "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                             "pk": 2199177,
//                             "src": "+17866340769",
//                             "to_user_id": null,
//                             "uniqueid": "ast01.itpvoice.net-1720141017.10",
//                             "userfield": null
//                         }
//                     ],
//                     "pk": 2199177,
//                     "src": "+17866340769",
//                     "to_user_id": null,
//                     "uniqueid": "ast01.itpvoice.net-1720141017.10",
//                     "userfield": null
//                 },
//                 "item_type": "call",
//                 "message_body": "You made a call to +13052990233",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": null,
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-04 20:57:03",
//                 "message_timestamp_utc": "2024-07-05T00:57:03.131783",
//                 "mms_file_type": null,
//                 "pk": 278679,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "answered_by": {
//                     "account_id": 71,
//                     "admin_advanced_call_flows": true,
//                     "admin_ai": true,
//                     "admin_analytics": false,
//                     "admin_api_keys": true,
//                     "admin_forms": true,
//                     "admin_general_settings": true,
//                     "admin_live_panel": true,
//                     "admin_phone_numbers": true,
//                     "admin_ten_dlc": true,
//                     "admin_troubleshooting": true,
//                     "admin_users": true,
//                     "admin_webhooks": true,
//                     "admin_workflows": true,
//                     "calendly_access_token": "eyJraWQiOiIxY2UxZTEzNjE3ZGNmNzY2YjNjZWJjY2Y4ZGM1YmFmYThhNjVlNjg0MDIzZjdjMzJiZTgzNDliMjM4MDEzNWI0IiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJodHRwczovL2F1dGguY2FsZW5kbHkuY29tIiwiaWF0IjoxNzI0NjkzMjQwLCJqdGkiOiIxODkyOTkzMi00OTQ3LTRjZWEtYjUxZS1iNzM4ZWU1NDczYWYiLCJ1c2VyX3V1aWQiOiI1OTc1OWZmNS0zM2U3LTQ2YzYtOWZlYy01YTEwMGNhMzcxYzciLCJhcHBfdWlkIjoiVkNsWWtveEQ3UmFRRTFWZWdqOC1vNURVM1FWWDhzVk1YSERPU1RibmNuVSIsImV4cCI6MTcyNDcwMDQ0MH0.Sj5vrspPmUQodFfa4CNYxG9m9CVhsqFsVi7d9IUgJ8osKH-quVAShKaAKLQcVLujj0ZuBmOWVSXA0oLOfu8HOA",
//                     "calendly_error_with_integration": false,
//                     "calendly_refresh_token": "i8XHaMHC3N-2l0SLibnkwe8hM6k3NfF9JYZed1jhj0k",
//                     "calendly_scope": "default",
//                     "calendly_token_expiry": "2024-08-26T19:27:21+00:00",
//                     "calendly_token_type": "Bearer",
//                     "calendly_user_id": "https://api.calendly.com/users/59759ff5-33e7-46c6-9fec-5a100ca371c7",
//                     "call_recording_external": "optional",
//                     "call_recording_internal": "optional",
//                     "callforward_call_confirmation": false,
//                     "callforward_enable": true,
//                     "callforward_keep_caller_caller_id": false,
//                     "callforward_number": "3052990233",
//                     "callforward_queue_calls": false,
//                     "contacts_settings_display_columns": {},
//                     "crm_contact_id": 786,
//                     "crm_filters": {},
//                     "default_outbound_callerid_name": null,
//                     "default_outbound_callerid_number": null,
//                     "faxing_settings_enable_notifications": true,
//                     "historical_information": {},
//                     "jitter_buffer": false,
//                     "leads_settings_display_columns": {},
//                     "operator_panel_group_id": null,
//                     "operator_panel_setting_parking_slot_panel_pos": 3,
//                     "operator_panel_setting_queues_panel_pos": 2,
//                     "operator_panel_setting_show_parking_lot": true,
//                     "operator_panel_setting_show_queues": true,
//                     "operator_panel_setting_show_users": true,
//                     "operator_panel_setting_users_panel_pos": 1,
//                     "operator_panel_settings_users_panel_card_positions": {},
//                     "pk": 1202,
//                     "presence_id": "100",
//                     "priv_level": "admin",
//                     "scheduling_ai_last_used": null,
//                     "status": null,
//                     "user_settings": null,
//                     "user_volume_preference": 100,
//                     "vm_to_email_enabled": true,
//                     "voicemail_box_id": "286",
//                     "voicemail_enabled": true,
//                     "web_phone_call_waiting": false,
//                     "web_phone_enabled": true
//                 },
//                 "call_answered_user_id": 1202,
//                 "call_back_response": {},
//                 "call_direction": "outbound",
//                 "call_duration": 0,
//                 "call_status": "answered",
//                 "call_uniqueid": "ast01.itpvoice.net-1720140958.8",
//                 "cdr": {
//                     "account_id": "71",
//                     "accountcode": null,
//                     "amaflags": 3,
//                     "billsec": 2,
//                     "call_recording_filename": null,
//                     "calldate": "1720140958.0",
//                     "channel": "PJSIP/km01-00000004",
//                     "clid": "\"None\" <+17866340769>",
//                     "customer_cost": "0.0000",
//                     "dcontext": "from-internal",
//                     "disposition": "ANSWERED",
//                     "dnis": null,
//                     "dst": "3052990233",
//                     "dstchannel": null,
//                     "duration": 2,
//                     "forwarded_original_caller_id": null,
//                     "forwarded_to_number": null,
//                     "from_user_id": 1202,
//                     "lastapp": "Dial",
//                     "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                     "legs": [
//                         {
//                             "account_id": "71",
//                             "accountcode": null,
//                             "amaflags": 3,
//                             "billsec": 2,
//                             "call_recording_filename": null,
//                             "calldate": "1720140958.0",
//                             "channel": "PJSIP/km01-00000004",
//                             "clid": "\"None\" <+17866340769>",
//                             "customer_cost": "0.0000",
//                             "dcontext": "from-internal",
//                             "disposition": "ANSWERED",
//                             "dnis": null,
//                             "dst": "3052990233",
//                             "dstchannel": null,
//                             "duration": 2,
//                             "forwarded_original_caller_id": null,
//                             "forwarded_to_number": null,
//                             "from_user_id": 1202,
//                             "lastapp": "Dial",
//                             "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                             "pk": 2199176,
//                             "src": "+17866340769",
//                             "to_user_id": null,
//                             "uniqueid": "ast01.itpvoice.net-1720140958.8",
//                             "userfield": null
//                         }
//                     ],
//                     "pk": 2199176,
//                     "src": "+17866340769",
//                     "to_user_id": null,
//                     "uniqueid": "ast01.itpvoice.net-1720140958.8",
//                     "userfield": null
//                 },
//                 "item_type": "call",
//                 "message_body": "You made a call to +13052990233",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": null,
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-04 20:56:03",
//                 "message_timestamp_utc": "2024-07-05T00:56:03.243229",
//                 "mms_file_type": null,
//                 "pk": 278678,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "answered_by": {
//                     "account_id": 71,
//                     "admin_advanced_call_flows": true,
//                     "admin_ai": true,
//                     "admin_analytics": false,
//                     "admin_api_keys": true,
//                     "admin_forms": true,
//                     "admin_general_settings": true,
//                     "admin_live_panel": true,
//                     "admin_phone_numbers": true,
//                     "admin_ten_dlc": true,
//                     "admin_troubleshooting": true,
//                     "admin_users": true,
//                     "admin_webhooks": true,
//                     "admin_workflows": true,
//                     "calendly_access_token": "eyJraWQiOiIxY2UxZTEzNjE3ZGNmNzY2YjNjZWJjY2Y4ZGM1YmFmYThhNjVlNjg0MDIzZjdjMzJiZTgzNDliMjM4MDEzNWI0IiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJodHRwczovL2F1dGguY2FsZW5kbHkuY29tIiwiaWF0IjoxNzI0NjkzMjQwLCJqdGkiOiIxODkyOTkzMi00OTQ3LTRjZWEtYjUxZS1iNzM4ZWU1NDczYWYiLCJ1c2VyX3V1aWQiOiI1OTc1OWZmNS0zM2U3LTQ2YzYtOWZlYy01YTEwMGNhMzcxYzciLCJhcHBfdWlkIjoiVkNsWWtveEQ3UmFRRTFWZWdqOC1vNURVM1FWWDhzVk1YSERPU1RibmNuVSIsImV4cCI6MTcyNDcwMDQ0MH0.Sj5vrspPmUQodFfa4CNYxG9m9CVhsqFsVi7d9IUgJ8osKH-quVAShKaAKLQcVLujj0ZuBmOWVSXA0oLOfu8HOA",
//                     "calendly_error_with_integration": false,
//                     "calendly_refresh_token": "i8XHaMHC3N-2l0SLibnkwe8hM6k3NfF9JYZed1jhj0k",
//                     "calendly_scope": "default",
//                     "calendly_token_expiry": "2024-08-26T19:27:21+00:00",
//                     "calendly_token_type": "Bearer",
//                     "calendly_user_id": "https://api.calendly.com/users/59759ff5-33e7-46c6-9fec-5a100ca371c7",
//                     "call_recording_external": "optional",
//                     "call_recording_internal": "optional",
//                     "callforward_call_confirmation": false,
//                     "callforward_enable": true,
//                     "callforward_keep_caller_caller_id": false,
//                     "callforward_number": "3052990233",
//                     "callforward_queue_calls": false,
//                     "contacts_settings_display_columns": {},
//                     "crm_contact_id": 786,
//                     "crm_filters": {},
//                     "default_outbound_callerid_name": null,
//                     "default_outbound_callerid_number": null,
//                     "faxing_settings_enable_notifications": true,
//                     "historical_information": {},
//                     "jitter_buffer": false,
//                     "leads_settings_display_columns": {},
//                     "operator_panel_group_id": null,
//                     "operator_panel_setting_parking_slot_panel_pos": 3,
//                     "operator_panel_setting_queues_panel_pos": 2,
//                     "operator_panel_setting_show_parking_lot": true,
//                     "operator_panel_setting_show_queues": true,
//                     "operator_panel_setting_show_users": true,
//                     "operator_panel_setting_users_panel_pos": 1,
//                     "operator_panel_settings_users_panel_card_positions": {},
//                     "pk": 1202,
//                     "presence_id": "100",
//                     "priv_level": "admin",
//                     "scheduling_ai_last_used": null,
//                     "status": null,
//                     "user_settings": null,
//                     "user_volume_preference": 100,
//                     "vm_to_email_enabled": true,
//                     "voicemail_box_id": "286",
//                     "voicemail_enabled": true,
//                     "web_phone_call_waiting": false,
//                     "web_phone_enabled": true
//                 },
//                 "call_answered_user_id": 1202,
//                 "call_back_response": {},
//                 "call_direction": "outbound",
//                 "call_duration": 0,
//                 "call_status": "answered",
//                 "call_uniqueid": "ast01.itpvoice.net-1720140844.4",
//                 "cdr": {
//                     "account_id": "71",
//                     "accountcode": null,
//                     "amaflags": 3,
//                     "billsec": 1,
//                     "call_recording_filename": null,
//                     "calldate": "1720140844.0",
//                     "channel": "PJSIP/km01-00000002",
//                     "clid": "\"None\" <+17866340769>",
//                     "customer_cost": "0.0000",
//                     "dcontext": "from-internal",
//                     "disposition": "ANSWERED",
//                     "dnis": null,
//                     "dst": "3052990233",
//                     "dstchannel": null,
//                     "duration": 1,
//                     "forwarded_original_caller_id": null,
//                     "forwarded_to_number": null,
//                     "from_user_id": 1202,
//                     "lastapp": "Dial",
//                     "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                     "legs": [
//                         {
//                             "account_id": "71",
//                             "accountcode": null,
//                             "amaflags": 3,
//                             "billsec": 1,
//                             "call_recording_filename": null,
//                             "calldate": "1720140844.0",
//                             "channel": "PJSIP/km01-00000002",
//                             "clid": "\"None\" <+17866340769>",
//                             "customer_cost": "0.0000",
//                             "dcontext": "from-internal",
//                             "disposition": "ANSWERED",
//                             "dnis": null,
//                             "dst": "3052990233",
//                             "dstchannel": null,
//                             "duration": 1,
//                             "forwarded_original_caller_id": null,
//                             "forwarded_to_number": null,
//                             "from_user_id": 1202,
//                             "lastapp": "Dial",
//                             "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                             "pk": 2199174,
//                             "src": "+17866340769",
//                             "to_user_id": null,
//                             "uniqueid": "ast01.itpvoice.net-1720140844.4",
//                             "userfield": null
//                         }
//                     ],
//                     "pk": 2199174,
//                     "src": "+17866340769",
//                     "to_user_id": null,
//                     "uniqueid": "ast01.itpvoice.net-1720140844.4",
//                     "userfield": null
//                 },
//                 "item_type": "call",
//                 "message_body": "You made a call to +13052990233",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": null,
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-04 20:54:09",
//                 "message_timestamp_utc": "2024-07-05T00:54:09.981819",
//                 "mms_file_type": null,
//                 "pk": 278676,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "answered_by": {
//                     "account_id": 71,
//                     "admin_advanced_call_flows": true,
//                     "admin_ai": true,
//                     "admin_analytics": false,
//                     "admin_api_keys": true,
//                     "admin_forms": true,
//                     "admin_general_settings": true,
//                     "admin_live_panel": true,
//                     "admin_phone_numbers": true,
//                     "admin_ten_dlc": true,
//                     "admin_troubleshooting": true,
//                     "admin_users": true,
//                     "admin_webhooks": true,
//                     "admin_workflows": true,
//                     "calendly_access_token": "eyJraWQiOiIxY2UxZTEzNjE3ZGNmNzY2YjNjZWJjY2Y4ZGM1YmFmYThhNjVlNjg0MDIzZjdjMzJiZTgzNDliMjM4MDEzNWI0IiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJodHRwczovL2F1dGguY2FsZW5kbHkuY29tIiwiaWF0IjoxNzI0NjkzMjQwLCJqdGkiOiIxODkyOTkzMi00OTQ3LTRjZWEtYjUxZS1iNzM4ZWU1NDczYWYiLCJ1c2VyX3V1aWQiOiI1OTc1OWZmNS0zM2U3LTQ2YzYtOWZlYy01YTEwMGNhMzcxYzciLCJhcHBfdWlkIjoiVkNsWWtveEQ3UmFRRTFWZWdqOC1vNURVM1FWWDhzVk1YSERPU1RibmNuVSIsImV4cCI6MTcyNDcwMDQ0MH0.Sj5vrspPmUQodFfa4CNYxG9m9CVhsqFsVi7d9IUgJ8osKH-quVAShKaAKLQcVLujj0ZuBmOWVSXA0oLOfu8HOA",
//                     "calendly_error_with_integration": false,
//                     "calendly_refresh_token": "i8XHaMHC3N-2l0SLibnkwe8hM6k3NfF9JYZed1jhj0k",
//                     "calendly_scope": "default",
//                     "calendly_token_expiry": "2024-08-26T19:27:21+00:00",
//                     "calendly_token_type": "Bearer",
//                     "calendly_user_id": "https://api.calendly.com/users/59759ff5-33e7-46c6-9fec-5a100ca371c7",
//                     "call_recording_external": "optional",
//                     "call_recording_internal": "optional",
//                     "callforward_call_confirmation": false,
//                     "callforward_enable": true,
//                     "callforward_keep_caller_caller_id": false,
//                     "callforward_number": "3052990233",
//                     "callforward_queue_calls": false,
//                     "contacts_settings_display_columns": {},
//                     "crm_contact_id": 786,
//                     "crm_filters": {},
//                     "default_outbound_callerid_name": null,
//                     "default_outbound_callerid_number": null,
//                     "faxing_settings_enable_notifications": true,
//                     "historical_information": {},
//                     "jitter_buffer": false,
//                     "leads_settings_display_columns": {},
//                     "operator_panel_group_id": null,
//                     "operator_panel_setting_parking_slot_panel_pos": 3,
//                     "operator_panel_setting_queues_panel_pos": 2,
//                     "operator_panel_setting_show_parking_lot": true,
//                     "operator_panel_setting_show_queues": true,
//                     "operator_panel_setting_show_users": true,
//                     "operator_panel_setting_users_panel_pos": 1,
//                     "operator_panel_settings_users_panel_card_positions": {},
//                     "pk": 1202,
//                     "presence_id": "100",
//                     "priv_level": "admin",
//                     "scheduling_ai_last_used": null,
//                     "status": null,
//                     "user_settings": null,
//                     "user_volume_preference": 100,
//                     "vm_to_email_enabled": true,
//                     "voicemail_box_id": "286",
//                     "voicemail_enabled": true,
//                     "web_phone_call_waiting": false,
//                     "web_phone_enabled": true
//                 },
//                 "call_answered_user_id": 1202,
//                 "call_back_response": {},
//                 "call_direction": "outbound",
//                 "call_duration": 0,
//                 "call_status": "answered",
//                 "call_uniqueid": "ast01.itpvoice.net-1720140800.2",
//                 "cdr": {
//                     "account_id": "71",
//                     "accountcode": null,
//                     "amaflags": 3,
//                     "billsec": 3,
//                     "call_recording_filename": null,
//                     "calldate": "1720140800.0",
//                     "channel": "PJSIP/km01-00000001",
//                     "clid": "\"None\" <+17866340769>",
//                     "customer_cost": "0.0000",
//                     "dcontext": "from-internal",
//                     "disposition": "ANSWERED",
//                     "dnis": null,
//                     "dst": "3052990233",
//                     "dstchannel": null,
//                     "duration": 3,
//                     "forwarded_original_caller_id": null,
//                     "forwarded_to_number": null,
//                     "from_user_id": 1202,
//                     "lastapp": "Dial",
//                     "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                     "legs": [
//                         {
//                             "account_id": "71",
//                             "accountcode": null,
//                             "amaflags": 3,
//                             "billsec": 3,
//                             "call_recording_filename": null,
//                             "calldate": "1720140800.0",
//                             "channel": "PJSIP/km01-00000001",
//                             "clid": "\"None\" <+17866340769>",
//                             "customer_cost": "0.0000",
//                             "dcontext": "from-internal",
//                             "disposition": "ANSWERED",
//                             "dnis": null,
//                             "dst": "3052990233",
//                             "dstchannel": null,
//                             "duration": 3,
//                             "forwarded_original_caller_id": null,
//                             "forwarded_to_number": null,
//                             "from_user_id": 1202,
//                             "lastapp": "Dial",
//                             "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                             "pk": 2199173,
//                             "src": "+17866340769",
//                             "to_user_id": null,
//                             "uniqueid": "ast01.itpvoice.net-1720140800.2",
//                             "userfield": null
//                         }
//                     ],
//                     "pk": 2199173,
//                     "src": "+17866340769",
//                     "to_user_id": null,
//                     "uniqueid": "ast01.itpvoice.net-1720140800.2",
//                     "userfield": null
//                 },
//                 "item_type": "call",
//                 "message_body": "You made a call to +13052990233",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": null,
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-04 20:53:27",
//                 "message_timestamp_utc": "2024-07-05T00:53:27.620630",
//                 "mms_file_type": null,
//                 "pk": 278675,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             },
//             {
//                 "answered_by": {
//                     "account_id": 71,
//                     "admin_advanced_call_flows": true,
//                     "admin_ai": true,
//                     "admin_analytics": false,
//                     "admin_api_keys": true,
//                     "admin_forms": true,
//                     "admin_general_settings": true,
//                     "admin_live_panel": true,
//                     "admin_phone_numbers": true,
//                     "admin_ten_dlc": true,
//                     "admin_troubleshooting": true,
//                     "admin_users": true,
//                     "admin_webhooks": true,
//                     "admin_workflows": true,
//                     "calendly_access_token": "eyJraWQiOiIxY2UxZTEzNjE3ZGNmNzY2YjNjZWJjY2Y4ZGM1YmFmYThhNjVlNjg0MDIzZjdjMzJiZTgzNDliMjM4MDEzNWI0IiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJodHRwczovL2F1dGguY2FsZW5kbHkuY29tIiwiaWF0IjoxNzI0NjkzMjQwLCJqdGkiOiIxODkyOTkzMi00OTQ3LTRjZWEtYjUxZS1iNzM4ZWU1NDczYWYiLCJ1c2VyX3V1aWQiOiI1OTc1OWZmNS0zM2U3LTQ2YzYtOWZlYy01YTEwMGNhMzcxYzciLCJhcHBfdWlkIjoiVkNsWWtveEQ3UmFRRTFWZWdqOC1vNURVM1FWWDhzVk1YSERPU1RibmNuVSIsImV4cCI6MTcyNDcwMDQ0MH0.Sj5vrspPmUQodFfa4CNYxG9m9CVhsqFsVi7d9IUgJ8osKH-quVAShKaAKLQcVLujj0ZuBmOWVSXA0oLOfu8HOA",
//                     "calendly_error_with_integration": false,
//                     "calendly_refresh_token": "i8XHaMHC3N-2l0SLibnkwe8hM6k3NfF9JYZed1jhj0k",
//                     "calendly_scope": "default",
//                     "calendly_token_expiry": "2024-08-26T19:27:21+00:00",
//                     "calendly_token_type": "Bearer",
//                     "calendly_user_id": "https://api.calendly.com/users/59759ff5-33e7-46c6-9fec-5a100ca371c7",
//                     "call_recording_external": "optional",
//                     "call_recording_internal": "optional",
//                     "callforward_call_confirmation": false,
//                     "callforward_enable": true,
//                     "callforward_keep_caller_caller_id": false,
//                     "callforward_number": "3052990233",
//                     "callforward_queue_calls": false,
//                     "contacts_settings_display_columns": {},
//                     "crm_contact_id": 786,
//                     "crm_filters": {},
//                     "default_outbound_callerid_name": null,
//                     "default_outbound_callerid_number": null,
//                     "faxing_settings_enable_notifications": true,
//                     "historical_information": {},
//                     "jitter_buffer": false,
//                     "leads_settings_display_columns": {},
//                     "operator_panel_group_id": null,
//                     "operator_panel_setting_parking_slot_panel_pos": 3,
//                     "operator_panel_setting_queues_panel_pos": 2,
//                     "operator_panel_setting_show_parking_lot": true,
//                     "operator_panel_setting_show_queues": true,
//                     "operator_panel_setting_show_users": true,
//                     "operator_panel_setting_users_panel_pos": 1,
//                     "operator_panel_settings_users_panel_card_positions": {},
//                     "pk": 1202,
//                     "presence_id": "100",
//                     "priv_level": "admin",
//                     "scheduling_ai_last_used": null,
//                     "status": null,
//                     "user_settings": null,
//                     "user_volume_preference": 100,
//                     "vm_to_email_enabled": true,
//                     "voicemail_box_id": "286",
//                     "voicemail_enabled": true,
//                     "web_phone_call_waiting": false,
//                     "web_phone_enabled": true
//                 },
//                 "call_answered_user_id": 1202,
//                 "call_back_response": {},
//                 "call_direction": "outbound",
//                 "call_duration": 0,
//                 "call_status": "answered",
//                 "call_uniqueid": "ast01.itpvoice.net-1720140791.0",
//                 "cdr": {
//                     "account_id": "71",
//                     "accountcode": null,
//                     "amaflags": 3,
//                     "billsec": 3,
//                     "call_recording_filename": null,
//                     "calldate": "1720140791.0",
//                     "channel": "PJSIP/km01-00000000",
//                     "clid": "\"None\" <+17866340769>",
//                     "customer_cost": "0.0000",
//                     "dcontext": "from-internal",
//                     "disposition": "ANSWERED",
//                     "dnis": null,
//                     "dst": "3052990233",
//                     "dstchannel": null,
//                     "duration": 3,
//                     "forwarded_original_caller_id": null,
//                     "forwarded_to_number": null,
//                     "from_user_id": 1202,
//                     "lastapp": "Dial",
//                     "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                     "legs": [
//                         {
//                             "account_id": "71",
//                             "accountcode": null,
//                             "amaflags": 3,
//                             "billsec": 3,
//                             "call_recording_filename": null,
//                             "calldate": "1720140791.0",
//                             "channel": "PJSIP/km01-00000000",
//                             "clid": "\"None\" <+17866340769>",
//                             "customer_cost": "0.0000",
//                             "dcontext": "from-internal",
//                             "disposition": "ANSWERED",
//                             "dnis": null,
//                             "dst": "3052990233",
//                             "dstchannel": null,
//                             "duration": 3,
//                             "forwarded_original_caller_id": null,
//                             "forwarded_to_number": null,
//                             "from_user_id": 1202,
//                             "lastapp": "Dial",
//                             "lastdata": "PJSIP/sbc01-outbound/sip:+13052990233@sbc01.itpvoice.net,45,rU(post-answer^^71^",
//                             "pk": 2199172,
//                             "src": "+17866340769",
//                             "to_user_id": null,
//                             "uniqueid": "ast01.itpvoice.net-1720140791.0",
//                             "userfield": null
//                         }
//                     ],
//                     "pk": 2199172,
//                     "src": "+17866340769",
//                     "to_user_id": null,
//                     "uniqueid": "ast01.itpvoice.net-1720140791.0",
//                     "userfield": null
//                 },
//                 "item_type": "call",
//                 "message_body": "You made a call to +13052990233",
//                 "message_error_code": null,
//                 "message_error_description": null,
//                 "message_mms_media": null,
//                 "message_participant": "+17866340769",
//                 "message_participant_id": "182970",
//                 "message_provider_id": null,
//                 "message_status": "delivered",
//                 "message_thread_id": 91285,
//                 "message_timestamp": "2024-07-04 20:53:19",
//                 "message_timestamp_utc": "2024-07-05T00:53:19.272851",
//                 "mms_file_type": null,
//                 "pk": 278674,
//                 "voicemail_duration": 0,
//                 "voicemail_id": null,
//                 "voicemail_link": null,
//                 "voicemail_transcription": null
//             }
//         ],
//         "participants": [
//             {
//                 "is_self": false,
//                 "message_thread_id": "91285",
//                 "number": "+13052990233",
//                 "pk": 182969
//             },
//             {
//                 "is_self": false,
//                 "message_thread_id": "91285",
//                 "number": "+17866340769",
//                 "pk": 182970
//             }
//         ]
//     }
// }