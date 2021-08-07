import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat_app/data/web_services/authentication.dart';
import 'package:islamic_chat_app/screens/verfication_ordering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController firestName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  bool signInTransition = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    email.dispose();
    firestName.dispose();
    lastName.dispose();
    super.dispose();
  }

  Authentication authentication = new Authentication();

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
                      textEditingController: firestName,
                      isPassword: false,
                      hintText: 'Enter your first name  '),
                  _getTextFieldWithLabel(
                      textEditingController: lastName,
                      isPassword: false,
                      hintText: 'Enter last name'),
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
                        authentication.createAUserWithEmailAndPassword(
                            email.text, password.text, signUpFunction);
                      },
                      child: Text('Sign Up'),
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
                            return LogInScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'do you already have an account ',
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

  void signUpFunction(String email) async {
    try {
      await addBrother(email);
    } catch (e) {
      await addBrother(email);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return VerificationOrdering();
        },
      ),
    );
    saveTheNameAndUpdateTheSignedUpdate();
  }

  void saveTheNameAndUpdateTheSignedUpdate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('name', firestName.text);
    print(preferences.getString('name'));
    preferences.setBool('signedUp', true);
    preferences.setString('last_name', lastName.text);
  }

  Future<void> addBrother(String email) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      int preferencesId = (preferences.getInt('id') != null)
          ? (preferences.getInt('id') as int)
          : 0;
      await preferences.setInt('id', preferencesId + 5);
      CollectionReference reference =
          FirebaseFirestore.instance.collection('brothers');
      reference.doc('$email').set({
        "name": firestName.text,
        "last_name": lastName.text,
        "friends": [],
        "id": preferences.getInt('id'),
        "email": email
      });
    } catch (e) {
      addBrother(email);
    }
  }
}
