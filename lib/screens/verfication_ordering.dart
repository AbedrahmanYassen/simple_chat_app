import 'package:flutter/material.dart';
import 'package:islamic_chat_app/presentation/screens/login_screen.dart';

class VerificationOrdering extends StatefulWidget {
  const VerificationOrdering({Key? key}) : super(key: key);

  @override
  _VerificationOrderingState createState() => _VerificationOrderingState();
}

class _VerificationOrderingState extends State<VerificationOrdering> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green.shade700),
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
                'انتقل لتسجيل الدخول لكن تاكد من الضغط على الرابط الذي وصل على ايميلك ',
                style: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
