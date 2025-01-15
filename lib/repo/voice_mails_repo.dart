import 'package:itp_voice/models/get_voice_mails_response_model/get_voice_mails_response_model.dart';
import 'package:itp_voice/repo/base_requester.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/storage_keys.dart';

class VoiceMailsRepo {


  Future<dynamic> getVoiceMails() async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);
    try {
      final apiResponse = await BaseRequesterMethods.baseRequester.baseGetAPI(
        Endpoints.GET_VOICE_MAILS_URL(apiId),
      );

      if (!apiResponse['errors']) {
        // Parse the response using the new data structure
        GetVoiceMailsResponseModel response =
            GetVoiceMailsResponseModel.fromMap(apiResponse);
        // Check if the result contains voicemail data
        if (response.result != null && response.result!.isNotEmpty) {
          return response; // Return the valid response model
        } else {
          return "No voicemails found"; // Handle the case where no data is returned
        }
      }

      return "Something went wrong"; // Handle errors in the response
    } catch (e) {
      print(e.toString());
      return "Something went wrong"; // Handle exceptions
    }
  }

  deleteVoicemail(id) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      final apiResponse =
          await BaseRequesterMethods.baseRequester.baseDeleteAPI(
        "${Endpoints.DELETE_VOICE_MAIL_MESSAGE(apiId)}/$id",
        null,
        protected: true,
      );

      if (!apiResponse['errors']) {
        return true;
      }
      return "Something went wrong";
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }
}
