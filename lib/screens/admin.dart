import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/my_user.dart';
import '../utils/database_usage.dart';
import '../widgets/listview_tile.dart';

class AdminScreen extends StatefulWidget {
  MyUser currentAdmin;
  Function fun;
  Function editFun;
  Function deleteFun;
  AdminScreen({Key? key, required this.currentAdmin, required this.fun, required this.editFun, required this.deleteFun})
      : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  TextEditingController currentSearch = TextEditingController();
  String searchField = '';
  String toggled = 'All';
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
      borderSide: BorderSide.none);

  void changeText(String str) {
    setState(() {
      searchField = str;
    });
  }

  void changeToggled(String str) {
    setState(() {
      toggled = str;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xff201c24),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text("Hello, ${widget.currentAdmin.firstName}! 👋"),
        ),
        leading: GestureDetector(
          child: Icon(
            Icons.menu,
          ),
          onTap: () {},
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                onChanged: (value) => changeText(value),
                decoration: InputDecoration(
                  hintText: "Search a doctor or health issue",
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xff282434),
                  border: outlineInputBorder,
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ListViewTile(
              toggleFunction: changeToggled,
            ),
            SizedBox(
              height: 25,
            ),
            RaisedButton(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                widget.fun();
              },
              color: Color(0xff2f2f2f),
              child: Text(
                "+",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width - 40,
                  child: DatabaseUsage(
                    buttonStatus: toggled,
                    searchField: searchField,
                    isAdminEdit: true,
                    fun: widget.editFun,
                    deleteFun: widget.deleteFun,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}