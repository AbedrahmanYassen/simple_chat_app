import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamic_chat_app/data/web_services/verification.dart';
import 'package:islamic_chat_app/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  Verification verification = new Verification();
  void createAUserWithEmailAndPassword(
      String email, String password, var function) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      function(email);
      verification.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        //TODO:THOSE have to be modified to Form error tech
        Fluttertoast.showToast(
            msg: 'please choose a good password',
            backgroundColor: Colors.green.shade700);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'your email  already exists',
            backgroundColor: Colors.green.shade700);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'there are a problem try again please  ',
          backgroundColor: Colors.green.shade700);
      var user = FirebaseAuth.instance.currentUser!.delete();
    }
  }

  void signInWithExisitingAcount(
      String email, String password, var function) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('email', email);
      function(
        brother: new Brother(name: '', email: email, friends: [], id: 0),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'user not found ', backgroundColor: Colors.green.shade700);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'password is wrong ');
      }
    }
  }
}
