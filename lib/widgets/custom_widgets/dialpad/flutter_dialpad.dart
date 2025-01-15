import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_dtmf/dtmf.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/screens/colors.dart';

class DialPad extends StatefulWidget {
  final ValueSetter<String>? makeCall;
  final ValueSetter<String>? keyPressed;
  final bool? hideDialButton;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? dialButtonColor;
  final Color? dialButtonIconColor;
  final IconData? dialButtonIcon;
  final Color? backspaceButtonIconColor;
  final Color? dialOutputTextColor;
  final String? outputMask;
  final bool? enableDtmf;
  final String? initialValue;

  const DialPad({super.key, 
    this.makeCall,
    this.keyPressed,
    this.hideDialButton,
    this.outputMask,
    this.buttonColor,
    this.buttonTextColor,
    this.dialButtonColor,
    this.dialButtonIconColor,
    this.dialButtonIcon,
    this.dialOutputTextColor,
    this.backspaceButtonIconColor,
    this.initialValue,
    this.enableDtmf,
  });

  @override
  _DialPadState createState() => _DialPadState();
}

class _DialPadState extends State<DialPad> {
  MaskedTextController? textEditingController;
  final ColorController cc = Get.put(ColorController());
  var _value = "";
  final mainTitle = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"];
  final subTitle = ["", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ", null, "+", null];

  @override
  void initState() {
    textEditingController = MaskedTextController(
      mask: widget.outputMask ?? '(000) 000-0000',
      translator: {"0": RegExp(r'[0123456789*#]')},
    );
    if (widget.initialValue != null) {
      for (String letter in widget.initialValue!.split("")) {
        if (letter != "+") _setText(letter);
      }
    }
    super.initState();
  }

  _setText(String? value) async {
    if ((widget.enableDtmf == null || widget.enableDtmf!) && value != null) {
      Dtmf.playTone(digits: value.trim(), samplingRate: 7000, durationMs: 160);
    }

    if (widget.keyPressed != null) widget.keyPressed!(value!);

    setState(() {
      _value += value!;
      textEditingController!.text = _value;
    });
  }

  List<Widget> _getDialerButtons() {
    var rows = <Widget>[];
    var items = <Widget>[];

    for (var i = 0; i < mainTitle.length; i++) {
      if (i % 3 == 0 && i > 0) {
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
        rows.add(const SizedBox(height: 12));
        items = <Widget>[];
      }

      items.add(DialButton(
        title: mainTitle[i],
        subtitle: subTitle[i],
        onTap: _setText,
      ));
    }

    rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
    rows.add(const SizedBox(height: 12));

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var sizeFactor = screenSize.height * 0.09852217;

    return Scaffold(
      body: Container(
        height: screenSize.height,
        width: screenSize.width,

        // Access the ColorController
        color: cc.bgcolor.value, // Reactive color for the background
        child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: cc.txtcolor.value, // Reactive color for the dial output
                              fontSize: sizeFactor / 2,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(border: InputBorder.none),
                            controller: textEditingController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: screenSize.height * 0.03685504),
                          child: Container(
                            height: 48.h,
                            width: 48.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(51, 212, 212, 212),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.close_outlined,
                                size: 24.h,
                                color: cc.txtcolor.value, // Reactive color for the icon
                              ),
                              onPressed: _value.isEmpty
                                  ? null
                                  : () {
                                      setState(() {
                                        _value = _value.substring(0, _value.length - 1);
                                        textEditingController!.text = _value;
                                      });
                                    },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._getDialerButtons(),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Expanded(child: Container()),
                      Expanded(
                        child:
                         widget.hideDialButton == true
                            ? GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios_new_sharp,
                                      size: 18.sp,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "Back To Call",
                                      style: TextStyle(fontSize: 15.sp,color: Colors.green),
                                    ),
                                  ],
                                ),
                              )
                        :     GestureDetector(
                                onTap: () {
                                  if (widget.makeCall != null) widget.makeCall!(_value);
                                },
                                child: Container(
                                  height: 68.h,
                                  width: 68.w,
                                  
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 76, 175, 80),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset("assets/images/dial.png"),
                                ),
                              ),
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: EdgeInsets.only(right: screenSize.height * 0.03685504),
                      //     child: IconButton(
                      //       icon: Icon(
                      //         Icons.backspace,
                      //         size: sizeFactor / 2,
                      //         color: _value.isNotEmpty
                      //             ? (widget.backspaceButtonIconColor ?? Colors.white24)
                      //             : Theme.of(context).scaffoldBackgroundColor,
                      //       ),
                      //       onPressed: _value.isEmpty
                      //           ? null
                      //           : () {
                      //               setState(() {
                      //                 _value = _value.substring(0, _value.length - 1);
                      //                 textEditingController!.text = _value;
                      //               });
                      //             },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
      ),
    );
  }
}

class DialButton extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final ValueSetter<String?>? onTap;

  const DialButton({super.key, this.title, this.subtitle, this.onTap});

  @override
  State<DialButton> createState() => _DialButtonState();
}

class _DialButtonState extends State<DialButton> {
  @override
  Widget build(BuildContext context) {
    // Access the ColorController
    final ColorController cc = Get.find<ColorController>();

    return  GestureDetector(
            onTap: () => widget.onTap?.call(widget.title),
            child: Obx(
              ()=> ClipOval(
                child:  Container(
                    color: cc.bgcolor.value, // Reactive color for the background
                    height: 95.h,
                    width: 95.w,
                    child: Center(
                      child: widget.subtitle != null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title!,
                                  style: TextStyle(
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.w500,
                                    color: cc.txtcolor.value, // Reactive text color
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: widget.title == "*" ? 14 : 0),
                              child: Text(
                                widget.title!,
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  color: cc.txtcolor.value, // Reactive text color
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
            ),
            
          
    );
  }
}

