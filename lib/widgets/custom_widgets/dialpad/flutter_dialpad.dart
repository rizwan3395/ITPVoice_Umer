library flutter_dialpad;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_dtmf/dtmf.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';

class DialPad extends StatefulWidget {
  final ValueSetter<String>? makeCall;
  final ValueSetter<String>? keyPressed;
  final bool? hideDialButton;
  // buttonColor is the color of the button on the dial pad. defaults to Colors.gray
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? dialButtonColor;
  final Color? dialButtonIconColor;
  final IconData? dialButtonIcon;
  final Color? backspaceButtonIconColor;
  final Color? dialOutputTextColor;
  // outputMask is the mask applied to the output text. Defaults to (000) 000-0000
  final String? outputMask;
  final bool? enableDtmf;
  final String? initialValue;

  DialPad(
      {this.makeCall,
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
      this.enableDtmf});

  @override
  _DialPadState createState() => _DialPadState();
}

class _DialPadState extends State<DialPad> {
  MaskedTextController? textEditingController;
  var _value = "";
  var mainTitle = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"];
  var subTitle = ["", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ", null, "+", null];

  @override
  void initState() {
    textEditingController = MaskedTextController(
        mask: widget.outputMask != null ? widget.outputMask : '(000) 000-0000',
        translator: {"0": RegExp(r'[0123456789*#]')});
    if (widget.initialValue != null) {
      for (String letter in widget.initialValue!.split("")) {
        if (letter == "+") {
          null;
        } else {
          _setText(letter);
        }
      }
    }
    super.initState();
  }

  _setText(String? value) async {
    if ((widget.enableDtmf == null || widget.enableDtmf!) && value != null)
      Dtmf.playTone(digits: value.trim(), samplingRate: 8000, durationMs: 160);

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
        rows.add(SizedBox(
          height: 12,
        ));
        items = <Widget>[];
      }

      items.add(DialButton(
        title: mainTitle[i],
        subtitle: subTitle[i],
        color: widget.buttonColor,
        textColor: widget.buttonTextColor,
        onTap: _setText,
      ));
    }
    //To Do: Fix this workaround for last row
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
    rows.add(SizedBox(
      height: 12,
    ));

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var sizeFactor = screenSize.height * 0.09852217;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              readOnly: true,
              style: TextStyle(
                  color: AppTheme.colors(context)?.textColor
                  // widget.dialOutputTextColor ?? Colors.black
                  ,
                  fontSize: sizeFactor / 2),
              textAlign: TextAlign.center,
              decoration: InputDecoration(border: InputBorder.none),
              controller: textEditingController,
            ),
          ),
          ..._getDialerButtons(),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: widget.hideDialButton != null && widget.hideDialButton!
                    ? GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new_sharp,
                              size: 18.sp,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "Back To Call",
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        )),
                      )
                    : GestureDetector(
                        onTap: () {
                          widget.makeCall!(_value);
                          // widget.makeCall!(value);
                        },
                        child: Container(
                          padding: EdgeInsets.all(20.sp),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                Theme.of(context).colorScheme.primary,
                              ]),
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary),
                          child: Image.asset(
                            "assets/images/dial.png",
                            height: 30.h,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: screenSize.height * 0.03685504),
                  child: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      size: sizeFactor / 2,
                      color: _value.length > 0
                          ? (widget.backspaceButtonIconColor != null ? widget.backspaceButtonIconColor : Colors.white24)
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onPressed: _value.length == 0
                        ? null
                        : () {
                            if (_value.length > 0) {
                              setState(() {
                                _value = _value.substring(0, _value.length - 1);
                                textEditingController!.text = _value;
                              });
                            }
                          },
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class DialButton extends StatefulWidget {
  final Key? key;
  final String? title;
  final String? subtitle;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final Color? iconColor;
  final ValueSetter<String?>? onTap;
  final bool? shouldAnimate;
  DialButton(
      {this.key,
      this.title,
      this.subtitle,
      this.color,
      this.textColor,
      this.icon,
      this.iconColor,
      this.shouldAnimate,
      this.onTap});

  @override
  _DialButtonState createState() => _DialButtonState();
}

class _DialButtonState extends State<DialButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;
  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: widget.color != null ? widget.color : Colors.white24, end: Colors.white)
        .animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    if ((widget.shouldAnimate == null || widget.shouldAnimate!) && _timer != null) _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var sizeFactor = screenSize.height * 0.09852217;

    return GestureDetector(
      onTap: () {
        if (this.widget.onTap != null) this.widget.onTap!(widget.title);

        if (widget.shouldAnimate == null || widget.shouldAnimate!) {
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reverse();
          } else {
            _animationController.forward();
            _timer = Timer(const Duration(milliseconds: 200), () {
              setState(() {
                _animationController.reverse();
              });
            });
          }
        }
      },
      child: ClipOval(
        child: AnimatedBuilder(
          animation: _colorTween,
          builder: (context, child) => Container(
            color: Theme.of(context).extension<KAppColors>()?.buttonColor ?? Colors.white,
            height: 75.h,
            width: 75.w,
            padding: EdgeInsets.only(bottom: 10.h),
            child: Center(
                child: widget.icon == null
                    ? widget.subtitle != null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                widget.title!,
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.colors(context)?.textColor,
                                  // widget.textColor != null ? widget.textColor : Color(0xff4E4D4D),
                                ),
                              ),
                              Text(widget.subtitle!,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppTheme.colors(context)?.textColor,
                                    // widget.textColor != null ? widget.textColor : Color(0xff4E4D4D),
                                  ))
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: widget.title == "*" ? 14 : 0),
                            child: Text(
                              widget.title!,
                              style: TextStyle(
                                fontSize: 32.sp, color: AppTheme.colors(context)?.textColor,
                                // widget.textColor != null ? widget.textColor : Colors.black,
                              ),
                            ))
                    : Image.asset(
                        "assets/images/dial.png",
                        height: 25.h,
                      )),
          ),
        ),
      ),
    );
  }
}
