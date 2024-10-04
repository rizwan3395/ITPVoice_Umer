class ViewMyNumbersResponseModel {
  List<Result>? result;
  bool? errors;
  dynamic error;
  String? message;
  dynamic pageSize;
  dynamic nextStartKey;
  dynamic startKey;

  ViewMyNumbersResponseModel(
      {this.result,
      this.errors,
      this.error,
      this.message,
      this.pageSize,
      this.nextStartKey,
      this.startKey});

  ViewMyNumbersResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
    errors = json['errors'];
    error = json['error'];
    message = json['message'];
    pageSize = json['page_size'];
    nextStartKey = json['next_start_key'];
    startKey = json['start_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['errors'] = errors;
    data['error'] = error;
    data['message'] = message;
    data['page_size'] = pageSize;
    data['next_start_key'] = nextStartKey;
    data['start_key'] = startKey;
    return data;
  }
}

class Result {
  List<SmsAssignedUsers>? smsAssignedUsers;
  dynamic faxAssignedUsers;
  String? status;
  int? pk;
  String? callerIdName;
  String? description;
  String? number;
  int? ownerId;
  int? accountId;
  String? calleridPrefix;
  String? usedBy;

  Result(
      {this.smsAssignedUsers,
      this.faxAssignedUsers,
      this.status,
      this.pk,
      this.callerIdName,
      this.description,
      this.number,
      this.ownerId,
      this.accountId,
      this.calleridPrefix,
      this.usedBy});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['sms_assigned_users'] != null) {
      smsAssignedUsers = <SmsAssignedUsers>[];
      json['sms_assigned_users'].forEach((v) {
        smsAssignedUsers!.add(SmsAssignedUsers.fromJson(v));
      });
    }
    if (json['fax_assigned_users'] != null) {
      faxAssignedUsers = json['fax_assigned_users'];
      // faxAssignedUsers = <Null>[];
      // json['fax_assigned_users'].forEach((v) {
      //   faxAssignedUsers!.add(new Null.fromJson(v));
      // });
    }
    status = json['status'];
    pk = json['pk'];
    callerIdName = json['caller_id_name'];
    description = json['description'];
    number = json['number'];
    ownerId = json['owner_id'];
    accountId = json['account_id'];
    calleridPrefix = json['callerid_prefix'];
    usedBy = json['used_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (smsAssignedUsers != null) {
      data['sms_assigned_users'] =
          smsAssignedUsers!.map((v) => v.toJson()).toList();
    }
    if (faxAssignedUsers != null) {
      // data['fax_assigned_users'] =
      //     this.faxAssignedUsers!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['pk'] = pk;
    data['caller_id_name'] = callerIdName;
    data['description'] = description;
    data['number'] = number;
    data['owner_id'] = ownerId;
    data['account_id'] = accountId;
    data['callerid_prefix'] = calleridPrefix;
    data['used_by'] = usedBy;
    return data;
  }
}

class SmsAssignedUsers {
  int? userVolumePreference;
  dynamic status;
  dynamic defaultOutboundCalleridName;
  dynamic callforwardQueueCalls;
  int? accountId;
  bool? voicemailEnabled;
  dynamic callforwardKeepCallerCallerId;
  dynamic callforwardNumber;
  String? presenceId;
  String? voicemailBoxId;
  dynamic defaultOutboundCalleridNumber;
  int? pk;
  int? crmContactId;
  String? privLevel;
  String? language;
  bool? vmToEmailEnabled;
  String? callRecordingExternal;
  dynamic callforwardEnable;
  String? callRecordingInternal;

  SmsAssignedUsers(
      {this.userVolumePreference,
      this.status,
      this.defaultOutboundCalleridName,
      this.callforwardQueueCalls,
      this.accountId,
      this.voicemailEnabled,
      this.callforwardKeepCallerCallerId,
      this.callforwardNumber,
      this.presenceId,
      this.voicemailBoxId,
      this.defaultOutboundCalleridNumber,
      this.pk,
      this.crmContactId,
      this.privLevel,
      this.language,
      this.vmToEmailEnabled,
      this.callRecordingExternal,
      this.callforwardEnable,
      this.callRecordingInternal});

  SmsAssignedUsers.fromJson(Map<String, dynamic> json) {
    userVolumePreference = json['user_volume_preference'];
    status = json['status'];
    defaultOutboundCalleridName = json['default_outbound_callerid_name'];
    callforwardQueueCalls = json['callforward_queue_calls'];
    accountId = json['account_id'];
    voicemailEnabled = json['voicemail_enabled'];
    callforwardKeepCallerCallerId = json['callforward_keep_caller_caller_id'];
    callforwardNumber = json['callforward_number'];
    presenceId = json['presence_id'];
    voicemailBoxId = json['voicemail_box_id'];
    defaultOutboundCalleridNumber = json['default_outbound_callerid_number'];
    pk = json['pk'];
    crmContactId = json['crm_contact_id'];
    privLevel = json['priv_level'];
    language = json['language'];
    vmToEmailEnabled = json['vm_to_email_enabled'];
    callRecordingExternal = json['call_recording_external'];
    callforwardEnable = json['callforward_enable'];
    callRecordingInternal = json['call_recording_internal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_volume_preference'] = userVolumePreference;
    data['status'] = status;
    data['default_outbound_callerid_name'] = defaultOutboundCalleridName;
    data['callforward_queue_calls'] = callforwardQueueCalls;
    data['account_id'] = accountId;
    data['voicemail_enabled'] = voicemailEnabled;
    data['callforward_keep_caller_caller_id'] =
        callforwardKeepCallerCallerId;
    data['callforward_number'] = callforwardNumber;
    data['presence_id'] = presenceId;
    data['voicemail_box_id'] = voicemailBoxId;
    data['default_outbound_callerid_number'] =
        defaultOutboundCalleridNumber;
    data['pk'] = pk;
    data['crm_contact_id'] = crmContactId;
    data['priv_level'] = privLevel;
    data['language'] = language;
    data['vm_to_email_enabled'] = vmToEmailEnabled;
    data['call_recording_external'] = callRecordingExternal;
    data['callforward_enable'] = callforwardEnable;
    data['call_recording_internal'] = callRecordingInternal;
    return data;
  }
}
