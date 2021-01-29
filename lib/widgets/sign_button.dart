import 'package:book_swap/constants.dart';
import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  SignButton({ @required this.text , @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: secondaryColor),
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
