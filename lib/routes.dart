import 'package:get/get.dart';
import 'package:itp_voice/controllers/call_history_controller.dart';
import 'package:itp_voice/helpers/config.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/contactList.dart';
import 'package:itp_voice/screens/add_new_contact.dart';
import 'package:itp_voice/screens/base_screen.dart';
import 'package:itp_voice/screens/call_history_screen.dart';
import 'package:itp_voice/screens/call_recording_screen.dart';
import 'package:itp_voice/screens/call_screen.dart';
import 'package:itp_voice/screens/call_settings_screen.dart';
import 'package:itp_voice/screens/caller_id_screen.dart';
import 'package:itp_voice/screens/change_password_screen.dart';
import 'package:itp_voice/screens/chat_info_screen.dart';
import 'package:itp_voice/screens/chat_screen.dart';
import 'package:itp_voice/screens/contact_details_screen.dart';
import 'package:itp_voice/screens/contact_lists.dart';
import 'package:itp_voice/screens/edit_contact_screen.dart';
import 'package:itp_voice/screens/edit_profile_screen.dart';
import 'package:itp_voice/screens/forgot_password_screen.dart';
import 'package:itp_voice/screens/in_call_dialpad.dart';
import 'package:itp_voice/screens/login_screen.dart';
import 'package:itp_voice/screens/privacy_policy_screen.dart';
import 'package:itp_voice/screens/settings_screen.dart';
import 'package:itp_voice/screens/signup_screen.dart';
import 'package:itp_voice/screens/signup_screen_1.dart';
import 'package:itp_voice/screens/tags_screen.dart';
import 'package:itp_voice/screens/verification_screen.dart';
import 'package:itp_voice/screens/voice_mail_details_screen.dart';
import 'package:itp_voice/screens/voice_mail_setting_screen.dart';

class AppRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: Routes.BASE_SCREEN_ROUTE,
      page: () => BaseScreen(),
    ),
    GetPage(
      name: Routes.LOGIN_SCREEN_ROUTE,
      page: () => LoginScreen(),
    ),
    GetPage(
        name: Routes.CONTACTS_LIST_SCREEN_ROUTE, page: () => ContactLists()),
    GetPage(
        name: Routes.CONTACT_DETAIS_SCREEN_ROUTE,
        page: () => ContactDetailsScreen()),
    GetPage(
        name: Routes.CALL_HISTORY_SCREEN_ROUTE,
        page: () => CallHistoryScreen()),
    GetPage(
        name: Routes.VOICE_MAIL_DETAILS_ROUTE,
        page: () => VoiceMailDetailsScreen()),
    GetPage(
      name: Routes.SETTINGS_SCREEN_ROUTE,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: Routes.CALL_SETTINGS_ROUTE,
      page: () => CallSettingsScreen(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD_ROUTE,
      page: () => ChangePassordScreen(),
    ),
    GetPage(
      name: Routes.ADD_NEW_CONTACT_ROUTE,
      page: () => AddNewContactScreen(),
    ),
    GetPage(
      name: Routes.ADD_NEW_CONTACT_ROUTE,
      page: () => AddNewContactScreen(),
    ),
    GetPage(
      name: Routes.CHAT_SCREEN_ROUTE,
      page: () => ChatScreen(),
    ),
    GetPage(
      name: Routes.CALL_SCREEN_ROUTE,
      page: () => CallScreen(),
    ),
    GetPage(
      name: Routes.DIALPAD_SCREEN_ROUTE,
      page: () => InCallDialPad(),
    ),
    GetPage(
      name: Routes.EDIT_CONTACT_ROUTE,
      page: () => EditContactScreen(),
    ),
    GetPage(
      name: Routes.CHAT_DETAIL_ROUTE,
      page: () => ChatInfoScreen(),
    ),
    GetPage(
      name: Routes.SIGNUP_SCREEN_ROUTE,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE_SCREEN_ROUTE,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: Routes.VERIFY_OTP_ROUTE,
      page: () => const VerificationScreen(),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY_SCREEN_ROUTE,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: Routes.CALL_RECORDING_SETTING_SCREEN,
      page: () => CallRecordingScreen(),
    ),
    GetPage(
      name: Routes.VOICE_MAIL_SETTING_ROUTE,
      page: () => VoiceMailSettingScreen(),
    ),
    GetPage(
      name: Routes.FORGET_PASSWORD_ROUTE,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(name: Routes.CALLER_ID_SCREEN_ROUTE, page: () => CallerIdScreen()),
    GetPage(
        name: Routes.SIGNUP_SCREEN_1_ROUTE, page: () => const SignupScreen1()),
    GetPage(name: Routes.TAGS_SCREEN_ROUTE, page: () => TagsScreen()),
  ];
}

