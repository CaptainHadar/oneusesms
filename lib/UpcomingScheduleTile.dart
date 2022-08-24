import 'package:flutter/material.dart';
class UpcommingScheduleTile extends StatefulWidget{
  const UpcommingScheduleTile({Key? key}) : super(key: key);

  @override
  State<UpcommingScheduleTile> createState() => _UpcommingScheduleTileState();
}

class _UpcommingScheduleTileState extends State<UpcommingScheduleTile> {
  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        SizedBox(width: 15),
        UpcommingScheduleContainer(
          date: "📅 Sun - May 10, 1:00pm - 2:00pm",
          imgUrl: "https://imgur.com/1CVohyf.png",
          name: "Dr. Shilgiaoo Kashti",
          practice: "General Practice",
        ),
        SizedBox(
          width: 15,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          buttonHeight: 110,
          children: [
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {},
              color: Color(0xff2f2f2f),
              child: Text(
                "+",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
class UpcommingScheduleContainer extends StatefulWidget{
  String name;
  String practice;
  String imgUrl;
  String date;

  UpcommingScheduleContainer({Key? key, required this.name, required this.practice, required this.date, required this.imgUrl}) : super(key: key);
  @override
  State<UpcommingScheduleContainer> createState() => _UpcommingScheduleContainerState();
}

class _UpcommingScheduleContainerState extends State<UpcommingScheduleContainer> {
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