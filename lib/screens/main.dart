import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oneusesms/models/doctor.dart';
import 'package:oneusesms/screens/register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oneusesms/models/my_user.dart';
import 'admin_pages.dart';
import 'home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(home: customUserPage()));
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
      FirebaseFirestore.instance.collection("doctors").doc(currentDoctor.uid).delete();
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
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            print(doc.id);
            if (doc.exists) {
              yield MyUser.fromJson(doc.data());
            }
          }

          return StreamBuilder(
            stream: docStream(),
            builder: (context, snapshot1) {
              if (snapshot1.hasData) {
                if ((snapshot1.data as MyUser).currentPermission == '0') {
                  return (MyHomePage(
                    usr: snapshot1.data as MyUser,
                  ));
                } else {
                  if (!isAddingDoctor) {
                    dctr = null;
                    return (adminPage(
                        currentAdmin: (snapshot1.data as MyUser),
                        fun: addDoctor,
                        editFun: editDoctor,
                    deleteFun: deleteDoctor,));
                  }
                  else {
                    return (addDoctorPage(
                      currentAdmin: (snapshot1.data as MyUser),
                      fun: addDoctor,
                      dctr: dctr,
                    ));
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