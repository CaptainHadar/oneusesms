import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/doctor.dart';
import '../utils/upload_pictures.dart';

class MyContainer extends StatefulWidget {
  Doctor dctr;
  bool isAdminEdit;
  Function fun;
  Function deleteFun;
  MyContainer(
      {Key? key,
        required this.dctr,
        required this.isAdminEdit,
        required this.fun,
        required this.deleteFun})
      : super(key: key);

  @override
  State<MyContainer> createState() => _MyContainer();
}

class _MyContainer extends State<MyContainer> {
  bool isExpanded = false;
  String getStars(String starsnum) {
    String stars = "";
    for (int i = 0; i < int.parse(widget.dctr.rating); i++) stars += "⭐";
    return stars;
  }

  void changeIsExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Container getTimes() {
    return Container(
      height: 64,
      width: MediaQuery.of(context).size.width - 40,
      child: SingleChildScrollView( scrollDirection: Axis.horizontal, child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          returnHours(0, "Sunday"),
          returnHours(2, "Tuesday"),
         returnHours(4, "Thursday"),
              returnHours(6, "Saturday"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              returnHours(1, "Monday"),
              returnHours(3, "Wednesday"),
              returnHours(5, "Friday"),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Text returnHours(int numberOfDay, String currentDay) {
    List<dynamic> schedule = widget.dctr.hoursOfDays;
    if(schedule.elementAt(numberOfDay) == '')
      return Text("$currentDay: Closed   ", style: TextStyle(color: Colors.white),);
    return Text("$currentDay: " + schedule.elementAt(numberOfDay) + "   ", style: TextStyle(color: Colors.white));
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
        height: (!isExpanded) ? 81 : 145,
        width: MediaQuery.of(context).size.width - 40,
        child: Padding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: (!widget.isAdminEdit) ? MediaQuery.of(context).size.width - 139 : MediaQuery.of(context).size.width - 181,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.dctr.imageLink,
                        cacheWidth: 50,
                        cacheHeight: 50,
                      ),
                    ),
                    SizedBox(width: 7),
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
              if(widget.isAdminEdit) SizedBox(width: 2),
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
              SizedBox(width: 2),
              CircleAvatar(
                backgroundColor: const Color(0xff4f4f4f),
                radius: 17,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: (!isExpanded) ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
                  color: Colors.grey,
                  onPressed: () {
                    changeIsExpanded();
                  },

                ),
              ),
            ],
          ),
            SizedBox(height: 5,),
            if(isExpanded)
              getTimes(),
        ],
          ),
          padding: const EdgeInsets.all(13),
        ),
      ),
    );
  }
}