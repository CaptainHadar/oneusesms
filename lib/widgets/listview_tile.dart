import 'package:flutter/material.dart';

import 'category_button.dart';

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
          CategoryButton(
            icon: "💊",
            description: "All",
            isClicked: (toggledDescription == "All"),
            func: changeDes,
          ),
          const SizedBox(
            width: 10,
          ),
          CategoryButton(
            icon: "💗",
            description: "Cardiology",
            isClicked: (toggledDescription == "Cardiology"),
            func: changeDes,
          ),
          const SizedBox(
            width: 10,
          ),
          CategoryButton(
            icon: "🧠",
            description: "Neurology",
            isClicked: (toggledDescription == "Neurology"),
            func: changeDes,
          ),
          const SizedBox(
            width: 10,
          ),
          CategoryButton(
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
