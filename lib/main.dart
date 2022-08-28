import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oneusesms/models/doctor.dart';
import 'package:oneusesms/screens/create_or_edit_doctor.dart';
import 'package:oneusesms/screens/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oneusesms/models/my_user.dart';
import 'package:oneusesms/utils/register_screen_picker.dart';
import 'screens/admin.dart';
import 'screens/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MaterialApp(home: CustomUserScreen()));
}

class CustomUserScreen extends StatefulWidget {
  const CustomUserScreen({Key? key}) : super(key: key);

  @override
  State<CustomUserScreen> createState() => _CustomUserScreenState();
}

class _CustomUserScreenState extends State<CustomUserScreen> {
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
            if (doc.exists) {
              yield MyUser.fromJson(doc.data());
            }
          }

          return StreamBuilder(
            stream: docStream(),
            builder: (context, snapshot1) {
              if (snapshot1.hasData) {
                if ((snapshot1.data as MyUser).currentPermission == '0') {
                  return (HomeScreen(
                    usr: snapshot1.data as MyUser,
                  ));
                } else {
                  if (!isAddingDoctor) {
                    dctr = null;
                    return (AdminScreen(
                        currentAdmin: (snapshot1.data as MyUser),
                        fun: addDoctor,
                        editFun: editDoctor,
                    deleteFun: deleteDoctor,));
                  }
                  else {
                    return (AddDoctorScreen(
                      currentAdmin: (snapshot1.data as MyUser),
                      fun: addDoctor,
                      dctr: dctr,
                    ));
                  }
                }
              } else {
                return (RegisterScreen(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  fun: endedRegister,
                  phoneNumber:
                      FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                ));
              }
            },
          );
        } else {
          return (const RegisterScreenPicker());
        }
      },
    );
  }
}