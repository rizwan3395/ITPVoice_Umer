import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itp_voice/controllers/contact_list_controller.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/contactList.dart';
import 'package:itp_voice/screens/add_list_screen.dart';
import 'package:itp_voice/screens/colors.dart';

class ContactLists extends StatefulWidget {
  @override
  _ContactListsState createState() => _ContactListsState();
}

class _ContactListsState extends State<ContactLists> {
  final ContactListController con = Get.put(ContactListController());
  final ScrollController _scrollController = ScrollController();
  final ColorController cc = Get.find<ColorController>();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    con.fetchList(); // Fetch contacts when the screen loads
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !con.isListLoading.value) {
        con.loadMoreList(); // Load more contacts when reached the bottom
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddListScreen(
                    ),
                ),
              );
            },
            
          ),
        ],
        centerTitle: true,
        title: const Text('Contact Lists'),
      ),
      body: Obx(
        () => con.isListLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  con.offset.value = 0;
                  await con.fetchList();
                },
                child: con.list.isEmpty
                    ? Center(
                        child: Text(
                          "No contacts Lists Available",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: con.list.length + 1,
                        itemBuilder: (context, index) {
                          if (index == con.list.length) {
                            return con.isListLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const SizedBox(); // Loading indicator at the end
                          }
                          return Container(
  width: double.infinity, // Ensure the container takes full width
  margin: EdgeInsets.symmetric(vertical: 2.h),
  child: ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
    title: Text(
      '${con.list[index].listName}',
      style: TextStyle(fontSize: 16.sp),
      overflow: TextOverflow.ellipsis, // Prevent text overflow
    ),
    subtitle: Text(
      'Contacts(${con.list[index].contactCount})',
      style: TextStyle(fontSize: 14.sp),
      overflow: TextOverflow.ellipsis, // Prevent text overflow
    ),
    onTap: () {
      // Navigate to contact details screen
    },
    tileColor: cc.tabcolor.value,
    trailing: SizedBox(
      width: 90.w, // Ensure the width scales properly
      child: Row(
        mainAxisSize: MainAxisSize.min, // Let the Row take minimum space
        children: [
          Flexible( // Wrapping IconButton with Flexible
            child: IconButton(
              icon: Icon(Icons.delete, size: 20.sp),
              onPressed: () {
                // Ask for confirmation before deleting
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete List'),
                      content: const Text('Are you sure you want to delete this list?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cc.purplecolor.value,
                          ),
                          onPressed: () async {
                            await con.deleteList(con.list[index].pk.toString());
                            Navigator.of(context).pop();
                            con.fetchList();
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Flexible( // Wrapping IconButton with Flexible
            child: IconButton(
              icon: Icon(Icons.edit, size: 20.sp),
              onPressed: () {
                _openEditBottomSheet(con.list[index], index);
              },
            ),
          ),
        ],
      ),
    ),
  ),
);

                        },
                      ),
              ),
      ),
    );
  }

  // Method to handle the bottom sheet
  void _openEditBottomSheet(ContactList contactList, int index) {
    _nameController.text = contactList.listName ?? ''; // Initialize controller with current name

    showModalBottomSheet(
      backgroundColor: cc.bgcolor.value,
      context: context,
      isScrollControlled: true, // To allow the modal to cover a custom percentage of the screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Rounded corners at the top
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Covers 70% of the screen
          child: Padding(
            padding: EdgeInsets.all(16.0.h), // Padding around the bottom sheet content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Edit List Name', // Label
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cc.txtcolor.value,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text(
                      'List Name:', // Text field label
                      style: TextStyle(fontSize: 16.sp, color: cc.txtcolor.value),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _buildTextField(contactList.listName ?? ''),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Save button logic
                      await con.editListName(
                        _nameController.text,
                        contactList.pk.toString(),

                      );

                      Navigator.of(context).pop(); // Close the bottom sheet
                      con.fetchList();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cc.purplecolor.value, // Customize the button color
                      minimumSize: Size(100.w, 40.h), // Set button dimensions
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Obx(() => con.isLoadingMore.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildTextField(String name) {
    if (name == "Default") {
      return TextField(
        controller: _nameController,
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _openAddBottomSheet() {
    

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // To allow the modal to cover a custom percentage of the screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Rounded corners at the top
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Covers 70% of the screen
          child: Padding(
            padding: EdgeInsets.all(16.0.h), // Padding around the bottom sheet content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ADD List Name', // Label
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text(
                      'List Name:', // Text field label
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _buildTextField(''),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Save button logic
                      await con.addList(
                        _nameController.text
                        

                      );

                      Navigator.of(context).pop(); // Close the bottom sheet
                      con.fetchList();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cc.purplecolor.value, // Customize the button color
                      minimumSize: Size(100.w, 40.h), // Set button dimensions
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Obx(() => con.isLoadingMore.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
}
