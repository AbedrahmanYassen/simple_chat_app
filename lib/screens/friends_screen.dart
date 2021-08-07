import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat_app/constants/my_colors.dart';
import 'package:islamic_chat_app/data/models/user.dart';
import 'package:islamic_chat_app/screens/search_screen.dart';
import 'dart:io';

import 'chat_screen.dart';
import 'login_screen.dart';

class FriendsScreen extends StatelessWidget {
  Brother brother;
  FriendsScreen({required this.brother});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('brothers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(brother.email).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LogInScreen();
                    },
                  ),
                );
              },
              child: Icon(Icons.send),
            ),
            body: Center(
              child: Container(
                  width: 200,
                  height: 200,
                  color: MyColors.LIGHT_GREEN,
                  child: Center(child: Text("Something went wrong"))),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return FriendsScreenApplication(
            brother: new Brother(
                name: data['name'],
                email: brother.email,
                friends: data['friends'],
                id: data['id']),
          );
        }

        return Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class FriendsScreenApplication extends StatefulWidget {
  Brother brother;

  FriendsScreenApplication({required this.brother, Key? key}) : super(key: key);
  @override
  _FriendsScreenApplicationState createState() =>
      _FriendsScreenApplicationState();
}

class _FriendsScreenApplicationState extends State<FriendsScreenApplication> {
  Reference ref = FirebaseStorage.instance.ref('/Capture.PNG');
  String downloadedImage = '';

  late FilePickerResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.brother.name),
            SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return SearchScreen(theUser: widget.brother);
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.search,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: MyColors.INTERMIDATE_GREEN),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.brother.friends.length,
          itemBuilder: (context, index) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('brothers')
                  .doc('${widget.brother.friends[index]}')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                dynamic data = snapshot.data;
                try {
                  if (snapshot.hasData) {
                    return Dismissible(
                      key: Key(data['email']),
                      onDismissed: (direction) {
                        setState(
                          () {
                            widget.brother.friends.remove(data['email']);

                            FirebaseFirestore.instance
                                .collection('brothers')
                                .doc('${widget.brother.email}')
                                .update(
                              {
                                'friends': widget.brother.friends,
                              },
                            );
                          },
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          //TODO SURE GO IF THE SECOND BROTHER IS HERE
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatScreen(
                                  brotherPart1: widget.brother,
                                  brotherPart2: Brother(
                                    friends: data["friends"],
                                    name: data["name"],
                                    id: data["id"],
                                    email: data["email"],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            color: MyColors.INTERMIDATE_GREEN,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: MyColors.LIGHT_GREEN,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        data["name"],
                                        style: TextStyle(
                                            color: MyColors.Dark_Green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    throw 'error';
                  }
                } catch (e) {
                  return Text('');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
