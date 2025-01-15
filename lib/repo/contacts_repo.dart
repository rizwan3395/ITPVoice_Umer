import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itp_voice/models/add_contact_request_model/add_contact_request_model.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/contact_response.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/get_contacts_reponse_model.dart';
import 'package:itp_voice/models/tag_model.dart';
import 'package:itp_voice/repo/base_requester.dart';
import 'package:itp_voice/repo/shares_preference_repo.dart';
import 'package:itp_voice/routes.dart';
import 'package:itp_voice/storage_keys.dart';

import '../models/get_contacts_reponse_model/contactList.dart';

class ContactsRepo {
  BaseRequester requester = BaseRequester();

  createContact(String name, String lastname, String notes, String phone,
      String email, String contactListId) async {
    try {
      String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);
      print(phone);

      final apiResponse = await requester.basePostAPI(
          Endpoints.CREATE_CONTACT_URL(apiId),
          jsonEncode({
            'firstname': name,
            'lastname': lastname,
            'notes': notes,
            'phone': phone,
            'email': email,
            'contact_list_id': contactListId
          }),
          protected: true);

      if (apiResponse != null) {
        if (apiResponse['errors']) {
          return apiResponse['message'];
        } else {
          return true;
        }
      }
    } catch (e) {
      return "Something went wrong";
    }
  }

  updateContact(
      dynamic id, String name, String notes, String phone, String email) async {
    try {
      String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

      final apiResponse = await requester.basePatchAPI(
          '${Endpoints.UPDATE_CONTACT_URL(apiId)}/${id}',
          jsonEncode({
            'firstname': name,
            'lastname': '',
            'notes': notes,
            'phone': phone,
            'email': email
          }),
          protected: true);

      if (apiResponse != null) {
        if (apiResponse['errors']) {
          return apiResponse['message'];
        } else {
          return true;
        }
      }
    } catch (e) {
      return "Something went wrong";
    }
  }

  getContacts(
    String offSet,
  ) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      final apiResponse = await BaseRequesterMethods.baseRequester.baseGetAPI(
        Endpoints.GET_CONTACTS_URL(apiId, offSet),
      );
      print(apiResponse.toString());
      if (apiResponse['errors'] == false) {
        ContactResponse reponse = ContactResponse.fromJson(apiResponse);
        // GetContactsReponseModel reponse =
        //     GetContactsReponseModel.fromMap(apiResponse);
        return reponse;
      }
      return "Something went wrong";
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  getTagsList(offset) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      final apiResponse = await BaseRequesterMethods.baseRequester.baseGetAPI(
        Endpoints.GET_TAG_LISTS(apiId, offset),
      );
      print("START_________________________________________________________");
      print(apiResponse.toString());

      TagResponseModel reponse = TagResponseModel.fromJson(apiResponse);

      // GetContactsReponseModel reponse =
      //     GetContactsReponseModel.fromMap(apiResponse);

      return reponse.result;
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  getContactsLists(offset) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      final apiResponse = await BaseRequesterMethods.baseRequester.baseGetAPI(
        Endpoints.GET_CONTACT_LISTS(apiId, offset),
      );
      // print("START_________________________________________________________");
      print(apiResponse.toString());

      ContactListResponse reponse = ContactListResponse.fromJson(apiResponse);

      // GetContactsReponseModel reponse =
      //     GetContactsReponseModel.fromMap(apiResponse);

      return reponse.result;
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

