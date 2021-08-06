import 'package:flutter/material.dart';

class CurvedDrawer extends StatelessWidget {
  double width;
  double hight;
  CurvedDrawer({required this.width, required this.hight, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // size: Size(width, hight),
      painter: CustomCurvedDrawer(),
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 300,
            height: 300,
            child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: ListTile(
                          tileColor: Colors.green.shade100,
                          title: Card(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 30, left: 15, top: 20),
                              child: Text('${index}'),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class CustomCurvedDrawer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint()..color = Colors.green.shade400;
    canvas.drawCircle(
        new Offset(size.width / 2.5, size.height / 2), 177, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw true;
  }
}
