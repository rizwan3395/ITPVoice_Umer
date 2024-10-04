class CallForwardSettings {
  bool? callforwardCallConfirmation;
  bool? callforwardEnable;
  bool? callforwardKeepCallerCallerId;
  String? callforwardNumber;
  bool? callforwardQueueCalls;
  String? callername;
  String? callernumber;
  bool? internalCall;
  bool? externalCall;

  CallForwardSettings({
    required this.callforwardCallConfirmation,
    required this.callforwardEnable,
    required this.callforwardKeepCallerCallerId,
    required this.callforwardNumber,
    required this.callforwardQueueCalls,
    this.callername,
    this.callernumber,
    this.externalCall,
    this.internalCall

    
  });

  // Factory constructor to create a new instance from a JSON map
  factory CallForwardSettings.fromJson(Map<String, dynamic> json) {
    return CallForwardSettings(
      callforwardCallConfirmation: json['callforward_call_confirmation'] ?? false,
      callforwardEnable: json['callforward_enable'] ?? false,
      callforwardKeepCallerCallerId: json['callforward_keep_caller_caller_id'] ?? false,
      callforwardNumber: json['callforward_number'] ?? '',
      callforwardQueueCalls: json['callforward_queue_calls'] ?? false,
      callername: json['default_outbound_callerid_name']??"",
      callernumber: json['default_outbound_callerid_number']??"",
      internalCall: json['call_recording_internal']=="enabled"?true:false,
      externalCall: json['call_recording_external']=="enabled"?true:false
    );
  }

  // Method to convert the model instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'callforward_call_confirmation': callforwardCallConfirmation,
      'callforward_enable': callforwardEnable,
      'callforward_keep_caller_caller_id': callforwardKeepCallerCallerId,
      'callforward_number': callforwardNumber,
      'callforward_queue_calls': callforwardQueueCalls,
    };
  }
}


class VoicemailDetails {
  
  final String? deleteVoicemail;
  final String? sendVoicemail;

  VoicemailDetails({
  
    this.deleteVoicemail,
    this.sendVoicemail,
  });

  // Factory constructor to create a model from JSON
  factory VoicemailDetails.fromJson(Map<String, dynamic> json) {
    return VoicemailDetails(
  
      deleteVoicemail: json['deletevoicemail'],
      sendVoicemail: json['sendvoicemail'],
    );
  }

  // Method to convert model to JSON
  Map<String, dynamic> toJson() {
    return {
  
      'deletevoicemail': deleteVoicemail,
      'sendvoicemail': sendVoicemail,
    };
  }
}
