import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:itp_voice/controllers/tag_list_controller.dart';
import 'package:itp_voice/models/tag_model.dart';
import 'package:itp_voice/screens/colors.dart';
// Replace with your color picker if necessary

class AddTagScreen extends StatefulWidget {
  final Tag contactList; // Pass the Tag object
  final int index;

  AddTagScreen({required this.contactList, required this.index});

  @override
  _AddTagScreenState createState() => _AddTagScreenState();
}

class _AddTagScreenState extends State<AddTagScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _clrController = TextEditingController();
  final TagListController con = Get.put(TagListController()); // Initialize your controller
  ColorController cc = Get.find<ColorController>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contactList.name ?? ''; // Initialize with the contact's name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgcolor.value,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Add Tag', style: TextStyle(color: cc.txtcolor.value)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Padding around the content
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add Tag', // Label
              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cc.txtcolor.value),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Tag Name:', style: TextStyle(fontSize: 16, color: cc.txtcolor.value)),
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
            Row(
              children: [
                Text("Tag Colors ", style: TextStyle(color: cc.txtcolor.value)),
                Obx(() => Checkbox(
                  value: con.isColor.value,
                  onChanged: (value) {
                    con.isColor.value = value ?? false; // Update isColor
                  },
                )),
              ],
            ),
            SizedBox(height: 20),
            Obx(() {
              return con.isColor.value
                  ? Row(
                      children: [
                        Text('Tag Color:', style: TextStyle(fontSize: 16, color: cc.txtcolor.value)),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: _buildColorField("#00FFFFFF"),
                          ),
                        ),
                      ],
                    )
                  : SizedBox();
            }),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveTag,
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

  _buildColorField(String tagColor) {
    con.currentcolor.value = createMaterialColor(hexToColor(tagColor));
    _clrController.text = colorToHex(hexToColor(tagColor));

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: cc.tabcolor.value,
              title: const Text('Pick a color'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: con.currentcolor.value,
                  availableColors: [
                    hexToColor("#d0021b"), // Red
                    hexToColor("#f5a623"), // Orange
                    hexToColor("#f8e71c"), // Yellow
                    hexToColor("#8b572a"), // Brown
                    hexToColor("#7ed321"), // Light Green
                    hexToColor("#417505"), // Green
                    hexToColor("#dff21b") // Light Yellow
                  ],
                  onColorChanged: (color) {
                    con.currentcolor.value = createMaterialColor(color);
                    _clrController.text = colorToHex(color);
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  child: const Text('Done'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Obx(() => Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: con.currentcolor.value,
              border: Border.all(color: Colors.grey),
            ),
          )),
    );
  }

  String materialColorToHexString(Color color) {
    // Extract the color's value and convert it to hex string
    String hex = color.value.toRadixString(16).substring(2);
    return hex.toUpperCase(); // Return uppercase to match your format
  }

  void _saveTag() async {
    String colorToSend = materialColorToHexString(con.currentcolor.value);
    await con.addTag(
      _nameController.text,
      colorToSend,
    );
    Navigator.of(context).pop(); // Close the screen
    con.fetchList();
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
