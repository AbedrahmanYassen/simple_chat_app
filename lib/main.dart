import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat_app/screens/friends_screen.dart';
import 'package:islamic_chat_app/screens/login_screen.dart';
import 'package:islamic_chat_app/screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/user.dart';

/*
* to check if the user has a document then dont have to add new one
* to make search engine
* to get the friends as objects
* to make it slider based
* */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;

  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? signed = preferences.getBool('signed');
  bool? signedup = preferences.getBool('signedUp');

  Widget _screen = SignUpScreen();

  if (signed == true) {
    if (user != null) {
      String? email = user.email;

      await preferences.setString('email', email.toString());
      _screen = FriendsScreen(
        brother: new Brother(name: ' ', email: user.email, friends: [], id: 0),
      );
    }
  } else if (signedup == true && signed == false) {
    _screen = LogInScreen();
  } else {
    _screen = SignUpScreen();
  }

  runApp(MyApp(_screen));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  var user = FirebaseAuth.instance.currentUser;

  Widget _screen = Scaffold();
  MyApp(this._screen);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.green,
          appBarTheme: AppBarTheme(
              color: Colors.green.shade400,
              titleTextStyle:
                  TextStyle(color: Colors.green.shade200, fontSize: 30)),
          canvasColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.green.shade200,
          )),
      home: _screen,
    );
  }
}
