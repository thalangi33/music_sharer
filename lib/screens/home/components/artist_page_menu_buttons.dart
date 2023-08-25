import 'package:flutter/material.dart';

class ArtistPageMenuTab extends StatefulWidget {
  final callback;
  ArtistPageMenuTab({required this.callback});
  @override
  State<ArtistPageMenuTab> createState() => _ArtistPageMenuTabState();
}

class _ArtistPageMenuTabState extends State<ArtistPageMenuTab>
    with SingleTickerProviderStateMixin {
  late MenuTabPainter painter;
  int buttonNum = 0;
  late AnimationController _controller;

  late Animation _leftAnimation;
  late Animation _rightAnimation;

  late Tween<double> _tweenLeft;
  late Tween<double> _tweenRight;

  callback(leftEnd, rightEnd) {
    setState(() {
      _tweenLeft.begin = _tweenLeft.end;
      _tweenRight.begin = _tweenRight.end;

      _tweenLeft.end = leftEnd;
      _tweenRight.end = rightEnd;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    painter = MenuTabPainter(buttonNum: 0);
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _tweenLeft =
        Tween<double>(begin: painter.getWidth()[0], end: painter.getWidth()[0]);
    _tweenRight =
        Tween<double>(begin: painter.getWidth()[1], end: painter.getWidth()[1]);

    _leftAnimation = _tweenLeft.animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _rightAnimation = _tweenRight.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void changePosition() {
    double startLeft = _tweenLeft.end ?? 0;
    double startRight = _tweenRight.end ?? 0;

    _controller.reset();
    _tweenLeft.begin = startLeft;
    _tweenRight.begin = startRight;

    _tweenLeft.end = painter.getWidth()[0];
    _tweenRight.end = painter.getWidth()[1];

    print("Hlell");
    print(painter.getWidth());
  }

  @override
  Widget build(BuildContext context) {
    painter = MenuTabPainter(
      buttonNum: buttonNum,
      leftAnimation: _leftAnimation,
      rightAnimation: _rightAnimation,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
            child: Stack(
          children: [
            Visibility(
              visible: false,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              maintainInteractivity: true,
              child: Row(
                children: [
                  // SizedBox(
                  //   width: 7,
                  // ),
                  FilledButton(
                      onPressed: () {
                        setState(() {
                          buttonNum = 0;
                          painter = MenuTabPainter(
                            buttonNum: buttonNum,
                            leftAnimation: _leftAnimation,
                            rightAnimation: _rightAnimation,
                          );
                        });
                        changePosition();
                        if (_controller.isCompleted) {
                          _controller.value = 0;
                        }
                        print("ButtonNum");
                        print(buttonNum);
                        _controller.forward();

                        widget.callback(0);
                      },
                      child: Text(
                        "Music",
                        style: TextStyle(fontSize: 20),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  FilledButton(
                      onPressed: () {
                        setState(() {
                          buttonNum = 1;
                          painter = MenuTabPainter(
                            buttonNum: buttonNum,
                            leftAnimation: _leftAnimation,
                            rightAnimation: _rightAnimation,
                          );
                        });
                        changePosition();
                        if (_controller.isCompleted) {
                          _controller.value = 0;
                        }
                        print("ButtonNum");
                        print(buttonNum);
                        _controller.forward();

                        widget.callback(1);
                      },
                      child: Text("Playlist", style: TextStyle(fontSize: 20))),
                  SizedBox(
                    width: 5,
                  ),
                  FilledButton(
                      onPressed: () {
                        setState(() {
                          buttonNum = 2;
                          painter = MenuTabPainter(
                            buttonNum: buttonNum,
                            leftAnimation: _leftAnimation,
                            rightAnimation: _rightAnimation,
                          );
                        });
                        changePosition();
                        if (_controller.isCompleted) {
                          _controller.value = 0;
                        }
                        print("ButtonNum");
                        print(buttonNum);
                        _controller.forward();

                        widget.callback(2);
                      },
                      child: Text("About", style: TextStyle(fontSize: 20)))
                ],
              ),
            ),
            IgnorePointer(
              child: CustomPaint(painter: painter),
            ),
          ],
        ));
      },
    );
  }
}

class MenuTabPainter extends CustomPainter {
  MenuTabPainter({
    required this.buttonNum,
    this.leftAnimation,
    this.rightAnimation,
  });

  final int buttonNum;
  Animation? leftAnimation;
  Animation? rightAnimation;

  final TextPainter textPainter1 = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
          text: "Music",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.4,
            color: Colors.white,
          )))
    ..layout();

  final TextPainter textPainter2 = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
          text: "Playlist",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.4,
            color: Colors.white,
          )))
    ..layout();

  final TextPainter textPainter3 = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
          text: "About",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.4,
            color: Colors.white,
          )))
    ..layout();

  List<double> getWidth() {
    double positionStart = 0;
    double positionEnd = 0;

    if (buttonNum == 0) {
      positionStart = 2;
      positionEnd = textPainter1.width + 44;
    }

    if (buttonNum == 1) {
      positionStart = 4 + textPainter1.width + 44 + 9;
      positionEnd = textPainter2.width + 44 + textPainter1.width + 44 + 9;
    }

    if (buttonNum == 2) {
      positionStart =
          4 + textPainter1.width + 44 + 9 + textPainter2.width + 44 + 9;
      positionEnd = textPainter3.width +
          44 +
          textPainter1.width +
          44 +
          9 +
          textPainter2.width +
          44 +
          11;
    }

    print(positionStart);
    print("ButtonNum in paint");

    print(buttonNum);

    return [positionStart, positionEnd];
  }

  @override
  void paint(Canvas canvas, Size size) {
    // ========================================== TextPainter
    textPainter1.paint(canvas, Offset(24, 9));
    textPainter2.paint(canvas, Offset(24 + textPainter1.width + 48 + 5, 9));
    textPainter3.paint(
        canvas,
        Offset(
            24 + textPainter1.width + 48 + 5 + textPainter2.width + 48 + 5, 9));

    print("Width");
    print(size.width);
    // ============================================== Rect

    final rectPaint = Paint()
      ..color = Colors.black
      ..blendMode = BlendMode.difference;
    canvas.drawRect(Offset(0, 0) & Size(size.width, size.height), rectPaint);
    final rectPaint2 = Paint()
      ..color = Colors.white
      ..blendMode = BlendMode.difference;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromPoints(Offset(leftAnimation?.value, 4),
                Offset(rightAnimation?.value, textPainter1.height + 15)),
            Radius.circular(20.0)),
        rectPaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
