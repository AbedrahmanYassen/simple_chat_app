import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_chat_app/data/models/user.dart';
import 'package:islamic_chat_app/presentation/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  Brother brotherPart1;
  Brother brotherPart2;
  ChatScreen({required this.brotherPart1, required this.brotherPart2, Key? key})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Query? reference;
  DatabaseReference? _firebaseDatabase;
  TextEditingController controller = new TextEditingController();
  ScrollController? _scrollController;

  TextStyle _speakerStyle =
      TextStyle(color: Colors.green.shade200, fontSize: 15);

  var firebasaDatabse;
  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance
        .reference()
        .child('${widget.brotherPart1.id + widget.brotherPart2.id}');
    _firebaseDatabase = FirebaseDatabase.instance
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
                query: reference as Query,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  dynamic data = snapshot.value;
                  if (widget.brotherPart1.name == data['from']) {
                    return Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Card(
                        color: Colors.green.shade200,
                        child: ListTile(
                          title: SelectableText(data['content']),
                          subtitle: Text(data["date"]),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(right: 60),
                      child: Card(
                        color: Colors.grey,
                        child: ListTile(
                          title: SelectableText(data['content']),
                          subtitle: Text(data['date']),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              color: Colors.green.shade200,
              child: TextField(
                controller: controller,
                cursorColor: Colors.green.shade700,
                decoration: InputDecoration(
                    suffixIcon: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(), primary: Colors.green),
                      onPressed: () {
                        if (isAllowedToSend()) {
                          if (!controller.text.isEmpty) {
                            _firebaseDatabase!.push().set({
                              "content": controller.text,
                              "date":
                                  "${DateFormat('yMMMd').format(new DateTime.now())}  ${DateFormat('Hm').format(new DateTime.now())}",
                              "from": widget.brotherPart1.name,
                            });
                            controller.clear();
                            // goToTheLastIndex();
                          }
                        } else {
                          //TODO : DO ESTEGHFAR
                        }
                      },
                      child: Icon(Icons.send),
                    ),
                    hintText: 'send a message',
                    enabledBorder: _getBorderShapeForTextField(),
                    focusedBorder: _getBorderShapeForTextField()),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputBorder _getBorderShapeForTextField() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: BorderSide(width: 5, color: Colors.green));
  }

  bool isAllowedToSend() {
    //TODO:i have to make limits on what people to say
    return true;
  }
}