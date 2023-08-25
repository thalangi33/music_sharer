import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
          child: SpinKitFadingCircle(
        size: 100,
        color: Theme.of(context).colorScheme.primary,
      )),
    );
  }
}
