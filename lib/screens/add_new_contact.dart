import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/add_new_contact_controller.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/contactList.dart';
import 'package:itp_voice/models/get_contacts_reponse_model/contact_response.dart';
import 'package:itp_voice/screens/colors.dart';
import 'package:itp_voice/widgets/app_button.dart';
import 'package:itp_voice/widgets/app_textfield.dart';
import 'package:itp_voice/widgets/phone_number_field.dart';

import '../repo/contacts_repo.dart';

class AddNewContactScreen extends StatefulWidget {
  AddNewContactScreen({super.key});

  @override
  State<AddNewContactScreen> createState() => _AddNewContactScreenState();
}

class _AddNewContactScreenState extends State<AddNewContactScreen> {
  
  List<ContactList> contactList = [];
  
  final AddNewContactController con = Get.put(AddNewContactController());
  ContactsRepo contactRepo = Get.put(ContactsRepo());
  ColorController cc = Get.find<ColorController>();
  bool isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    loadContactList();
  }

  // Load contact list and update the loading state
  Future<void> loadContactList() async {
    try {
      contactList = await contactRepo.getContactsL();
      setState(() {
        isLoading = false; // Stop loading when data is fetched
      });
    } catch (e) {
      print("Error loading contacts: $e");
      setState(() {
        isLoading = false; // Stop loading even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: cc.iconcolor.value, size: 18.sp),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Add New Contact",
          style: TextStyle(
            color: cc.txtcolor.value,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading // Show loading spinner if data is still loading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildFieldLabel(context, "First Name", isRequired: false),
                    SizedBox(height: 10.h),
                    AppTextField(
                      textController: con.firstNameController,
                      hint: "Robert",
                    ),
                    SizedBox(height: 20.h),
                    _buildFieldLabel(context, "Last Name", isRequired: false),
                    SizedBox(height: 10.h),
                    AppTextField(
                      textController: con.lastNameController,
                      hint: "Doe",
                    ),
                    SizedBox(height: 32.h),
                    _buildFieldLabel(context, "Email", isRequired: false),
                    SizedBox(height: 8.h),
                    _buildEmailFields(),
                    SizedBox(height: 32.h),
                    _buildFieldLabel(context, "Phone Number", isRequired: false),
                    SizedBox(height: 8.h),
                    _buildPhoneNumberFields(),
                    SizedBox(height: 32.h),
                    _buildFieldLabel(context, "Contact List", isRequired: false),
                    SizedBox(height: 8.h),
                    _buildContactListDropdown(),
                    SizedBox(height: 32.h),
                    GestureDetector(
                      onTap: () {
                        con.saveContact();
                      },
                      child: AppButton(text: "Save"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              color: AppTheme.colors(context)?.textColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isRequired)
            TextSpan(
              text: " *",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberFields() {
    return GetBuilder<AddNewContactController>(
      init: con,
      builder: (AddNewContactController value) {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 5.h),
          shrinkWrap: true,
          itemCount: value.contactFieldsData.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                PhoneNumberField(
                  textController: value.contactFieldsData[index]['controller'],
                  hint: "xxx xxxxxxxx",
                  onChanged: (val) {
                    value.contactFieldsData[index]['code'] = val;
                  },
                ),
                if (index != 0)
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        value.removeContactField(index);
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildContactListDropdown() {
    con.contactListId = (contactList.isNotEmpty ? contactList[0].pk : null).toString();
  // Check if the contact list is empty or not loaded properly
  if (contactList == null || contactList.isEmpty) {
    return Text("No contact lists available");
  }

    int index=0;
  return GetBuilder<AddNewContactController>(
    init: con,
    builder: (AddNewContactController value) {
      // Ensure that value.selectedValues.value is a valid list item
      if (value.selectedValues.value.isEmpty && contactList.isNotEmpty) {
        // Assign the first contact list as the default value
        value.selectedValues.value = contactList[0].listName!;
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Color.fromARGB(255, 158, 158, 158),
            width: 0.5,
          ),
        ),
        child: DropdownButtonFormField(
  dropdownColor: cc.tabcolor.value,
  focusColor: Color.fromARGB(255, 200, 198, 198),
  value: contactList.isNotEmpty
      ? contactList[0].pk // Default to the first contact's pk
      : null,
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  ),
  items: contactList.map((ContactList contactLList) {
    return DropdownMenuItem(
      value: contactLList.pk, // Set the pk as the value
      child: Text(
        '${contactLList.listName} (${contactLList.contactCount})',
      ),
    );
  }).toList(),
  onChanged: (value) {
    // Update the selected pk value
    print("Selected pk: $value");
    con.contactListId = value.toString(); // Save pk as contactListId or handle accordingly
  },
),


      );
    },
  );
}


  Widget _buildEmailFields() {
    return GetBuilder<AddNewContactController>(
      init: con,
      builder: (AddNewContactController value) {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 5.h),
          shrinkWrap: true,
          itemCount: value.emailFieldsData.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                AppTextField(
                  hint: "john@abc.com",
                  textController: value.emailFieldsData[index]['controller'],
                ),
                if (index != 0)
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        value.removeEmailField(index);
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
