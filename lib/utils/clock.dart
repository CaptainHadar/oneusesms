import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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