import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_chat_app/data/models/message.dart';
import 'package:islamic_chat_app/data/models/user.dart';
import 'package:islamic_chat_app/presentation/widgets/custom_app_bar.dart';
import 'package:islamic_chat_app/presentation/widgets/message_box.dart';

//TODO : the most important thing is to refactor the Tree Widget
class ChatScreen extends StatefulWidget {
  final Brother brotherPart1;
  final Brother brotherPart2;
  ChatScreen({required this.brotherPart1, required this.brotherPart2, Key? key})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late DatabaseReference _firebaseDatabase;
  late Query database;
  TextEditingController controller = new TextEditingController();
  ScrollController? _scrollController;
  late List<Message> allMessages;
  TextStyle _speakerStyle =
      TextStyle(color: Colors.green.shade200, fontSize: 15);
  @override
  void initState() {
    super.initState();

    _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child('${widget.brotherPart1.id + widget.brotherPart2.id}');
    database = FirebaseDatabase.instance
        .reference()
        .child('${widget.brotherPart1.id + widget.brotherPart2.id}');
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    _scrollController = new ScrollController();
    goToTheLastIndex();
  }

  goToTheLastIndex() async {
    await Future.delayed(Duration(seconds: 3));
    _scrollController!.animateTo(_scrollController!.position.maxScrollExtent,
        duration: Duration(microseconds: 10), curve: Curves.linear);
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              name: '${widget.brotherPart2.name}',
              image: '${'assets/images/praying.png'}',
            ),
            Expanded(
              child: FirebaseAnimatedList(
                controller: _scrollController,
                query: database,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  dynamic data = snapshot.value;
                  if (widget.brotherPart1.name == data['from']) {
                    return MessageBox(
                      color: Colors.green.shade100,
                      rightPadding: 0,
                      leftPadding: 60,
                      content: data['content'],
                      subtitle: data['date'],
                    );
                  } else {
                    return MessageBox(
                        color: Colors.green.shade700,
                        leftPadding: 0,
                        rightPadding: 60,
                        content: data['content'],
                        subtitle: data['date']);
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(35)),
              child: _getMessageField(),
            )
          ],
        ),
      ),
    );
  }

  Widget _getMessageField() {
    return TextField(
      controller: controller,
      cursorColor: Colors.green.shade700,
      decoration: InputDecoration(
          suffixIcon: _buildSendMessageButton(),
          hintText: 'send a message',
          enabledBorder: _getBorderShapeForTextField(),
          focusedBorder: _getBorderShapeForTextField()),
    );
  }

  Widget _buildSendMessageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(), primary: Colors.green),
      onPressed: () {
        _sendMessageToTheFriend();
      },
      child: Icon(Icons.send),
    );
  }

  InputBorder _getBorderShapeForTextField() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: BorderSide(width: 5, color: Colors.green));
  }

  void _sendMessageToTheFriend() {
    setState(
      () {
        if (controller.text.isNotEmpty) {
          _firebaseDatabase.push().set({
            "content": controller.text,
            "date":
                "${DateFormat('yMMMd').format(new DateTime.now())}  ${DateFormat('Hm').format(new DateTime.now())}",
            "from": widget.brotherPart1.name,
          });
          controller.clear();
          // goToTheLastIndex();
        }
      },
    );
  }
}
