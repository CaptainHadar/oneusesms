import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oneusesms/ListViewTile.dart';
import 'package:oneusesms/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class registerPage extends StatefulWidget {
  String uid;
  Function fun;
  String phoneNumber;
  registerPage({Key? key, required this.uid, required this.fun, required this.phoneNumber}) : super(key: key);

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
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
            registerForm(form: firstName, lText: "First Name"),
            registerForm(form: lastName, lText: "Last Name"),
            registerForm(form: city, lText: "City"),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NewButton(
                    icon: "♂",
                    description: "Male",
                    func: toggleGender,
                    isClicked: current == "Male",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  NewButton(
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
    Users usr = Users(firstName: firstName.text, lastName: lastName.text, phoneNumber: widget.phoneNumber, city: city.text, gender: current, foundApp: dropdownValue, uid: widget.uid);
    final currentUser = FirebaseFirestore.instance.collection("Users").doc(widget.uid);
    final json = usr.toJSON();
    currentUser.set(json);



  }
}


class registerForm extends StatelessWidget {
  TextEditingController form;
  String lText;

  registerForm({Key? key, required this.form, required this.lText})
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
