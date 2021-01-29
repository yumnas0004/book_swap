import 'package:book_swap/constants.dart';
import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/screens/navigationBar/favorite_screen.dart';
import 'package:book_swap/screens/navigationBar/library_screen.dart';
import 'package:book_swap/screens/navigationBar/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          selectedItemColor: primaryColor,
          backgroundColor: scaffoldBackgroundColor,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books_outlined),
                title: Text('Library')),
            BottomNavigationBarItem(
                icon: Icon(Icons.star), title: Text('Favorite')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
        body: ScopedModelDescendant(builder: (context , child , MainModel model) => navigate(model))
        );
  }

  navigate(MainModel model) {
    if (currentIndex == 0) {
      return Library(model);
    } else if (currentIndex == 1) {
      return Favorite();
    } else {
      return Settings();
    }
  }
}