class Routes {
  static String BASE_SCREEN_ROUTE = '/';
  static String LOGIN_SCREEN_ROUTE = '/login_screen_route';
  static String EDIT_PROFILE_SCREEN_ROUTE = '/edit_profile_screen_route';
  static String CALLER_ID_SCREEN_ROUTE = '/caller_id_screen_route';
  static String VOICE_MAIL_DETAILS_ROUTE = '/voice_mail_details_route';
  static String VOICE_MAIL_SETTING_ROUTE = '/voice_mail_setting_route';
  static String CALL_HISTORY_SCREEN_ROUTE = '/call_history_screen_route';
  static String CALL_RECORDING_SETTING_SCREEN = '/call_recording_screen_route';
  static String CONTACT_DETAIS_SCREEN_ROUTE = '/contact_details_screen_route';
  static String SETTINGS_SCREEN_ROUTE = '/settings_screen_route';
  static String CALL_SETTINGS_ROUTE = '/call_settings_route';
  static String CHANGE_PASSWORD_ROUTE = '/change_password_route';
  static String ADD_NEW_CONTACT_ROUTE = '/add_new_contact_screen_route';
  static String CHAT_SCREEN_ROUTE = '/chat_screen_route';
  static String PRIVACY_POLICY_SCREEN_ROUTE = '/privacy_policy_screen_route';
  static String CALL_SCREEN_ROUTE = '/call_screen_route';
  static String DIALPAD_SCREEN_ROUTE = '/dialpad_screen_route';
  static String FORGET_PASSWORD_ROUTE = '/forget_password_route';
  static String EDIT_CONTACT_ROUTE = '/edit_contact_screen_route';
  static String CHAT_DETAIL_ROUTE = '/chat_detail_screen_route';
  static String SIGNUP_SCREEN_ROUTE = '/sign_up_screen_route';
  static String VERIFY_OTP_ROUTE = '/verification_screen_route';
  static String SIGNUP_SCREEN_1_ROUTE = '/signup_screen_1_route';
  static String CONTACTS_LIST_SCREEN_ROUTE = '/contact_list_screen_route';
  static String TAGS_SCREEN_ROUTE = '/tags_screen_route';
}

class Endpoints {
  static String LOGIN_URL = "${Config.BASE_URL_CRM}/auth/login";
  static String LOGOUT_URL = "${Config.BASE_URL_CRM}/auth/logout";
  static String SERVICES_URL = "${Config.BASE_URL_CRM}/services";
  static String REFRESH_TOKEN_URL = "${Config.BASE_URL_CRM}/auth/refresh";
  static String USER_PROFILE = "${Config.BASE_URL_CRM}/myprofile";

  static String GET_DEVICES_URL(apiId) {
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/devices";
  }

  static String GET_ACCOUNT_DETAILS(apiId) {
    return Config.BASE_URL_ITP_VOICE + "$apiId";
  }

  static String EDIT_LIST_NAME(apiId, listId) {
    return "https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contact-lists/$listId";
  }

  static String FORGET_PASSWORD(username) {
    return "https://api.itpscorp.com/portal/crm/auth/reset-pw?username=$username&from=voice360";
  }

  static String GET_SETTINGS(apiId) {
    return "https://api.itpscorp.com/portal/itpvoice/v2/$apiId/my-extension";
  }

  static String GET_SETTINGS_VOICE(apiId) {
    return "https://api.itpscorp.com/portal/itpvoice/v2/$apiId/my-extension/voicemail";
  }

  static String GET_CONTACT_LISTS(apiId, offset) {
    return "https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contact-lists?offset=$offset&limit=10";
  }

  static String EDIT_TAG(apiId, tagId) {
    return "https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/tags/$tagId";
  }

  static String ADD_TAG(apiId) {
    return "https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/tags";
  }

  static String ADD_LIST(apiId) {
    return "https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contact-lists";
  }

  static String GET_TAG_LISTS(apiId, offset) {
    return "https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/tags?offset=$offset&limit=10";
  }

  static String GET_CONTACT_LIST(apiId) {
    return "https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contact-lists?name=";
  }

  static String CREATE_CONTACT_URL(apiId) {
    return 'https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contacts';
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/contacts";
  }

  static String UPDATE_CONTACT_URL(apiId) {
    return 'https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contacts';
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/contacts";
  }

