import 'package:book_swap/constants.dart';
import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/screens/navigationBar/home_screen.dart';
import 'package:book_swap/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: MainModel(),
        child: MaterialApp(
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                  color: Colors.white,
                  iconTheme: IconThemeData(color: primaryColor),
                elevation: 5,
                  centerTitle: true,
                  textTheme: TextTheme(
                      title: TextStyle( color : primaryColor ,fontSize: 25, fontFamily: 'Lobster')))),
              home:  FirebaseAuth.instance.currentUser != null ? Home() : WelcomeScreen()
        ));
  }
}
