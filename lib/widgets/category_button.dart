
import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  String icon;
  String description;
  bool isClicked;
  final Function(String) func;

  CategoryButton(
      {Key? key,
        required this.icon,
        required this.description,
        this.isClicked = false,
        required this.func})
      : super(key: key);

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
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