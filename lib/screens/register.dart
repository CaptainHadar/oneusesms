import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneusesms/widgets/listview_tile.dart';
import 'package:oneusesms/models/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/category_button.dart';
import '../widgets/register_text_field_form.dart';
import 'login.dart';


class RegisterScreen extends StatefulWidget {
  String uid;
  Function fun;
  String phoneNumber;
  RegisterScreen({Key? key, required this.uid, required this.fun, required this.phoneNumber}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String current = "Male";

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController city = TextEditingController();
  String dropdownValue = 'Friends';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff201c24),
      appBar: AppBar(
        title: const Center(child: Text('Register')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView( child: Center(
        child: Column(
          children: [
            RegisterForm(form: firstName, lText: "First Name"),
            RegisterForm(form: lastName, lText: "Last Name"),
            RegisterForm(form: city, lText: "City"),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryButton(
                    icon: "♂",
                    description: "Male",
                    func: toggleGender,
                    isClicked: current == "Male",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CategoryButton(
                    icon: "♀",
                    description: "Female",
                    func: toggleGender,
                    isClicked: current == "Female",
                  ),
                ],
              ),
            ),

      DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>['Friends', 'App Store', 'Advertisements', 'Family']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
        ElevatedButton(
                onPressed: () {
                  sendInfoToDB();
                  widget.fun();
                },
                child: Text("Submit"))
          ],
        ),
      ),
      ),
    );
  }

  void toggleGender(String currentGender) {
    setState(() {
      current = currentGender;
    });
  }

  Future sendInfoToDB () async {
    MyUser usr = MyUser(firstName: firstName.text, lastName: lastName.text, phoneNumber: widget.phoneNumber, city: city.text, gender: current, foundApp: dropdownValue, uid: widget.uid);
    final currentUser = FirebaseFirestore.instance.collection("users").doc(widget.uid);
    final json = usr.toJSON();
    currentUser.set(json);



  }
}
