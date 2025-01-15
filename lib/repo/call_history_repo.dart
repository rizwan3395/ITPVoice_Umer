import 'dart:developer';

import 'package:itp_voice/controllers/call_history_controller.dart';
import 'package:itp_voice/models/call_history_model.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/get_contacts_reponse_model.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/user_contact.dart';
import 'package:itp_voice/repo/base_requester.dart';
import 'package:itp_voice/repo/contacts_repo.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/storage_keys.dart';

class CallHistoryRepo {
  Future<List<CallHistory>> fetchCallHistory({required int offSet}) async {
    List<CallHistory> callHistoryList = [];
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);
    String? userId = SharedPreferencesMethod.getString(StorageKeys.USER_ID);
    String myPhoneNumber = SharedPreferencesMethod.storage.getString(StorageKeys.DEFAULT_NUMBER)!;
    String myExtension = SharedPreferencesMethod.storage.getString(StorageKeys.EXTENTION)!;

    try {
      final apiResponse = await BaseRequesterMethods.baseRequester
          .baseGetAPI(Endpoints.GET_CALL_HISTORY(apiId, offSet));
      
      if (!apiResponse['errors']) {
        int itemCount = apiResponse['item_count'];
        log('Item count: $itemCount');

        Map<String, dynamic> calls = apiResponse['result'] as Map<String, dynamic>;

        for (var callData in calls.values) {
          if (callData == null) continue; // Handle null call data

          CallHistory callHistory = CallHistory(
            name: (callData['src'] == myExtension || callData['src'] == myPhoneNumber)
                ? callData['clid']?.split("<")[0].replaceAll('"', "") ?? "Unknown"
                : callData['src'] ?? "Unknown",
            time: DateTime.fromMillisecondsSinceEpoch(
              int.parse(callData['calldate'].toString().split('.')[0]) * 1000
            ),
            isIncoming: callData['from_user_id'].toString() != userId,
            isMissed: callData['disposition'] != "ANSWERED",
            numberToDial: callData['from_user_id'].toString() != userId
                ? callData['src'] ?? "Unknown"
                : callData['dst'] ?? "Unknown",
          );
          
          callHistoryList.add(callHistory);
        }

        return callHistoryList;
      } else {
        log('Error fetching call history: ${apiResponse['message']}');
        return [];
      }
    } catch (e) {
      log('Error fetching call history: ${e.toString()}');
      return [];
    }
  }
}
