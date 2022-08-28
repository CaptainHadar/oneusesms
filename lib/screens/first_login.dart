import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SmsScreen extends StatefulWidget {
  final Function(String) onChange;

  const SmsScreen({Key? key, required this.onChange}) : super(key: key);

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  String currentNumber = '';

  void updateOnChange() {
    setState(() {
      widget.onChange(currentNumber);
    });
  }

  void updateCurrentNumber(String phoneNumber) {
    currentNumber = phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          title: const Text("Login Screen!"),
        ),
        body: Form(
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isNotEmpty && value.length > 5) {
                    return null;
                  } else if (value.isNotEmpty && value.length < 5) {
                    return "Not a real name";
                  } else if (value.isEmpty) {
                    return "You need to fill this";
                  }
                  return null;
                },
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  fillColor: Colors.cyan,
                  filled: true,
                  hintText: '+972 50-123-4567',
                  labelText: 'Phone Number',
                ),
                onChanged: (text) {
                  updateCurrentNumber(text);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: updateOnChange,
                child: const Text("Submit"),
              ),
            ],
          ),
        ));
  }
}