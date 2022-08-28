import 'package:flutter/material.dart';

class ListViewTile extends StatefulWidget {
  final Function(String) toggleFunction;

  ListViewTile({Key? key, required this.toggleFunction}) : super(key: key);

  @override
  State<ListViewTile> createState() => _ListViewTileState();
}

class _ListViewTileState extends State<ListViewTile> {
  String toggledDescription = "All";

  void changeDes(String str) {
    toggledDescription = str;
    widget.toggleFunction(str);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(
            width: 10,
          ),
          MyButton(
            icon: "💊",
            description: "All",
            isClicked: (toggledDescription == "All"),
            func: changeDes,
          ),
          const SizedBox(
            width: 10,
          ),
          MyButton(
            icon: "💗",
            description: "Cardiology",
            isClicked: (toggledDescription == "Cardiology"),
            func: changeDes,
          ),
          const SizedBox(
            width: 10,
          ),
          MyButton(
            icon: "🧠",
            description: "Neurology",
            isClicked: (toggledDescription == "Neurology"),
            func: changeDes,
          ),
          const SizedBox(
            width: 10,
          ),
          MyButton(
            icon: "🦶",
            description: "Orthopedy",
            isClicked: (toggledDescription == "Orthopedy"),
            func: changeDes,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  String icon;
  String description;
  bool isClicked;
  final Function(String) func;

  MyButton(
      {Key? key,
      required this.icon,
      required this.description,
      this.isClicked = false,
      required this.func})
      : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      color: Colors.transparent,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: (widget.isClicked)
              ? MaterialStateProperty.all<Color>(Colors.purple)
              : MaterialStateProperty.all<Color>(Color(0xff4f4f4f)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
        ),
        onPressed: () => widget.func(widget.description),
        child: Row(
          children: [
            Container(
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (widget.isClicked) ? Colors.white : Color(0xff4f4f4f)),
              child: Text(
                widget.icon,
                style: TextStyle(fontSize: 10),
              ),
            ),
            Text(
              "  " + widget.description,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
