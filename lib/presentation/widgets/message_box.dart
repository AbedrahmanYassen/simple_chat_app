import 'package:flutter/material.dart';

class MessageBox extends StatefulWidget {
  double leftPadding;
  double rightPadding;
  String content;
  String subtitle;
  Color color;
  MessageBox(
      {required this.leftPadding,
      required this.rightPadding,
      required this.content,
      required this.subtitle,
      required this.color,
      Key? key})
      : super(key: key);

  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: widget.leftPadding, right: widget.rightPadding),
      child: Card(
        color: widget.color,
        child: ListTile(
          title: SelectableText(widget.content),
          subtitle: Text(widget.subtitle),
        ),
      ),
    );
  }
}
