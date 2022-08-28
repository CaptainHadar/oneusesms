import 'package:flutter/material.dart';

class UpcomingScheduleCard extends StatefulWidget{
  String name;
  String practice;
  String imgUrl;
  String date;

  UpcomingScheduleCard({Key? key, required this.name, required this.practice, required this.date, required this.imgUrl}) : super(key: key);
  @override
  State<UpcomingScheduleCard> createState() => _UpcomingScheduleCardState();
}

class _UpcomingScheduleCardState extends State<UpcomingScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff0066FF),
      ),
      width: 280,
      height: 110,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.imgUrl,
                  cacheWidth: 30,
                  cacheHeight: 30,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("  ${widget.name}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "  ${widget.practice}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.video_call_outlined),
                  color: Colors.grey,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xff244cd8),
            ),
            width: 265,
            height: 45,
            child: Text(
              "  ${widget.date}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}