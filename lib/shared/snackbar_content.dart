import 'package:flutter/material.dart';

class CustomSnackBarContent extends StatelessWidget {
  const CustomSnackBarContent({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Text(message,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
