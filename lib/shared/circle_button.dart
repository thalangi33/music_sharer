import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(
      {super.key,
      required this.icon,
      required this.color,
      required this.height,
      required this.width,
      required this.splashColor, required this.onTap});

  final Icon icon;
  final Color color;
  final double height;
  final double width;
  final Color splashColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: InkWell(
          splashColor: splashColor,
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Ink(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              height: height,
              width: width,
              child: icon),
        ),
      ),
    );
  }
}
