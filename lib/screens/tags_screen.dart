import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itp_voice/controllers/tag_list_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:itp_voice/models/tag_model.dart';
import 'package:itp_voice/screens/add_tag_screen.dart';
import 'package:itp_voice/screens/colors.dart';

class TagsScreen extends StatefulWidget {
  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagsScreen> {
  ColorController cc = Get.find<ColorController>();
  final TagListController con = Get.put(TagListController());
  final ScrollController _scrollController = ScrollController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _clrController = TextEditingController();


  @override
  void initState() {
    super.initState();
    con.fetchList(); // Fetch tags when the screen loads
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !con.isListLoading.value) {
        con.loadMoreList(); // Load more tags when reached the bottom
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
            icon: Icon(Icons.add, size: 20.sp, color: cc.iconcolor.value),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddTagScreen(
                    contactList: Tag(),
                    index: -1,
                  ),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
        title: Text('Tags', style: TextStyle(color:cc.txtcolor.value)),
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
                          "No Tags Available",
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
  margin: EdgeInsets.symmetric(vertical: 2.h),
  child: ListTile(
    contentPadding: EdgeInsets.symmetric(
        horizontal: 20.w, vertical: 5.h),
    title: Text(
      '${con.list[index].name}',
      style: TextStyle(fontSize: 16.sp), // Responsive font size
      overflow: TextOverflow.ellipsis, // Prevent text overflow
    ),
    subtitle: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      color: hexToColor(con.list[index].tagColor!),
      child: Text(
        '', // Subtitle text (if any)
        style: TextStyle(color: Colors.black, fontSize: 14.sp),
        overflow: TextOverflow.ellipsis,
      ),
    ),
    onTap: () {
      // Handle tap to navigate to tag details screen
    },
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.delete, size: 20.sp, color: cc.iconcolor.value),
          onPressed: () {
            // Show delete confirmation dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: cc.tabcolor.value,
                  title: Text('Delete Tag', style: TextStyle(color: cc.txtcolor.value)),
                  content: Text('Are you sure you want to delete this tag?', style: TextStyle(color: cc.txtcolor.value)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog without deleting
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: cc.purplecolor.value),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close dialog
                        await con.deleteTag(con.list[index].pk.toString()); // Perform delete
                        con.fetchList(); // Refresh list
                      },
                      child: Obx(() => con.isLoadingMore.value
                          ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                          : Text('Delete', style: TextStyle(color: Colors.white))),
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.edit, size: 20.sp, color: cc.iconcolor.value),
          onPressed: () {
            _openEditBottomSheet(con.list[index], index); // Open edit bottom sheet
          },
        ),
      ],
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
  void _openEditBottomSheet(Tag contactList, int index) {
    _nameController.text = contactList.name ?? '';
    // Initialize controller with current name

    showModalBottomSheet(
      backgroundColor: cc.bgcolor.value,
      context: context,
      isScrollControlled:
          true, // To allow the modal to cover a custom percentage of the screen
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Rounded corners at the top
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Covers 70% of the screen
          child: Padding(
            padding: EdgeInsets.all(
                16.0.h), // Padding around the bottom sheet content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Edit Tag Name', // Label
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
                      'Tag Name:', // Text field label
                      style:
                          TextStyle(fontSize: 16.sp, color: cc.txtcolor.value),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _buildTextField(contactList.name ?? ''),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      'Tag Color:', // Text field label
                      style:
                          TextStyle(fontSize: 16.sp, color: cc.txtcolor.value),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _buildColorField(contactList.tagColor ?? ''),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      String colorToSend = materialColorToHexString(
                          con.currentcolor.value); // Convert color for API
                      await con.editTagName(
                        _nameController.text,
                        contactList.pk.toString(),
                        colorToSend,
                      );
                      Navigator.of(context).pop(); // Close the bottom sheet
                      con.fetchList();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.purple, // Customize the button color
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

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  _buildColorField(String tagColor) {
    con.currentcolor.value = createMaterialColor(hexToColor(tagColor));
    _clrController.text = colorToHex(hexToColor(tagColor));
    // Ensure the currentcolor in controller is an Rx<Color>
    // Convert hex string to MaterialColor

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pick a color'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: con.currentcolor.value, // Use MaterialColor
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
                    // Wrap selected color
                    print(
                        "(((((((((((((((())))))))))))))))))______________________");
                    print(con.currentcolor.value);
                    _clrController.text = colorToHex(color);
                    setState(() {
                      // This triggers a rebuild to reflect the changes
                    }); // Update text field with selected color
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  child: const Text('Done'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the color picker dialog
                  },
                ),
              ],
            );
          },
        );
      },
      child: Obx(() => Container(
            height: 50.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color:
                  con.currentcolor.value, // Show the selected color reactively
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

  _buildTextField(String name) {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
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
