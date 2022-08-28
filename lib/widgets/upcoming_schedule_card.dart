import 'package:flutter/material.dart';
import 'package:oneusesms/widgets/upcoming_schedule_tile.dart';
class UpcomingSchedulePremadeTile extends StatefulWidget{
  const UpcomingSchedulePremadeTile({Key? key}) : super(key: key);

  @override
  State<UpcomingSchedulePremadeTile> createState() => _UpcomingScheduleTilePremadeState();
}

class _UpcomingScheduleTilePremadeState extends State<UpcomingSchedulePremadeTile> {
  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        SizedBox(width: 15),
        UpcomingScheduleCard(
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