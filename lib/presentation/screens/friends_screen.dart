import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_chat_app/business_logic/cubit/messages_cubit.dart';
import 'package:islamic_chat_app/data/models/user.dart';
import 'package:islamic_chat_app/data/repository/messages_repository.dart';
import 'package:islamic_chat_app/data/web_services/messages_from_the_realtime_database.dart';
import 'package:islamic_chat_app/presentation/screens/chat_screen.dart';
import 'package:islamic_chat_app/presentation/screens/login_screen.dart';
import 'package:islamic_chat_app/presentation/screens/search_screen.dart';
import 'package:islamic_chat_app/presentation/widgets/curved_drawer.dart';
import 'dart:io';

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
                  color: Colors.green.shade50,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return LogInScreen();
          // }));
          // downloadedImage = await FirebaseStorage.instance
          //     .ref('Capture.PNG')
          //     .getDownloadURL();
          // setState(() {});
          // Within your widgets:
          // Image.network(downloadURL);
          result = (await FilePicker.platform.pickFiles())!;
          if (result != null) {
            print(result.files.single.path as String);
            File file = new File(result.files.single.path as String);
          }
        },
        child: (downloadedImage.isEmpty)
            ? Icon(Icons.circle)
            : Image.network(downloadedImage),
      ),
      endDrawer: Drawer(
        elevation: 0.0,
        child: SafeArea(
          child: CurvedDrawer(
            hight: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        ),
      ),
      appBar: AppBar(
        //
        // actions: [
        //
        // ],
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
                shape: BoxShape.circle, color: Colors.green.shade200),
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
                                return BlocProvider(
                                    create: (context) => MessagesCubit(
                                          messagesRepository:
                                              new MessagesRepository(
                                                  messagesFromTheDatabase:
                                                      MessagesFromTheDatabase(
                                                          messageKey:
                                                              '${widget.brother.id + data['id']}')),
                                        ),
                                    child: ChatScreen(
                                        brotherPart1: widget.brother as Brother,
                                        brotherPart2: Brother(
                                            friends: data["friends"],
                                            name: data["name"],
                                            id: data["id"],
                                            email: data["email"])));
                              },
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            color: Colors.green.shade200,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.green.shade50,
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
                                            color: Colors.green.shade900,
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
