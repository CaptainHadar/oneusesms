import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  TextEditingController form;
  String lText;

  RegisterForm({Key? key, required this.form, required this.lText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff1c242c),
        ),
        child: TextFormField(
          controller: form,
          decoration: InputDecoration(
            icon: const Icon(Icons.person),
            filled: false,
            labelText: lText,
          ),
        ),
      ),
    );
  }
}