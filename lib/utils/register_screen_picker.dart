import 'package:flutter/material.dart';

import '../screens/login.dart';

class RegisterScreenPicker extends StatefulWidget {
  const RegisterScreenPicker({Key? key}) : super(key: key);

  @override
  State<RegisterScreenPicker> createState() => _RegisterScreenPickerState();
}

class _RegisterScreenPickerState extends State<RegisterScreenPicker> {
  int isLogin = 0;
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    if (isLogin == 0) {
      return (SmsScreen(
        onChange: toggle,
      ));
    } else {
      return (EnterVerifyCode(
        phone: phoneNumber,
        moveRoute: setScreenCount,
      ));
    }
  }

  void setScreenCount(int currentScreenNum) {
    setState(() {
      isLogin = currentScreenNum;
    });
  }

  void toggle(String currentNumber) {
    setState(() {
      if (currentNumber.isNotEmpty) {
        phoneNumber = currentNumber;
        isLogin++;
      }
    });
  }
}