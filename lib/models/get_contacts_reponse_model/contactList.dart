class ContactListResponse {
  List<ContactList>? result;
  bool? errors;
  dynamic error;
  String? message;
  bool? portalResponse;
  int? offset;
  int? itemsPerPage;
  int? totalPages;
  int? itemCount;

  ContactListResponse({
    this.result,
    this.errors,
    this.error,
    this.message,
    this.portalResponse,
    this.offset,
    this.itemsPerPage,
    this.totalPages,
    this.itemCount,
  });

  ContactListResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <ContactList>[];
      json['result'].forEach((v) {
        result!.add(ContactList.fromJson(v));
      });
    }
    errors = json['errors'];
    error = json['error'];
    message = json['message'];
    portalResponse = json['portal_response'];
    offset = json['offset'];
    itemsPerPage = json['items_per_page'];
    totalPages = json['total_pages'];
    itemCount = json['item_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['errors'] = errors;
    data['error'] = error;
    data['message'] = message;
    data['portal_response'] = portalResponse;
    data['offset'] = offset;
    data['items_per_page'] = itemsPerPage;
    data['total_pages'] = totalPages;
    data['item_count'] = itemCount;
    return data;
  }
  
}



class ContactList {
  int? pk;
  String? listGuid;
  int? contactCount;
  String? listName;
  int? accountId;
  bool? isDefault;

  ContactList({
    this.pk,
    this.listGuid,
    this.contactCount,
    this.listName,
    this.accountId,
    this.isDefault,
  });

  ContactList.fromJson(Map<String, dynamic> json) {
    pk = json['pk'];
    listGuid = json['list_guid'];
    contactCount = json['contact_count'];
    listName = json['list_name'];
    accountId = json['account_id'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pk'] = pk;
    data['list_guid'] = listGuid;
    data['contact_count'] = contactCount;
    data['list_name'] = listName;
    data['account_id'] = accountId;
    data['is_default'] = isDefault;
    return data;
  }
}
