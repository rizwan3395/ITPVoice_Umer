import 'package:itp_voice/models/get_contacts_reponse_model/contact_response.dart';

class GetMessageThreadsResponseModel {
  Result? result;
  bool? errors;
  Null error;
  String? message;
  Null pageSize;
  Null nextStartKey;
  Null startKey;

  GetMessageThreadsResponseModel(
      {this.result, this.errors, this.error, this.message, this.pageSize, this.nextStartKey, this.startKey});

  GetMessageThreadsResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
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
  List<MessageThreads>? messageThreads;
  int? totalPages;
  int? page;

  Result({this.messageThreads, this.totalPages, this.page});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['message_threads'] != null) {
      messageThreads = <MessageThreads>[];
      json['message_threads'].forEach((v) {
        messageThreads!.add(MessageThreads.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (messageThreads != null) {
      data['message_threads'] = messageThreads!.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = totalPages;
    data['page'] = page;
    return data;
  }
}

class MessageThreads {
  bool? threadRead;
  String? lastMessage;
  String? lastUpdated;
  int? numberOfParticipants;
  int? unreadMessages;
  int? pk;
  String? lastEventType;
  List<Participants>? participants;

  MessageThreads(
      {this.threadRead,
      this.lastMessage,
      this.lastUpdated,
      this.numberOfParticipants,
      this.unreadMessages,
      this.pk,
      this.lastEventType,
      this.participants});

  MessageThreads.fromJson(Map<String, dynamic> json) {
    threadRead = json['thread_read'];
    lastMessage = json['last_message'];
    lastUpdated = json['last_updated'];
    lastEventType = json['last_event_type'];
    numberOfParticipants = json['number_of_participants'];
    unreadMessages = json['unread_messages'];
    pk = json['pk'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thread_read'] = threadRead;
    data['last_message'] = lastMessage;
    data['last_updated'] = lastUpdated;
    data['last_event_type'] = lastEventType;
    data['unread_messages'] = unreadMessages;
    data['number_of_participants'] = numberOfParticipants;
    data['pk'] = pk;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Participants {
  String? messageThreadId;
  int? pk;
  String? number;
  bool? isSelf;
  Contact? contact;

  Participants({this.messageThreadId, this.pk, this.number, this.isSelf ,this.contact});

  Participants.fromJson(Map<String, dynamic> json) {
    messageThreadId = json['message_thread_id'];
    pk = json['pk'];
    number = json['number'];
    isSelf = json['is_self'];
    contact = json['contact'] != null ? Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_thread_id'] = messageThreadId;
    data['pk'] = pk;
    data['number'] = number;
    data['is_self'] = isSelf;
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    return data;
  }
}
