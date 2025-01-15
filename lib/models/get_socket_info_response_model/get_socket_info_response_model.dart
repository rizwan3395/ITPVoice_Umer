class GetSocketInfoResponseModel {
  Result? result;
  bool? errors;
  dynamic error;
  String? message;
  dynamic pageSize;
  dynamic nextStartKey;
  dynamic startKey;

  GetSocketInfoResponseModel(
      {this.result,
      this.errors,
      this.error,
      this.message,
      this.pageSize,
      this.nextStartKey,
      this.startKey});

  GetSocketInfoResponseModel.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? Result.fromJson(json['result']) : null;
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
      data['result'] = result!.toJson();
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
  String? sipPassword;
  int? pk;
  String? sipUsername;
  int? ownerId;
  String? deviceType;
  int? accountId;

  Result(
      {this.sipPassword,
      this.pk,
      this.sipUsername,
      this.ownerId,
      this.deviceType,
      this.accountId});

  Result.fromJson(Map<String, dynamic> json) {
    sipPassword = json['sip_password'];
    pk = json['pk'];
    sipUsername = json['sip_username'];
    ownerId = json['owner_id'];
    deviceType = json['device_type'];
    accountId = json['account_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sip_password'] = sipPassword;
    data['pk'] = pk;
    data['sip_username'] = sipUsername;
    data['owner_id'] = ownerId;
    data['device_type'] = deviceType;
    data['account_id'] = accountId;
    return data;
  }
}
