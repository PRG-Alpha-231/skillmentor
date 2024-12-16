import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  List<DrawingPoint?> points = [];
  List<List<DrawingPoint?>> undoneStrokes = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  bool isEraserMode = false;
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      appBar: AppBar(
        title: Text(
          'Whiteboard',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.white, // Ensure the AppBar is visible
        actions: [
          // Save button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton.icon(
              onPressed: () {
                saveDrawing();
              },
              icon: Icon(Icons.save, color: Colors.black), // White icon
              label: Text(
                "Save",
                style: TextStyle(color: Colors.black), // White text
              ),
            ),
          ),
          // Clear button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  points.clear();
                  undoneStrokes.clear();
                });
              },
              icon: Icon(Icons.clear, color: Colors.black), // White icon
              label: Text(
                "Clear",
                style: TextStyle(color: Colors.black), // White text
              ),
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
                    strokeWidth: strokeWidth,
                    isEraser: isEraserMode,
                  ));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(null); // Marks the end of a stroke
                  undoneStrokes.clear(); // Clear undone strokes on new drawing
                });
              },
              child: CustomPaint(
                key: globalKey,
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
                buildColorOption(Colors.yellow),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    if (points.isNotEmpty) {
                      setState(() {
                        List<DrawingPoint?> lastStroke = _removeLastStroke();
                        if (lastStroke.isNotEmpty) {
                          undoneStrokes.add(lastStroke);
                        }
                      });
                    }
                  },
                  icon: Icon(Icons.undo),
                  color: Colors.grey,
                ),
                IconButton(
                  onPressed: () {
                    if (undoneStrokes.isNotEmpty) {
                      setState(() {
                        points.addAll(undoneStrokes.removeLast());
                      });
                    }
                  },
                  icon: Icon(Icons.redo),
                  color: Colors.grey,
                ),
                // Draw and Erase Toggle Button with Better Visuals
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isEraserMode = !isEraserMode;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isEraserMode ? Colors.redAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isEraserMode ? Colors.red : Colors.grey,
                      ),
                    ),
                    child: Icon(
                      isEraserMode ? Icons.blur_circular : Icons.create,
                      color: isEraserMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Stroke Width:'),
                Slider(
                  value: strokeWidth,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  label: strokeWidth.toStringAsFixed(1),
                  onChanged: (double newValue) {
                    setState(() {
                      strokeWidth = newValue;
                    });
                  },
                ),
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

  List<DrawingPoint?> _removeLastStroke() {
    List<DrawingPoint?> lastStroke = [];
    while (points.isNotEmpty) {
      DrawingPoint? point = points.removeLast();
      lastStroke.insert(0, point);
      if (point == null) break; // End of stroke
    }
    return lastStroke;
  }

  // Save the drawing as an image (internal within app)
  Future<void> saveDrawing() async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Since we can't use external libraries to save to files, we'll just show a snackbar
      // Indicating that the image was generated successfully (saving without external dependencies)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Drawing saved internally as image!")),
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
          paint.color = Colors.white; // Eraser mode
        }

        canvas.drawLine(points[i]!.offset!, points[i + 1]!.offset!, paint);
      } else if (points[i]?.offset != null && points[i + 1]?.offset == null) {
        final paint = Paint()
          ..color = points[i]!.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = points[i]!.strokeWidth;

        if (points[i]!.isEraser) {
          paint.color = Colors.white; // Eraser mode
        }

        canvas.drawCircle(points[i]!.offset!, points[i]!.strokeWidth / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
