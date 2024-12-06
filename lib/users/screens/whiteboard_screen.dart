import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WhiteboardScreen(),
    );
  }
}

class WhiteboardScreen extends StatefulWidget {
  @override
  _WhiteboardScreenState createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  List<DrawingPoint> points = [];
  Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Whiteboard',
          style: TextStyle(
            fontSize: 20,  // Adjust the font size to make it smaller
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle save logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Save functionality not implemented")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  points.clear();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text("Clear", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  points.add(DrawingPoint(
                    offset: details.localPosition,
                    color: selectedColor,
                  ));
                });
              },
              onPanEnd: (details) {
                points.add(DrawingPoint(offset: null, color: selectedColor));
              },
              child: CustomPaint(
                size: Size(double.infinity, double.infinity),
                painter: WhiteboardPainter(points),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildColorOption(Colors.black),
                buildColorOption(Colors.red),
                buildColorOption(Colors.blue),
                buildColorOption(Colors.green),
                buildColorOption(Colors.orange),
                buildColorOption(Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.grey,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class DrawingPoint {
  final Offset? offset;
  final Color color;

  DrawingPoint({required this.offset, required this.color});
}

class WhiteboardPainter extends CustomPainter {
  final List<DrawingPoint> points;

  WhiteboardPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset != null && points[i + 1].offset != null) {
        final paint = Paint()
          ..color = points[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5.0;

        canvas.drawLine(points[i].offset!, points[i + 1].offset!, paint);
      } else if (points[i].offset != null && points[i + 1].offset == null) {
        final paint = Paint()
          ..color = points[i].color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5.0;

        canvas.drawCircle(points[i].offset!, 5.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