//  Get Contact Lists Method.
  getContactsL() async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      final apiResponse = await BaseRequesterMethods.baseRequester.baseGetAPI(
        Endpoints.GET_CONTACT_LIST(apiId),
      );
      // print("START_________________________________________________________");
      print(apiResponse.toString());

      ContactListResponse reponse = ContactListResponse.fromJson(apiResponse);

      // GetContactsReponseModel reponse =
      //     GetContactsReponseModel.fromMap(apiResponse);

      return reponse.result;
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  searchContacts(String offSet, String query) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      final apiResponse = await BaseRequesterMethods.baseRequester.baseGetAPI(
        Endpoints.SEARCH_CONTACTS_URL(apiId, offSet, query),
      );

      if (apiResponse['errors'] == false) {
        ContactResponse reponse = ContactResponse.fromJson(apiResponse);
        // GetContactsReponseModel reponse =
        //     GetContactsReponseModel.fromMap(apiResponse);
        return reponse;
      }
      return "Something went wrong";
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  deleteContact(id) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      print("_________$apiId **$id");
      final apiResponse =
          await BaseRequesterMethods.baseRequester.baseDeleteAPI(
        "${Endpoints.DELETE_CONTACT(apiId)}/$id",
        null,
        protected: true,
      );

      if (apiResponse['error'] == null) {
        return true;
      }
      return apiResponse['message'];
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  deleteTag(id) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      print("_________$apiId **$id");
      await BaseRequesterMethods.baseRequester
          .baseDeleteAPI("${Endpoints.DELETE_TAG(apiId, id)}", null);
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  addTag(String name, String color) async {
    String sendColor = color;
    if (sendColor == "FFFFFF") {
      sendColor = '';
    }
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      await BaseRequesterMethods.baseRequester.basePostAPI(
        Endpoints.ADD_TAG(apiId),
        jsonEncode({"name": name, "tag_color": sendColor}),
        protected: true,
      );
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  addTagOnContact(dynamic id, List tags) async {
    try {
      String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

      final apiResponse = await requester.basePatchAPI(
          '${Endpoints.ADD_TAG_ON_CONTACT(apiId, id)}',
          jsonEncode({'tags': tags}),
          protected: true);

      if (apiResponse != null) {
        if (apiResponse['errors']) {
          return apiResponse['message'];
        } else {
          return true;
        }
      }
    } catch (e) {
      return "Something went wrong";
    }
  }

  Future<String> addList(String name) async {
    String? apiId = await SharedPreferencesMethod.getString(
        StorageKeys.API_ID); // Ensure this is awaited

    if (apiId == null) {
      return "API ID not found"; // Return early if API ID is not found
    }

    try {
      // Prepare the payload
      Map<String, dynamic> payload = {"list_name": name};

      // Make the API call
      final response = await BaseRequesterMethods.baseRequester.basePostAPI(
        Endpoints.ADD_LIST(apiId),
        jsonEncode(payload),
        protected: true,
      );

      // Handle the API response (assuming a successful response has a status or success field)
      if (response != null && response['status'] == 'success') {
        return "List added successfully";
      } else {
        return response['message'] ??
            "Failed to add list"; // Return message from the server if available
      }
    } catch (e) {
      // Catch and log any error
      print("Error adding list: ${e.toString()}");
      return "Something went wrong";
    }
  }

  deleteList(id) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      print("_________$apiId **$id");
      await BaseRequesterMethods.baseRequester
          .baseDeleteAPI("${Endpoints.DELETE_LIST(apiId, id)}", null);
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  updateListName(String name, String id) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);
    try {
      await BaseRequesterMethods.baseRequester.basePatchAPI(
        Endpoints.EDIT_LIST_NAME(apiId, id),
        jsonEncode({"list_name": name}),
        protected: true,
      );
    } catch (e) {
      throw (e.toString());
    }
  }

  updateTagInfo(String name, String id, String colour) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);
    try {
      final res = await BaseRequesterMethods.baseRequester.basePatchAPI(
        Endpoints.EDIT_TAG(apiId, id),
        jsonEncode({"name": name, "tag_color": colour}),
        protected: true,
      );
      return res;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      throw (e.toString());
    }
  }

  validatePhoneNumber(String phoneNumber) async {
    String? apiId = SharedPreferencesMethod.getString(StorageKeys.API_ID);

    try {
      final apiResponse = await BaseRequesterMethods.baseRequester.basePostAPI(
        Endpoints.VALIDATE_PHONE_NUMBER(apiId),
        jsonEncode({"number": phoneNumber}),
        protected: true,
      );

      if (apiResponse['message'] == "Validated Number") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return "Something went wrong";
    }
  }

  updateMyNumber(String myNumber) async {
    try {
      await BaseRequesterMethods.baseRequester.basePatchAPI(
        Endpoints.USER_PROFILE,
        jsonEncode({"mobile": myNumber}),
        protected: true,
      );
    } catch (e) {
      throw (e.toString());
    }
  }
}
