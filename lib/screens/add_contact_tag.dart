import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/contacts_controller.dart';
import 'package:itp_voice/controllers/tag_list_controller.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/contact_response.dart';
import 'package:itp_voice/models/tag_model.dart';
import 'package:itp_voice/screens/colors.dart';

class AddTag extends StatefulWidget {
  final Contact? cont;

  AddTag({Key? key, this.cont}) : super(key: key);

  @override
  _AddTagState createState() => _AddTagState();
}

class _AddTagState extends State<AddTag> {
  TagListController tagListController = Get.put(TagListController());
  TextEditingController _searchController = TextEditingController();
  ContactsController contcon = Get.find<ContactsController>();
  ColorController cc = Get.find<ColorController>();
  List<Tag> allTags = [];
  List<Tag> filteredTags = [];
  List<Tag> selectedTags = [];
  List tagsIds = [];

  bool isTagListVisible = false; // Control visibility of tag list

  @override
  void initState() {
    super.initState();
    tagListController.fetchList();
    allTags = tagListController.list;
    filteredTags = List.from(allTags);
    _searchController.addListener(_filterTags);

    // Initialize selectedTags with existing contact tags
    if (widget.cont != null && widget.cont!.tags != null) {
      selectedTags.addAll(widget.cont!.tags!.map((contactTag) => Tag(
            ownerId: contactTag.tag.ownerId,
            name: contactTag.tag.name,
            pk: contactTag.tag.pk,
            tagColor: contactTag.tag.tagColor,
          )));
      filteredTags.removeWhere((tag) => selectedTags.contains(tag));
      tagsIds.addAll(selectedTags.map((tag) => tag.pk));
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTags);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        title: Text("Add Tag"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0.h),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onTap: () {
                      setState(() {
                        isTagListVisible =
                            true; // Show the tag list when clicked
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search tags",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      "Selected Tags",
                      
                      style: TextStyle(fontSize: 16.sp,color: cc.txtcolor.value),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Wrap(
                      children: selectedTags.map((tag) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Chip(
                            side: BorderSide(color: Colors.grey),
                            label: Text(tag.name!),
                            backgroundColor: hexToColor(tag.tagColor!),
                            onDeleted: () {
                              setState(() {
                                print('Removing Tag with pk: ${tag.pk}');
                                tagsIds.remove(tag.pk);
                                selectedTags.remove(tag);
                                filteredTags.add(
                                    tag); // Add deleted tag back to filtered list
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await tagListController.addTagOnContact(
                        widget.cont!.pk.toString(), tagsIds);
                        await contcon.fetchContacts("0");
                        
                        Get.back();
                        Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: cc.purplecolor.value,
                      minimumSize: Size(double.infinity, 40.h),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.r)))),
                  child: Obx(() => tagListController.isLoadingMore.value
                    ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text('Save', style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
          if (isTagListVisible)
            Positioned(
              top: 70
                  .h, // Adjust the position of the tag list using ScreenUtil for responsiveness
              left: 16.w,
              right: 16.w,
              child: Material(
                elevation: 4.0,
                borderRadius:
                    BorderRadius.circular(5.r), // Use ScreenUtil for radius
                child: Container(
                  height: 300
                      .h, // Set the height of the dropdown list using ScreenUtil
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(5.r), // Use ScreenUtil for radius
                  ),
                  child: filteredTags.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredTags.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (index < filteredTags.length &&
                                    !selectedTags
                                        .contains(filteredTags[index])) {
                                  setState(() {
                                    tagsIds.add(filteredTags[index].pk);
                                    selectedTags.add(filteredTags[index]);
                                    if (index < filteredTags.length) {
                                      filteredTags.removeAt(
                                          index); // Remove selected tag safely
                                    }
                                    _searchController.clear();
                                  });
                                }

                                // Trigger callback to add tag
                                if (index < filteredTags.length) {}

                                // Hide the tag list after selection
                                setState(() {
                                  isTagListVisible = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: const Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                  color: filteredTags[index].tagColor != null
                                      ? hexToColor(
                                          filteredTags[index].tagColor!)
                                      : Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          1.h), // Use ScreenUtil for padding
                                  child: ListTile(
                                    title: Text(filteredTags[index].name!),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: Text('No tags available')),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _filterTags() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTags = allTags
          .where((tag) => tag.name!.toLowerCase().contains(query))
          .toList();

      // Ensure selected tags are not in the filtered tags list
      filteredTags.removeWhere((tag) => selectedTags.contains(tag));
    });
  }

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
