import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../models/my_user.dart';
import '../utils/clock.dart';
import '../utils/upload_pictures.dart';
import '../widgets/register_text_field_form.dart';

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