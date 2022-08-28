import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneusesms/screens/register.dart';
import '../models/doctor.dart';
import '../models/my_user.dart';
import '../utils/clock.dart';
import '../utils/database_usage.dart';
import '../utils/upload_pictures.dart';
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
                  child: Databaseusage(
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

class AddDoctorScreen extends StatefulWidget {
  Function fun;
  MyUser currentAdmin;
  Doctor? dctr;
  bool didDelete;
  AddDoctorScreen(
      {Key? key,
        required this.currentAdmin,
        required this.fun,
        this.dctr,
        this.didDelete = false})
      : super(key: key);

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final Storage storage = Storage();
  bool didUpload = false;
  bool deleteButton = false;
  String currentFileName = '';
  String current = "Male";
  String specialtyValue = 'Cardiology';
  TextEditingController name = TextEditingController();
  TextEditingController imageLink = TextEditingController();
  TextEditingController reviews = TextEditingController();
  TextEditingController rating = TextEditingController();
  String dropdownValue = 'Sunday';
  List<List<TimeOfDay>> currentSchedule = <List<TimeOfDay>>[
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  Future addTimes() async {
    int firstTimeIndex = 0;
    List<TimeOfDay> today = currentSchedule.elementAt(getTimesInDay() - 1);
    TimeOfDay? firstTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0));
    if (firstTime ==null) return;
    if(today.length != 0) {
      while(firstTimeIndex <today.length && today.elementAt(firstTimeIndex).hour * 60 + today.elementAt(firstTimeIndex).minute < firstTime.hour * 60 + firstTime.minute){
        firstTimeIndex++;
      }
    }
    if(firstTimeIndex % 2 == 0){
      TimeOfDay? secondTime = await showTimePicker(context: context, initialTime: firstTime);
      if (secondTime == null) return;
      if(firstTime.hour * 60 + firstTime.minute < secondTime.hour * 60 + secondTime.minute){
        print("1");
        if(firstTimeIndex!=today.length){
          print("2");
          if(secondTime.hour * 60 + secondTime.minute >= today.elementAt(firstTimeIndex+1).hour * 60 + today.elementAt(firstTimeIndex+1).minute) {
            print("3");
            return;
          }
        }
        setState((){
          currentSchedule.elementAt(getTimesInDay()-1).insert(firstTimeIndex,firstTime);
          currentSchedule.elementAt(getTimesInDay()-1).insert(firstTimeIndex + 1,secondTime);
        });
      }
    }
  }

  void dummyFunction() {
    setState(() {
    });
  }

  void ifEditing() {
    if(widget.dctr != null && !widget.didDelete) {
      name = TextEditingController(text: widget.dctr?.name);
      imageLink = TextEditingController(text: widget.dctr?.imageLink);
      reviews = TextEditingController(text: widget.dctr?.reviews);
      rating = TextEditingController(text: widget.dctr?.rating);
      widget.didDelete = true;
    }
    if(widget.dctr == null && !widget.didDelete) {
      name.clear();
      imageLink.clear();
      reviews.clear();
      rating.clear();
    }
  }

  int getTimesInDay() {
    switch (dropdownValue) {
      case 'Sunday':
        return 1;
      case 'Monday':
        return 2;
      case 'Tuesday':
        return 3;
      case 'Wednesday':
        return 4;
      case 'Thursday':
        return 5;
      case 'Friday':
        return 6;
      case 'Saturday':
        return 7;
    }
    return 69;
  }

  void deleteTimes(int i){
    setState((){
      currentSchedule.elementAt(getTimesInDay() - 1).removeAt(i);
      currentSchedule.elementAt(getTimesInDay() - 1).removeAt(i);
    });
  }

  Container getTimes() {
    List<TimeOfDay> today = currentSchedule.elementAt(getTimesInDay() - 1);
    List<Widget> lst = [];
    for (int i = 0; i < today.length; i+=2) {
      lst.add(TimeRows(placeInList: i,firstTime: today.elementAt(i),secondTime: today.elementAt(i+1),deleteButton: deleteButton,fun: deleteTimes,));
    }
    return Container(
      child: Column(
        children: lst,
      ),
    );
  }

  List<String> getTimesList() {
    // List<TimeOfDay> today = currentSchedule.elementAt(getTimesInDay() - 1);
    List<TimeOfDay> today;
    List<String> tmp = [];
    List<String> days = [];
    for(int j = 1; j < 8; j++) {
      tmp = [];
      today = currentSchedule.elementAt(j - 1);
      for (int i = 0; i < today.length; i += 2) {
        if(today.length - 2 != i) tmp.add(TimeRows(placeInList: i,
          firstTime: today.elementAt(i),
          secondTime: today.elementAt(i + 1),
          deleteButton: deleteButton,
          fun: deleteTimes,).getString() + ", ");
        else
          tmp.add(TimeRows(placeInList: i,
            firstTime: today.elementAt(i),
            secondTime: today.elementAt(i + 1),
            deleteButton: deleteButton,
            fun: deleteTimes,).getString());
      }
      days.add(toStringTimes(tmp));
    }
    for(int i = 0; i < days.length; i++)
      print(days.elementAt(i));
    return days;
  }

  String toStringTimes(List<String> lst) {
    String currentString = '';
    for(int i = 0; i < lst.length; i++)
      currentString += lst.elementAt(i);
    return currentString;
  }

  void toggleDeleteTimes(){
    setState (() => deleteButton = !deleteButton);
  }


  @override
  Widget build(BuildContext context) {
    ifEditing();
    return Scaffold(
      backgroundColor: Color(0xff201c24),
      appBar: AppBar(
        title: const Center(child: Text('Register')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RegisterForm(form: name, lText: "Name"),
              RegisterForm(form: reviews, lText: "Reviews (Optional)"),
              RegisterForm(
                  form: rating, lText: "Number Of Rating Stars (Optional)"),
              ElevatedButton(
                  onPressed: () async {
                    final results = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg'],
                    );

                    if (results == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No file selected.'),
                          )
                      );
                    }
                    final filePath = results!.files.single.path!;
                    final fileName = results.files.single.name;
                    currentFileName = fileName;
                    storage.uploadaFile(filePath, fileName).then((value) => didUpload = true);
                    dummyFunction();
                  },
                  child: (!didUpload) ? Text("Upload Profile Picture") : Text("Done!") ),
              DropdownButton<String>(
                value: specialtyValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    specialtyValue = newValue!;
                  });
                },
                items: <String>[
                  'Cardiology',
                  'Neurology',
                  'Orthopedy',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    items: <String>[
                      'Sunday',
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () => toggleDeleteTimes(),
                      child: Text("Reset Time")),
                  SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {
                        addTimes();
                      },
                      child: Text("Add Time")),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              getTimes(),
              ElevatedButton(
                  onPressed: () {
                    if(name.text.isNotEmpty) {
                      sendInfoToDB();
                      getTimesList();
                      widget.fun();
                    }
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

  Future sendInfoToDB() async {
    dynamic currentUid = FirebaseFirestore.instance.collection("doctors").doc().id;
    if(widget.dctr != null)
      currentUid = widget.dctr?.uid;
    Doctor usr = Doctor(
        name: name.text,
        specialty: specialtyValue,
        reviews: (reviews.text == '') ? '0' : reviews.text,
        rating: (rating.text == '') ? '5' : rating.text,
        uid: currentUid,
        imageLink: (!didUpload)
            ? 'https://imgur.com/x46dlIO.png'
            : await storage.downloadURL(currentFileName),
        hoursOfDays: getTimesList());
    final currentDoctor =
    FirebaseFirestore.instance.collection("doctors").doc(currentUid);
    final json = usr.toJSON();
    currentDoctor.set(json);
  }
}