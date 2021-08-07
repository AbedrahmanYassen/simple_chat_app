import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat_app/data/models/user.dart';

import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  Brother theUser;
  SearchScreen({required this.theUser, Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = new TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  CollectionReference reference =
      FirebaseFirestore.instance.collection('brothers');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.green.shade100,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                        setState(() {});
                      },
                      child: Icon(Icons.search),
                    ),
                    hintText: 'search about friends ',
                    enabledBorder: _getBorderShapeForTextField(),
                    focusedBorder: _getBorderShapeForTextField()),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('brothers')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text('there is no data');
                  } else {
                    return ListView.builder(
                      itemCount:
                          startsWithAsNeededList(_getTheBrothers(snapshot))
                              .length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          //TODO : TO REFACTOR
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('brothers')
                                .doc('${widget.theUser.email}')
                                .update({
                              'friends': FieldValue.arrayUnion([
                                startsWithAsNeededList(
                                        _getTheBrothers(snapshot))[index]
                                    .email
                              ])
                            });
                            FirebaseFirestore.instance
                                .collection('brothers')
                                .doc(
                                    '${startsWithAsNeededList(_getTheBrothers(snapshot))[index].email}')
                                .update({
                              'friends':
                                  FieldValue.arrayUnion([widget.theUser.email])
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChatScreen(
                                      brotherPart1: widget.theUser,
                                      brotherPart2: startsWithAsNeededList(
                                          _getTheBrothers(snapshot))[index]);
                                },
                              ),
                            );
                          },
                          tileColor: Colors.green.shade200,
                          title: Text(
                            startsWithAsNeededList(
                                    _getTheBrothers(snapshot))[index]
                                .name as String,
                          ),
                          subtitle: Text(startsWithAsNeededList(
                                  _getTheBrothers(snapshot))[index]
                              .email as String),
                          trailing: Icon(Icons.person),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getTheBrothers(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map((e) => Brother(
            name: e["name"],
            email: e["email"],
            friends: e["friends"],
            id: e["id"]))
        .toList();
  }

  InputBorder _getBorderShapeForTextField() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
        borderSide: BorderSide(width: 5, color: Colors.green));
  }

  List<Brother> startsWithAsNeededList(List<Brother> listOfBrothers) {
    List<Brother> newBrothers = [];
    for (int i = 0; i < listOfBrothers.length; i++) {
      if (listOfBrothers[i].email!.startsWith('${controller.text}') &&
          controller.text != '') {
        newBrothers.add(listOfBrothers[i]);
      }
    }
    return newBrothers;
  }
}
