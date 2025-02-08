import 'package:flutter/material.dart';
import 'package:drawage/components/draw_painter.dart';
import 'package:drawage/models/draw_point.dart';

class DrawPage extends StatefulWidget {
  final int width;
  final int height;

  const DrawPage({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  List<DrawPoint> points = [];
  double brushSize = 1.0;
  Color brushColor = Colors.black;

  double scale = 1.0;
  Offset offset = Offset.zero;

  final List<Map<String, dynamic>> colors = [
    {"label": "Black", "color": Colors.black},
    {"label": "White", "color": Colors.white},
    {"label": "Red", "color": Colors.red},
    {"label": "Blue", "color": Colors.blue},
    {"label": "Green", "color": Colors.green},
    {"label": "Yellow", "color": Colors.yellow},
    {"label": "Orange", "color": Colors.orange},
    {"label": "Purple", "color": Colors.purple},
    {"label": "Pink", "color": Colors.pink},
    {"label": "Brown", "color": Colors.brown},
    {"label": "Grey", "color": Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Desenho')),
      body: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            scale = (scale * details.scale).clamp(0.5, 3.0);
            offset += details.focalPoint - details.localFocalPoint;
          });
        },
        child: Transform(
          transform: Matrix4.identity()
            ..translate(offset.dx, offset.dy)
            ..scale(scale),
          child: Container(
            color: Colors.white,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  points.add(DrawPoint(
                    position: details.localPosition,
                    paint: Paint()
                      ..color = brushColor
                      ..strokeCap = StrokeCap.round
                      ..strokeWidth = brushSize,
                  ));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add(DrawPoint(
                    position: null,
                    paint: Paint(),
                  ));
                });
              },
              child: CustomPaint(
                painter: DrawPainter(points),
                size: Size.infinite, // Corrige para evitar erros de layout
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.brush, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    double tempBrushSize = brushSize;

                    return StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                          title: Text("Tamanho do Pincel"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${tempBrushSize.toStringAsFixed(1)} px'),
                              Slider(
                                value: tempBrushSize,
                                min: 0.5,
                                max: 80.0,
                                onChanged: (value) {
                                  setDialogState(() {
                                    tempBrushSize = value;
                                  });
                                  setState(() {
                                    brushSize = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Fechar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.color_lens, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Escolha uma cor"),
                      content: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: GridView.count(
                            crossAxisCount: 4,
                            childAspectRatio: 1.0,
                            padding: const EdgeInsets.all(4.0),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            children: colors
                                .asMap()
                                .map(
                                  (i, element) => MapEntry(
                                    i,
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          brushColor = colors[i]['color'];
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colors[i]['color'],
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: colors[i]['color'],
                                            width:
                                                brushColor == colors[i]['color']
                                                    ? 3
                                                    : 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
