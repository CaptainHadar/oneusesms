import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmsScreen extends StatefulWidget {
  final Function(String) onChange;

  SmsScreen({Key? key, required this.onChange}) : super(key: key);

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
                },
                controller: TextEditingController(),
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
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

class EnterVerifyCode extends StatefulWidget {
  String phone;

  final Function(int) moveRoute;

  EnterVerifyCode({Key? key, required this.phone, required this.moveRoute})
      : super(key: key);

  @override
  State<EnterVerifyCode> createState() => _EnterVerifyCodeState();
}

class _EnterVerifyCodeState extends State<EnterVerifyCode> {
  TextEditingController mos = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              widget.moveRoute(2);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          widget.moveRoute(0);
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  void verifyInfo() async {
    if (mos.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithCredential(
            PhoneAuthProvider.credential(
                verificationId: _verificationCode!, smsCode: mos.text));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          title: const Text("Enter Verifction Code"),
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
                },
                controller: mos,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  fillColor: Colors.cyan,
                  filled: true,
                  hintText: '000-000',
                  labelText: 'Verifation Code',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: verifyInfo,
                child: const Text("Submit"),
              ),
            ],
          ),
        ));
  }
}