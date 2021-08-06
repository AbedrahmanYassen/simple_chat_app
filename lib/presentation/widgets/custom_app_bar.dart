import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  double screenWidth;
  double screenHeight;
  String name;
  String image;
  CustomAppBar(
      {required this.screenWidth,
      required this.screenHeight,
      required this.name,
      required this.image,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.white10, offset: new Offset(0, 6.0), blurRadius: 6.0)
      ]),
      width: screenWidth,
      height: screenHeight * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          Row(
            children: [
              Container(
                width: screenWidth * 1 / 5,
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(this.image))),
              ),
              Text(
                '${this.name}',
                style: TextStyle(
                    color: Colors.green.shade50,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