  static String ADD_TAG_ON_CONTACT(apiId, contactId) {
    return 'https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contacts/$contactId';
  }

  static String DELETE_CONTACT(apiId) {
    return 'https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contacts';
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/contacts";
  }

  static String DELETE_TAG(apiId, id) {
    return 'https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/tags/$id';
  }

  static String DELETE_LIST(apiId, id) {
    return 'https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contact-lists/$id';
  }

  static String GET_CONTACTS_URL(apiId, offSet) {
    return 'https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contacts?offset=$offSet&limit=20';
    return Config.BASE_URL_ITP_VOICE +
        "$apiId/my-extension/contacts?unlimit=true";
  }

  static String SEARCH_CONTACTS_URL(apiId, offSet, query) {
    return 'https://api.itpscorp.com/portal/360/accounts/$apiId/my-account/contacts?offset=$offSet&limit=20&firstname=$query&lastname=$query';
  }

  static String GET_VOICE_MAILS_URL(apiId) {
    return Config.BASE_URL_ITP_VOICE +
        "$apiId/my-extension/voicemail-messages?pagination=false";
  }

  static String GET_CALL_RECORDING(apiId, callId) {
    return Config.BASE_URL_ITP_VOICE +
        "$apiId" +
        "/cdr/$callId" +
        "/download-recording/raw?";
  }

  static String GET_CHAT_NUMBERS_URL(apiId) {
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/chat/numbers";
  }

  static String DOWNLOAD_VOICE_MAIL_MESSAGES(apiId) {
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/voicemail-messages";
  }

  static String DELETE_VOICE_MAIL_MESSAGE(apiId) {
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/voicemail-messages";
  }

  static String GET_USER_DATA(apiId) {
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension";
  }

  static String GET_CALL_HISTORY(apiId, offset) {
    return Config.BASE_URL_ITP_VOICE +
        "$apiId/my-extension/cdr?limit=$apiLimit&offset=$offset";
  }

  static String VALIDATE_PHONE_NUMBER(apiId) {
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/validate-number";
  }

  static String GET_MESSAGE_THREADS(apiId, number, filter, offset) {
    return Config.BASE_URL_ITP_VOICE +
        "$apiId/my-extension/chat/sms/$number?offset=$offset&limit=15" +
        filter;
  }

  static String GET_THREAD_MESSAGES(apiId, number, threadId, offset) {
    return Config.BASE_URL_ITP_VOICE +
        "$apiId/my-extension/chat/sms/$number/$threadId?offset=0&limit=$offset";
  }

  static String MARK_AS_READ(apiId, number, threadId) {
    return Config.BASE_URL_ITP_VOICE +
        "$apiId/my-extension/chat/sms/$number/$threadId/mark-read";
  }

  static String SEND_MESSAGE(apiId, number) {
    return Config.BASE_URL_ITP_VOICE + "$apiId/my-extension/chat/sms/$number";
  }
}


// {
//     "error": null,
//     "errors": false,
//     "message": "Message Sent.",
//     "result": {
//         "call_answered_user_id": null,
//         "call_back_response": {},
//         "call_direction": null,
//         "call_duration": 0,
//         "call_status": null,
//         "call_uniqueid": null,
//         "item_type": "sms",
//         "message_body": ".",
//         "message_error_code": null,
//         "message_error_description": null,
//         "message_mms_media": null,
//         "message_participant": "+17866340769",
//         "message_participant_id": "254813",
//         "message_provider_id": null,
//         "message_status": "pending",
//         "message_thread_id": 127173,
//         "message_timestamp": "2024-09-17T17:01:26.606583",
//         "mms_file_type": null,
//         "voicemail_duration": 0,
//         "voicemail_id": null,
//         "voicemail_link": null,
//         "voicemail_transcription": null
//     }
// }



// src="https://www.google.com/recaptcha/api2/anchor?ar=1&k=6LfDX3MpAAAAAI69PrOkrkpmo0XkyWZKBmIbSvam&co=aHR0cHM6Ly9hcHAuZGV2LnZvaWNlMzYwLmFwcDo0NDM.&hl=en&type=image&v=EGbODne6buzpTnWrrBprcfAY&theme=light&size=normal&badge=bottomright&cb=hvgb2b17tm2b"

// https://www.google.com/recaptcha/api.js?onload=onloadcallback&render=explicit

// https://www.google.com/recaptcha/api2/bframe?hl=en&v=EGbODne6buzpTnWrrBprcfAY&k=6LfDX3MpAAAAAI69PrOkrkpmo0XkyWZKBmIbSvam

// https://www.google.com/recaptcha/api2/