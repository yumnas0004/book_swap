import 'dart:io';

import 'package:book_swap/constants.dart';
import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/screens/welcome_screen.dart';
import 'package:book_swap/widgets/sign_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File image;
  ImagePicker _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          backgroundColor: primaryColor,
          onPressed: () {
            getImage();
          }),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 30,
                backgroundImage: image != null
                    ? FileImage(image)
                    : AssetImage('images/book_icon.png'),
              ),
            ),
            buildCard('Your ID :', user.uid == null ? '' : user.uid),
            buildCard('Your Email :', user.email == null ? '' : user.email),
            ScopedModelDescendant(
              builder: (context, child, MainModel model) => SignButton(
                  text: 'Log Out',
                  onPressed: () async {
                    bool _isSignedOut = await model.signOut();
                    if (_isSignedOut == true) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  getImage() async {
    try {
      PickedFile _pickedFile =
          await _imagePicker.getImage(source: ImageSource.gallery);
      setState(() {
        image = File(_pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  buildCard(String leadingText, String user) {
    return Card(
        elevation: 5,
        color: scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Text(
            leadingText,
            style: TextStyle(fontSize: 18),
          ),
          title: Text(
            user,
            style: TextStyle(fontSize: 18),
          ),
        ));
  }
}
