import 'dart:convert';

import 'package:itp_voice/models/get_voice_mails_response_model/result.dart';

class GetVoiceMailsResponseModel {
  Map<String, List<VoiceMails>>? result;
  bool? errors;
  dynamic error;
  String? message;
  dynamic pageSize;
  dynamic nextStartKey;
  dynamic startKey;

  GetVoiceMailsResponseModel({
    this.result,
    this.errors,
    this.error,
    this.message,
    this.pageSize,
    this.nextStartKey,
    this.startKey,
  });

  factory GetVoiceMailsResponseModel.fromMap(Map<String, dynamic> data) {
    return GetVoiceMailsResponseModel(
      result: data['result'] != null
          ? Map<String, List<VoiceMails>>.from((data['result'] as Map).map(
              (key, value) => MapEntry(
                key as String,
                List<VoiceMails>.from(
                  (value as List<dynamic>).map((x) => VoiceMails.fromMap(x as Map<String, dynamic>)),
                ),
              ),
            ))
          : null,
      errors: data['errors'] as bool?,
      error: data['error'] as dynamic,
      message: data['message'] as String?,
      pageSize: data['page_size'] as dynamic,
      nextStartKey: data['next_start_key'] as dynamic,
      startKey: data['start_key'] as dynamic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'result': result?.map((key, value) => MapEntry(key, value.map((x) => x.toMap()).toList())),
      'errors': errors,
      'error': error,
      'message': message,
      'page_size': pageSize,
      'next_start_key': nextStartKey,
      'start_key': startKey,
    };
  }

  factory GetVoiceMailsResponseModel.fromJson(String data) {
    return GetVoiceMailsResponseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'GetVoiceMailsResponseModel(result: $result, errors: $errors, error: $error, message: $message, pageSize: $pageSize, nextStartKey: $nextStartKey, startKey: $startKey)';
  }
}
