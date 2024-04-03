import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyGame());
}

class MyGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyGamePage(),
    );
  }
}

class MyGamePage extends StatefulWidget {
  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  Offset _squarePosition = Offset(0, 0);
  List<Widget> _circles = [];

  @override
  void initState() {
    super.initState();
    // Register the arrow key event listener
    RawKeyboard.instance.addListener(_handleKeyEvent);
    _startRandomCircles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move the Square Game'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          _moveSquare(details.delta);
        },
        child: Stack(
          children: [
            ..._circles,
            Positioned(
              left: _squarePosition.dx,
              top: _squarePosition.dy,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _moveSquare(Offset(-5.0, 0.0)); // Move left
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _moveSquare(Offset(5.0, 0.0)); // Move right
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _moveSquare(Offset(0.0, -5.0)); // Move up
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _moveSquare(Offset(0.0, 5.0)); // Move down
      }
    }
  }

  void _moveSquare(Offset delta) {
    setState(() {
      _squarePosition += delta;
    });
  }

  void _startRandomCircles() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (!mounted) return;
      _addCircle();
    });
  }

  void _addCircle() {
    final random = Random();
    setState(() {
      _circles.add(
        AnimatedPositioned(
          left: random.nextDouble() * 300,
          top: random.nextDouble() * 500,
          duration: Duration(seconds: 5),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    // Unregister the arrow key event listener
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }
}
