class TagResponseModel {
  final List<Tag> result;
  final bool errors;
  final String? error;
  final String message;
  final bool portalResponse;
  final int offset;
  final int itemsPerPage;
  final int totalPages;
  final int itemCount;

  TagResponseModel({
    required this.result,
    required this.errors,
    this.error,
    required this.message,
    required this.portalResponse,
    required this.offset,
    required this.itemsPerPage,
    required this.totalPages,
    required this.itemCount,
  });

  factory TagResponseModel.fromJson(Map<String, dynamic> json) {
    return TagResponseModel(
      result: (json['result'] as List)
          .map((item) => Tag.fromJson(item))
          .toList(),
      errors: json['errors'] as bool,
      error: json['error'] as String?,
      message: json['message'] as String,
      portalResponse: json['portal_response'] as bool,
      offset: json['offset'] as int,
      itemsPerPage: json['items_per_page'] as int,
      totalPages: json['total_pages'] as int,
      itemCount: json['item_count'] as int,
    );
  }
}

class Tag {
  final int? ownerId;
  final int? accountId;
  final int? pk;
  final String? name;
  final String? tagColor;

  Tag({
    this.ownerId,
    this.accountId,
    this.pk,
    this.name,
    this.tagColor,
  });

  // Factory constructor to create a Tag object from a JSON map
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      ownerId: json['owner_id'] as int?,
      accountId: json['account_id'] as int?,
      pk: json['pk'] as int?,
      name: json['name'] as String? ?? '', // Handle null names
      tagColor: json['tag_color']==""? "#00FFFFFF": json['tag_color'] ?? "#00FFFFFF" as String, // Handle null or empty tagColor
    );
  }

  // Method to convert a Tag object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'account_id': accountId,
      'pk': pk,
      'name': name,
      'tag_color': tagColor,
    };
  }
}
