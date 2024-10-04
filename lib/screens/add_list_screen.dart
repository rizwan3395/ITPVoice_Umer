import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/contact_list_controller.dart';
import 'package:itp_voice/controllers/tag_list_controller.dart';
import 'package:itp_voice/models/tag_model.dart';
import 'package:itp_voice/screens/colors.dart';
// Replace with your color picker if necessary

class AddListScreen extends StatefulWidget {


  AddListScreen();

  @override
  _AddListScreenState createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen> {
  final TextEditingController _nameController = TextEditingController();
  
  final ContactListController con = Get.put(ContactListController()); // Initialize your controller

  @override
  void initState() {
    super.initState();
     
  }

  @override
  Widget build(BuildContext context) {
    ColorController cc = Get.find<ColorController>();
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Add List',style: TextStyle(color: cc.txtcolor.value)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Padding around the content
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            SizedBox(height: 20.h),
            Row(
              children: [
                Text('List Name:', style: TextStyle(fontSize: 16,color: cc.txtcolor.value)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _buildTextField(),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  await con.addList(
                        _nameController.text
                      );
                  Get.back();
                  con.fetchList();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: Size(100, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Obx(() => con.isLoadingMore.value
                    ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text('Save', style: TextStyle(color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTextField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  
}
