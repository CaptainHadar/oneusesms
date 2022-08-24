import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oneusesms/Doctor.dart';
import 'package:oneusesms/ListViewTile.dart';
import 'package:oneusesms/UpcomingScheduleTile.dart';
import 'package:oneusesms/databaseusage.dart';
import 'package:oneusesms/registerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oneusesms/User.dart';
import 'package:oneusesms/upload_pictures.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(home: customUserPage()));
}

class smsPage extends StatefulWidget {
  final Function(String) onChange;

  smsPage({Key? key, required this.onChange}) : super(key: key);

  @override
  State<smsPage> createState() => _smsLoginpage();
}

class _smsLoginpage extends State<smsPage> {
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
          title: const Text("smsLogin"),
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

class MyHomePage extends StatefulWidget {
  final usr;

  MyHomePage({Key? key, required this.usr}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String toggled = 'All';
  String searchField = '';

  void changeToggled(String str) {
    setState(() {
      toggled = str;
    });
  }

  void changeText(String str) {
    setState(() {
      searchField = str;
    });
  }

  void dummyFunction() {
  }

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
      borderSide: BorderSide.none);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Center(
            child: Text("Hello, ${widget.usr.getUsername()}! 👋"),
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
        backgroundColor: Color(0xff201c24),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: TextFormField(
                      onChanged: (value) => changeText(value),
                      decoration: InputDecoration(
                        hintText: "Search a doctor or health issue",
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.grey),
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
                ],
              ),
              SizedBox(height: 15),
              Text(
                "   Upcoming Schedule",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5),
              UpcommingScheduleTile(),
              SizedBox(height: 7.9),
              Text(
                "  Talk to a Dcotor",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Text(
                "    Get medical advice, prescriptions,\n    tests, and referrals",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListViewTile(
                toggleFunction: changeToggled,
              ),
              SizedBox(height: 7),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width - 40,
                    child: databaseusage(
                      buttonStatus: toggled,
                      searchField: searchField,
                      isAdminEdit: false,
                      fun: dummyFunction,
                      deleteFun: dummyFunction,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xff1c242c),
          selectedItemColor: Colors.blue,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: '•',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: '•',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.wechat),
              label: '•',
            ),
            BottomNavigationBarItem(
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://imgur.com/h6nr62G.png",
                  cacheHeight: 25,
                  cacheWidth: 25,
                ),
              ),
              label: '•',
            ),
          ],
        ));
  }
}

class NewContainer extends StatefulWidget {
  Doctor dctr;
  bool isAdminEdit;
  Function fun;
  Function deleteFun;
  NewContainer(
      {Key? key,
      required this.dctr,
      required this.isAdminEdit,
        required this.fun,
      required this.deleteFun})
      : super(key: key);

  @override
  State<NewContainer> createState() => _NewContainer();
}

class _NewContainer extends State<NewContainer> {
  String getStars(String starsnum) {
    String stars = "";
    for (int i = 0; i < int.parse(widget.dctr.rating); i++) stars += "⭐";
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff282434),
        ),
        height: 78,
        width: MediaQuery.of(context).size.width - 40,
        child: Padding(
          child: Row(
            children: [
              Container(
                width: (!widget.isAdminEdit) ? MediaQuery.of(context).size.width - 108 : MediaQuery.of(context).size.width - 150,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.dctr.imageLink,
                        cacheWidth: 50,
                        cacheHeight: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. " + widget.dctr.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.dctr.specialty,
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        Text(
                            getStars(widget.dctr.rating) +
                                " | " +
                                widget.dctr.reviews +
                                " reviews",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

                CircleAvatar(
                  backgroundColor: const Color(0xff4f4f4f),
                  radius: 17,
                  child: (!widget.isAdminEdit)
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.chat_bubble_outline),
                          color: Colors.grey,
                          onPressed: () {},
                        )
                      : IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.settings),
                          color: Colors.grey,
                          onPressed: () {
                            widget.fun(widget.dctr);
                          },
                        ),
                ),
              if(widget.isAdminEdit) SizedBox(width: 8),
              if(widget.isAdminEdit) CircleAvatar(
                backgroundColor: const Color(0xff4f4f4f),
                radius: 17,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.delete),
                  color: Colors.grey,
                  onPressed: () {
                    widget.deleteFun(widget.dctr);
                  },
                ),
              ),


            ],
          ),
          padding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}

class enterVerifyCode extends StatefulWidget {
  String phone;

  final Function(int) moveRoute;

  enterVerifyCode({Key? key, required this.phone, required this.moveRoute})
      : super(key: key);

  @override
  State<enterVerifyCode> createState() => _enterVerifyCodeState();
}

class _enterVerifyCodeState extends State<enterVerifyCode> {
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

class customUserPage extends StatefulWidget {
  const customUserPage({Key? key}) : super(key: key);

  @override
  State<customUserPage> createState() => _customUserPageState();
}

class _customUserPageState extends State<customUserPage> {
  bool isAddingDoctor = false;
  Doctor? dctr;

  void endedRegister() {
    setState(() {});
  }

