import 'package:book_swap/constants.dart';
import 'package:book_swap/screens/navigationBar/home_screen.dart';
import 'package:book_swap/screens/signin_screen.dart';
import 'package:book_swap/widgets/sign_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Book Swap',
                style: TextStyle(fontFamily: 'Lobster', fontSize: 40),
              ),
              Image(
                image: AssetImage('images/welcomeImage.png'),
              ),
              SignButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
