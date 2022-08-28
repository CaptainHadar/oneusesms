import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/doctor.dart';
import '../screens/main.dart';
import '../widgets/my_container.dart';

class databaseusage extends StatefulWidget {
  final String buttonStatus;
  final String searchField;
  final bool isAdminEdit;
  final Function fun;
  final Function deleteFun;
   databaseusage(
      {Key? key, required this.buttonStatus, required this.searchField, required this.isAdminEdit, required this.fun, required this.deleteFun})
      : super(key: key);

  @override
  State<databaseusage> createState() => _databaseusageState();
}

class _databaseusageState extends State<databaseusage> {
  Widget displayDoctors(List<Doctor> doctorList) => ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: doctorList.length,
        itemBuilder: (context, index) {
          final doctor = doctorList[index];
          if ((doctor.specialty == widget.buttonStatus ||
                  widget.buttonStatus == 'All') &&
              doctor.name.contains(widget.searchField)) {
            return MyContainer(
            dctr: doctor,
            fun: widget.fun,
            deleteFun: widget.deleteFun,
            isAdminEdit: widget.isAdminEdit);
          } else
            return SizedBox(
              height: 0.1,
            );
        },
      );


    getDoctors() async {
     // String data = await rootBundle.loadString('assets/doctorList.json');
     // final body = json.decode(data);
     final doc = await FirebaseFirestore.instance
         .collection("doctors").get();
    // return body.map<Doctor>(Doctor.fromJson).toList();
     return doc.docs.map<Doctor>(Doctor.fromJson).toList();
   }

  //  Stream<List<Doctor>> getDoctors() => FirebaseFirestore.instance.collection("Doctors").snapshots().map((snapshot) => snapshot.docs.map((doc) => Doctor.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<List<Doctor>>(
    //   future: doctorsFuture,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       return Text('Error ${snapshot.error}');
    //     } else if (snapshot.hasData) {
    //       final doctors = snapshot.data!;
    //
    //       return displayDoctors(doctors);
    //     } else {
    //       return const Text('No User Data');
    //     }
    //     ;
    //   },
    // );

    return FutureBuilder(
      future: getDoctors(),
      builder: (context, snapshot) {
          if(snapshot.hasData) {
            return displayDoctors((snapshot.data as List<Doctor>).toList());
          }
          else {
            if(snapshot.hasError)
            return Text('Error ${snapshot.error}');
            else
              return Text("Snapshot is empty!");
          }
      },
    );
  }
}