  void deleteDoctor(Doctor currentDoctor) {
    setState(() {
      FirebaseFirestore.instance.collection("Doctors").doc(currentDoctor.uid).delete();
    });
  }

  void editDoctor(Doctor currentDoctor) {
    setState(() {
      if(currentDoctor != null)
      dctr = currentDoctor;
      isAddingDoctor = !isAddingDoctor;
    });
  }

  void addDoctor() {
    setState(() {
      isAddingDoctor = !isAddingDoctor;
      });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Stream<dynamic> docStream() async* {
            final doc = await FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            print(doc.id);
            if (doc.exists) {
              yield Users.fromJson(doc.data());
            }
          }

          return StreamBuilder(
            stream: docStream(),
            builder: (context, snapshot1) {
              if (snapshot1.hasData) {
                if ((snapshot1.data as Users).currentPermission == '0') {
                  return (MyHomePage(
                    usr: snapshot1.data,
                  ));
                } else {
                  if (!isAddingDoctor) {
                    dctr = null;
                    return (adminPage(
                        currentAdmin: (snapshot1.data as Users),
                        fun: addDoctor,
                        editFun: editDoctor,
                    deleteFun: deleteDoctor,));
                  }
                  else {
                    return (addDoctorPage(
                      currentAdmin: (snapshot1.data as Users),
                      fun: addDoctor,
                      dctr: dctr,));
                  }
                }
              } else {
                return (registerPage(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  fun: endedRegister,
                  phoneNumber:
                      FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                ));
              }
            },
          );
        } else
          return (customPage());
      },
    );
  }
}

class customPage extends StatefulWidget {
  const customPage({Key? key}) : super(key: key);

  @override
  State<customPage> createState() => _customPageState();
}

class _customPageState extends State<customPage> {
  int isLogin = 0;
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    if (isLogin == 0) {
      return (smsPage(
        onChange: toggle,
      ));
    } else {
      return (enterVerifyCode(
        phone: phoneNumber,
        moveRoute: setPageCount,
      ));
    }
  }

  void setPageCount(int currentPageNum) {
    setState(() {
      isLogin = currentPageNum;
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

class adminPage extends StatefulWidget {
  Users currentAdmin;
  Function fun;
  Function editFun;
  Function deleteFun;
  adminPage({Key? key, required this.currentAdmin, required this.fun, required this.editFun, required this.deleteFun})
      : super(key: key);

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
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
      body: Column(
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
                child: databaseusage(
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
    );
  }
}

class addDoctorPage extends StatefulWidget {
  Function fun;
  Users currentAdmin;
   Doctor? dctr;
   bool didDelete;
  addDoctorPage(
      {Key? key,
      required this.currentAdmin,
      required this.fun,
       this.dctr,
      this.didDelete = false})
      : super(key: key);

  @override
  State<addDoctorPage> createState() => _addDoctorPageState();
}

class _addDoctorPageState extends State<addDoctorPage> {
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
    else {
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
      lst.add(timeRows(placeInList: i,firstTime: today.elementAt(i),secondTime: today.elementAt(i+1),deleteButton: deleteButton,fun: deleteTimes,));
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
        if(today.length - 2 != i) tmp.add(timeRows(placeInList: i,
          firstTime: today.elementAt(i),
          secondTime: today.elementAt(i + 1),
          deleteButton: deleteButton,
          fun: deleteTimes,).getString() + ", ");
        else
          tmp.add(timeRows(placeInList: i,
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
              registerForm(form: name, lText: "Name"),
              registerForm(form: reviews, lText: "Reviews (Optional)"),
              registerForm(
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
                      ifEditing();
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
    dynamic currentUid = FirebaseFirestore.instance.collection("Doctors").doc().id;
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
        FirebaseFirestore.instance.collection("Doctors").doc(currentUid);
    final json = usr.toJSON();
    currentDoctor.set(json);
  }
}

class timeRows extends StatefulWidget{
  bool deleteButton;
  final Function fun;
  TimeOfDay firstTime;
  TimeOfDay secondTime;
  int placeInList;

  String getString() {
    return "${firstTime.hour.toString().padLeft(2,"0")}:${firstTime.minute.toString().padLeft(2,"0")} - ${secondTime.hour.toString().padLeft(2,"0")}:${secondTime.minute.toString().padLeft(2,"0")}";
  }

  timeRows({Key? key, this.deleteButton = false, required this.fun, required this.firstTime, required this.secondTime, required this.placeInList}) : super(key: key);
  State<timeRows> createState() => _timeRowsState();
}

class _timeRowsState extends State<timeRows> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${widget.firstTime.hour.toString().padLeft(2,"0")}:${widget.firstTime.minute.toString().padLeft(2,"0")} - ${widget.secondTime.hour.toString().padLeft(2,"0")}:${widget.secondTime.minute.toString().padLeft(2,"0")}", style: TextStyle(color: Colors.white, fontSize: 16),),
          SizedBox(width: 50,),
          (widget.deleteButton)?IconButton(onPressed: (){widget.fun(widget.placeInList);}, icon: Icon(Icons.close), color: Colors.red,):SizedBox(width: 20,),
        ],
      ),
    );
  }
}