import 'package:itp_voice/models/get_contacts_reponse_model/contact_response.dart';

class GetThreadMessagesResponseModel {
  Result? result;
  bool? errors;
  dynamic error;
  String? message;
  dynamic pageSize;
  dynamic nextStartKey;
  dynamic startKey;

  GetThreadMessagesResponseModel(
      {this.result, this.errors, this.error, this.message, this.pageSize, this.nextStartKey, this.startKey});

  GetThreadMessagesResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    errors = json['errors'];
    error = json['error'];
    message = json['message'];
    pageSize = json['item_count'];
    nextStartKey = json['next_start_key'];
    startKey = json['start_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['errors'] = errors;
    data['error'] = error;
    data['message'] = message;
    data['item_count'] = pageSize;
    data['next_start_key'] = nextStartKey;
    data['start_key'] = startKey;
    return data;
  }
}

class Result {
  List<Messages>? messages;
  List<Participants>? participants;

  Result({this.messages, this.participants});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? messageStatus;
  int? pk;
  String? messageBody;
  String? messageProviderId;
  dynamic messageMmsMedia;
  CallBackResponse? callBackResponse;
  String? messageTimestamp;
  String? messageParticipantId;
  String? messageParticipant;
  int? voiceMailId;
  String? callStatus;
  String? itemType;
  String? callDirection;
  bool? isDelivered;
  AnsweredBy? answeredBy;
  Cdr? cdr;

  

  Messages({
    this.messageStatus,
    this.pk,
    this.messageBody,
    this.messageProviderId,
    this.messageMmsMedia,
    this.callBackResponse,
    this.voiceMailId,
    this.messageTimestamp,
    this.messageParticipantId,
    this.messageParticipant,
    this.callDirection,
    this.isDelivered = true,
    this.answeredBy,
    this.callStatus,
    this.cdr,
    this.itemType,

  });

  Messages.fromJson(Map<String, dynamic> json) {
    messageStatus = json['message_status'];
    pk = json['pk'];
    voiceMailId= json['voicemail_id'];
    itemType = json['item_type'];
    messageBody = json['message_body'];
    messageProviderId = json['message_provider_id'];
    messageMmsMedia = json['message_mms_media'];
    callDirection = json['call_direction'];
    callStatus = json['call_status'];
    cdr = json['cdr'] != null ? Cdr.fromJson(json['cdr']) : null;
    callBackResponse =
        json['call_back_response'] != null ? CallBackResponse.fromJson(json['call_back_response']) : null;
    messageTimestamp = json['message_timestamp'];
    answeredBy = json['answered_by'] != null ? AnsweredBy.fromJson(json['answered_by']) : null;
    messageParticipantId = json['message_participant_id'];
    messageParticipant = json['message_participant'];
    isDelivered = true;
    
  }

  Messages.fromPayload(Map<String, dynamic> json) {
    messageStatus = json['message_status'];
    pk = json['message_thread_pk'];
    itemType = json['item_type'];
    messageBody = json['message'];
    voiceMailId= json['voicemail_id'];
    callDirection = json['call_direction'];
    cdr= json['cdr'];
    callStatus = json['call_status'];
    answeredBy = json['answered_by'];
    messageProviderId = json['message_provider_id'];
    messageMmsMedia = json['media_id'];
    callBackResponse = json['call_back_response'] != null
        ? new CallBackResponse.fromJson(json['call_back_response'])
        : null;
    messageTimestamp = json['message_timestamp'];
    messageParticipantId = json['message_participant_id'];
    messageParticipant = json['from_number'];
    isDelivered = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_status'] = messageStatus;
    data['pk'] = pk;
    data['item_type'] = itemType;
    data['cdr'] = cdr;
    data['voicemail_id']= voiceMailId;
    data['call_status'] = callStatus;
    data['call_direction'] = callDirection;
    data['message_body'] = messageBody;
    data["answered_by"] = answeredBy;
    data['message_provider_id'] = messageProviderId;
    data['message_mms_media'] = messageMmsMedia;
    if (callBackResponse != null) {
      data['call_back_response'] = callBackResponse!.toJson();
    }
    data['message_timestamp'] = messageTimestamp;
    data['message_participant_id'] = messageParticipantId;
    data['message_participant'] = messageParticipant;
    return data;
  }
}

class CallBackResponse {
  CallBackResponse();

  CallBackResponse.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class Participants {
  String? messageThreadId;
  int? pk;
  String? number;
  bool? isSelf;
  Contact? contact;

  Participants({this.messageThreadId, this.pk, this.number, this.isSelf});

  Participants.fromJson(Map<String, dynamic> json) {
    messageThreadId = json['message_thread_id'];
    pk = json['pk'];
    number = json['number'];
    isSelf = json['is_self'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_thread_id'] = messageThreadId;
    data['pk'] = pk;
    data['number'] = number;
    data['is_self'] = isSelf;
    return data;
  }
}

class AnsweredBy {
  final int accountId;
  final String callRecordingExternal;
  final String callRecordingInternal;

  AnsweredBy({
    required this.accountId,
    required this.callRecordingExternal,
    required this.callRecordingInternal,
  });

  factory AnsweredBy.fromJson(Map<String, dynamic> json) {
    return AnsweredBy(
      accountId: json['account_id'],
      callRecordingExternal: json['call_recording_external'],
      callRecordingInternal: json['call_recording_internal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'call_recording_external': callRecordingExternal,
      'call_recording_internal': callRecordingInternal,
    };
  }
}


class Cdr {
  final int duration;
  final String? callRecordingFilename;
  final int pk;

  Cdr({
    required this.duration,
    this.callRecordingFilename,
    required this.pk,
  });

  factory Cdr.fromJson(Map<String, dynamic> json) {
    return Cdr(
      duration: json['duration'],
      callRecordingFilename: json['call_recording_filename'],
      pk: json['pk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'call_recording_filename': callRecordingFilename,
      'pk': pk,
    };
  }
}
