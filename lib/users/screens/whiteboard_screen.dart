import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';




class WhiteboardScreen extends StatefulWidget {
  @override
  _WhiteboardScreenState createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  List<DrawingPoint?> points = [];
  List<List<DrawingPoint?>> undoneStrokes = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  bool isEraserMode = false;
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Whiteboard', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton.icon(
              onPressed: () {
                saveDrawing();
              },
              icon: Icon(Icons.save, color: Colors.black),
              label: Text("Save", style: TextStyle(color: Colors.black)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  points.clear();
                  undoneStrokes.clear();
                });
              },
              icon: Icon(Icons.clear, color: Colors.black),
              label: Text("Clear", style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.white,
                  ),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        points.add(DrawingPoint(
                          offset: details.localPosition,
                          color: selectedColor,
                          strokeWidth: strokeWidth,
                          isEraser: isEraserMode,
                        ));
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        points.add(null);
                        undoneStrokes.clear();
                      });
                    },
                    child: RepaintBoundary(
                      key: globalKey,
                      child: CustomPaint(
                        size: Size(double.infinity, double.infinity),
                        painter: WhiteboardPainter(points),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Color selection, stroke width, undo/redo, etc.
        ],
      ),
    );
  }

  Future<void> saveDrawing() async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getExternalStorageDirectory();
      String filePath = '${directory!.path}/whiteboard_drawing.png';
      File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Drawing saved to Downloads folder!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving drawing")),
      );
    }
  }
}

class DrawingPoint {
  final Offset? offset;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  DrawingPoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
    required this.isEraser,
  });
}

class WhiteboardPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  WhiteboardPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i]?.offset != null && points[i + 1]?.offset != null) {
        final paint = Paint()
          ..color = points[i]!.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = points[i]!.strokeWidth;

        if (points[i]!.isEraser) {
          paint.color = Colors.white;
        }

        canvas.drawLine(points[i]!.offset!, points[i + 1]!.offset!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}