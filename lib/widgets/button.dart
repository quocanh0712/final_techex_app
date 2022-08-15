import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  final Color buttonColor;

  const Button(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.width,
      required this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(25)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
