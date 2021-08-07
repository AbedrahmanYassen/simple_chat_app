import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamic_chat_app/data/web_services/authentication.dart';
import 'package:islamic_chat_app/data/models/user.dart';
import 'package:islamic_chat_app/presentation/screens/friends_screen.dart';
import 'package:islamic_chat_app/presentation/screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  Authentication authentication = new Authentication();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth / 3,
                    height: screenHeight / 5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/praying.png'),
                      ),
                    ),
                  ),
                  _getTextFieldWithLabel(
                      textEditingController: email,
                      isPassword: false,
                      hintText: 'Enter your email  '),
                  _getTextFieldWithLabel(
                      textEditingController: password,
                      isPassword: true,
                      hintText: 'choose a string password  '),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: screenWidth / 2,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        authentication.signInWithExisitingAcount(
                            email.text, password.text, _goToFriendsScreen);
                      },
                      child: Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'make a new account ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _goToFriendsScreen({required Brother brother}) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // await addBrother(brother.email as String);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return FriendsScreen(
              brother: brother,
            );
          },
        ),
      );
      _hasSighned();
    }
  }

  void _hasSighned() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('signed', true);
  }

  Widget _getTextFieldWithLabel(
      {required TextEditingController textEditingController,
      required bool isPassword,
      required String hintText}) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 30, right: 30),
          child: _getTextField(
              isPasswordTextField: isPassword,
              controller: textEditingController,
              hintText: hintText),
        ),
      ],
    );
  }

  Widget _getTextField(
      {required bool isPasswordTextField,
      required TextEditingController controller,
      required String hintText}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green.shade200,
          borderRadius: BorderRadius.circular(35)),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField,
        cursorColor: Colors.lightGreen,
        cursorHeight: 30,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(35),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(35),
          ),
        ),
      ),
    );
  }
  // bool _checkAUserHasMade(Brother brother) {
  //   FirebaseFirestore.instance
  //       .collection('brothers')
  //       .get()
  //       .then((QuerySnapshot value) {
  //     value.docs.forEach((element) {
  //       if(element.id == brother.){
  //
  //       }
  //     });
  //   });
  //   return false;
  // }
}
