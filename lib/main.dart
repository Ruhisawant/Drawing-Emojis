import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<List<Offset>> lines = [];
  int currentFaceIndex = 0;
  bool isDrawingMode = true; // Add this variable to toggle drawing mode
  final List<CustomPainter> facePainters = [
    SmileyFace(),
    HeartEyesFace(),
    SadFace(),
    PartyFace(),
  ];

  void _toggleDrawingMode() {
    setState(() {
      isDrawingMode = !isDrawingMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing App'),
        actions: [
          IconButton(
            icon: Icon(isDrawingMode ? Icons.emoji_emotions : Icons.brush),
            onPressed: _toggleDrawingMode,
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition = renderBox.globalToLocal(details.globalPosition);
            if (lines.isEmpty || lines.last.isEmpty) {
              lines.add([localPosition]);
            } else {
              lines.last.add(localPosition);
            }
          });
        },
        onPanEnd: (_) {
          setState(() {
            lines.add([]);
          });
        },
        child: CustomPaint(
          painter: isDrawingMode
              ? DrawingPainter(lines)
              : facePainters[currentFaceIndex], // Toggle between drawing and faces
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            lines.clear();
          });
        },
        child: const Icon(Icons.clear),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentFaceIndex = 0; // Display Smiley Face
                });
              },
              child: const Text("Smiley Face"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentFaceIndex = 1; // Display Heart Face
                });
              },
              child: const Text("Heart Face"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentFaceIndex = 2; // Display Sad Face
                });
              },
              child: const Text("Sad Face"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentFaceIndex = 3; // Display Party Face
                });
              },
              child: const Text("Party Face"),
            ),
          ],
        ),
      ),
    );
  }
}

// Free Drawing
class DrawingPainter extends CustomPainter {
  final List<List<Offset>> lines;

  DrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    for (var line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Smiley Face
class SmileyFace extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintYellow = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    final paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final radius = size.width / 3;
    final bodyCenter = Offset(size.width / 2, size.height / 2);
    final leftEyeCenter = Offset(bodyCenter.dx - radius / 2.5, bodyCenter.dy - radius / 4);
    final rightEyeCenter = Offset(bodyCenter.dx + radius / 2.5, bodyCenter.dy - radius / 4);
    final mouthCenter = Offset(bodyCenter.dx, bodyCenter.dy + radius / 4);

    canvas.drawCircle(bodyCenter, radius, paintYellow);

    canvas.drawOval(
      Rect.fromCenter(center: leftEyeCenter, width: radius * 0.4, height: radius * 0.6),
      paintBlack
    ); // left eye

    canvas.drawOval(
      Rect.fromCenter(center: rightEyeCenter, width: radius * 0.4, height: radius * 0.6),
      paintBlack
    ); // right eye

    canvas.drawArc(
      Rect.fromCenter(center: mouthCenter, width: radius, height: radius / 1.1),
      0,
      pi,
      false,
      paintBlack
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Heart Eyes Face
class HeartEyesFace extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintYellow = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    final paintPink = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;
    final paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final radius = size.width / 3;
    final bodyCenter = Offset(size.width / 2, size.height / 2);
    final mouthCenter = Offset(bodyCenter.dx, bodyCenter.dy + radius / 4);

    final double width = size.width * 0.25;
    final double height = size.height * 0.25;
    final double topCurveHeight = height * 0.6;
    
    canvas.drawCircle(bodyCenter, radius, paintYellow);
    
    // left heart
    final heartLeft = Path();
    Offset heart1Center = Offset(bodyCenter.dx - radius / 2.5, bodyCenter.dy - radius * 0.01);
    heartLeft.moveTo(heart1Center.dx, heart1Center.dy);
    heartLeft.cubicTo(heart1Center.dx - width / 2, heart1Center.dy - height * 0.4,
                  heart1Center.dx - width / 2, heart1Center.dy - height, 
                  heart1Center.dx, heart1Center.dy - topCurveHeight);
    heartLeft.cubicTo(heart1Center.dx + width / 2, heart1Center.dy - height, 
                  heart1Center.dx + width / 2, heart1Center.dy - height * 0.4, 
                  heart1Center.dx, heart1Center.dy);
    canvas.drawPath(heartLeft, paintPink);

    // right heart
    final heartRight = Path();
    Offset heart2Center = Offset(bodyCenter.dx + radius / 2.5, bodyCenter.dy - radius * 0.01);
    heartRight.moveTo(heart2Center.dx, heart2Center.dy);
    heartRight.cubicTo(heart2Center.dx - width / 2, heart2Center.dy - height * 0.4,
                  heart2Center.dx - width / 2, heart2Center.dy - height, 
                  heart2Center.dx, heart2Center.dy - topCurveHeight);
    heartRight.cubicTo(heart2Center.dx + width / 2, heart2Center.dy - height, 
                  heart2Center.dx + width / 2, heart2Center.dy - height * 0.4, 
                  heart2Center.dx, heart2Center.dy);
    canvas.drawPath(heartRight, paintPink);

    canvas.drawArc(
      Rect.fromCenter(center: mouthCenter, width: radius, height: radius / 1.1),
      0,
      pi,
      false,
      paintBlack,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Sad Face
class SadFace extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintYellow = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    final paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final radius = size.width / 3;
    final bodyCenter = Offset(size.width / 2, size.height / 2);
    final leftEyeCenter = Offset(bodyCenter.dx - radius / 2.5, bodyCenter.dy - radius / 4);
    final rightEyeCenter = Offset(bodyCenter.dx + radius / 2.5, bodyCenter.dy - radius / 4);
    final mouthCenter = Offset(bodyCenter.dx, bodyCenter.dy + radius / 1.6);

    canvas.drawCircle(bodyCenter, radius, paintYellow);

    canvas.drawOval(
      Rect.fromCenter(center: leftEyeCenter, width: radius * 0.4, height: radius * 0.6),
      paintBlack
    ); // left eye

    canvas.drawOval(
      Rect.fromCenter(center: rightEyeCenter, width: radius * 0.4, height: radius * 0.6),
      paintBlack
    ); // right eye

    canvas.drawArc(
      Rect.fromCenter(center: mouthCenter, width: radius, height: radius / 1.1),
      pi,
      pi,
      false,
      paintBlack
    ); // Sad mouth
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Party Face
class PartyFace extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintYellow = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    final paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final radius = size.width / 3;
    final bodyCenter = Offset(size.width / 2, size.height / 2);
    final leftEyeCenter = Offset(bodyCenter.dx - radius / 2.5, bodyCenter.dy - radius / 4);
    final rightEyeCenter = Offset(bodyCenter.dx + radius / 2.5, bodyCenter.dy - radius / 4);
    final mouthCenter = Offset(bodyCenter.dx, bodyCenter.dy + radius / 4);

    canvas.drawCircle(bodyCenter, radius, paintYellow);

    canvas.drawOval(
      Rect.fromCenter(center: leftEyeCenter, width: radius * 0.4, height: radius * 0.6),
      paintBlack
    ); // left eye

    canvas.drawOval(
      Rect.fromCenter(center: rightEyeCenter, width: radius * 0.4, height: radius * 0.6),
      paintBlack
    ); // right eye

    canvas.drawArc(
      Rect.fromCenter(center: mouthCenter, width: radius, height: radius / 1.1),
      0,
      pi,
      false,
      paintBlack
    ); // Party mouth
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
