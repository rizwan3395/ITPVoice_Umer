import 'package:itp_voice/models/tag_model.dart';

class ContactResponse {
  List<Contact>? result;
  bool? errors;
  dynamic error;
  String? message;
  bool? portalResponse;
  int? offset;
  int? itemsPerPage;
  int? totalPages;
  int? itemCount;

  ContactResponse({this.result, this.errors, this.error, this.message,this.portalResponse,
    this.offset,
    this.itemsPerPage,
    this.totalPages,
    this.itemCount});

  ContactResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Contact>[];
      json['result'].forEach((v) {
        result!.add(Contact.fromJson(v));
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

class Contact {
  bool? publicContact;
  dynamic facebookRefId;
  String? notes;
  String? dateAdded;
  dynamic zipcode;
  bool? possibleDupe;
  dynamic mobile;
  dynamic facebookUsername;
  dynamic city;
  String? email;
  dynamic taggingHistory;
  int? userId;
  bool? qualified;
  int? accountId;
  String? phone;
  String? dateModified;
  bool? isCustomer;
  int? pk;
  dynamic formref;
  dynamic funnelRefId;
  dynamic state;
  dynamic address;
  dynamic businessIndustry;
  dynamic trackRefId;
  dynamic contactGuid;
  String? lastname;
  String? firstname;
  int? contactListId;
  dynamic businessName;
  String? lastContacted;
  dynamic website;
  List<ContactTag>? tags;

  Contact(
      {this.publicContact,
      this.facebookRefId,
      this.notes,
      this.dateAdded,
      this.zipcode,
      this.possibleDupe,
      this.mobile,
      this.facebookUsername,
      this.city,
      this.email,
      this.taggingHistory,
      this.userId,
      this.qualified,
      this.accountId,
      this.phone,
      this.dateModified,
      this.isCustomer,
      this.pk,
      this.formref,
      this.funnelRefId,
      this.state,
      this.address,
      this.businessIndustry,
      this.trackRefId,
      this.contactGuid,
      this.lastname,
      this.firstname,
      this.contactListId,
      this.businessName,
      this.lastContacted,
      this.tags,
      this.website});

  Contact.fromJson(Map<String, dynamic> json) {
    publicContact = json['public_contact'];
    facebookRefId = json['facebook_ref_id'];
    notes = json['notes'];
    dateAdded = json['date_added'];
    zipcode = json['zipcode'];
    possibleDupe = json['possible_dupe'];
    mobile = json['mobile'];
    facebookUsername = json['facebook_username'];
    city = json['city'];
    email = json['email'];
    taggingHistory = json['tagging_history'];
    userId = json['user_id'];
    qualified = json['qualified'];
    accountId = json['account_id'];
    phone = json['phone'];
    dateModified = json['date_modified'];
    tags = (json['tags'] as List<dynamic>).map((e) => ContactTag.fromJson(e)).toList();
    isCustomer = json['is_customer'];
    pk = json['pk'];
    formref = json['formref'];
    funnelRefId = json['funnel_ref_id'];
    state = json['state'];
    address = json['address'];
    businessIndustry = json['business_industry'];
    trackRefId = json['track_ref_id'];
    contactGuid = json['contact_guid'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    contactListId = json['contact_list_id'];
    businessName = json['business_name'];
    lastContacted = json['last_contacted'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['public_contact'] = publicContact;
    data['facebook_ref_id'] = facebookRefId;
    data['notes'] = notes;
    data['date_added'] = dateAdded;
    data['zipcode'] = zipcode;
    data['possible_dupe'] = possibleDupe;
    data['mobile'] = mobile;
    data['facebook_username'] = facebookUsername;
    data['city'] = city;
    data['email'] = email;
    data['tags'] = tags!.map((e) => e.toJson()).toList();
    data['tagging_history'] = taggingHistory;
    data['user_id'] = userId;
    data['qualified'] = qualified;
    data['account_id'] = accountId;
    data['phone'] = phone;
    data['date_modified'] = dateModified;
    data['is_customer'] = isCustomer;
    data['pk'] = pk;
    data['formref'] = formref;
    data['funnel_ref_id'] = funnelRefId;
    data['state'] = state;
    data['address'] = address;
    data['business_industry'] = businessIndustry;
    data['track_ref_id'] = trackRefId;
    data['contact_guid'] = contactGuid;
    data['lastname'] = lastname;
    data['firstname'] = firstname;
    data['contact_list_id'] = contactListId;
    data['business_name'] = businessName;
    data['last_contacted'] = lastContacted;
    data['website'] = website;
    return data;
  }
}


class ContactTag {
  int contactId;
  Tag tag;
  int pk;
  int tagId;

  ContactTag({
    required this.contactId,
    required this.tag,
    required this.pk,
    required this.tagId,
  });

  // Factory method to create a ContactTag object from JSON
  factory ContactTag.fromJson(Map<String, dynamic> json) {
    return ContactTag(
      contactId: json['contact_id'],
      tag: Tag.fromJson(json['tag']),
      pk: json['pk'],
      tagId: json['tag_id'],
    );
  }

  // Method to convert ContactTag object to JSON
  Map<String, dynamic> toJson() {
    return {
      'contact_id': contactId,
      'tag': tag.toJson(),
      'pk': pk,
      'tag_id': tagId,
    };
  }
}

