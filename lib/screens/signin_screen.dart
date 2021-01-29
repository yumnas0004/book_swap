import 'package:book_swap/auth/authentication.dart';
import 'package:book_swap/constants.dart';
import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/screens/navigationBar/home_screen.dart';
import 'package:book_swap/screens/signup_screen.dart';
import 'package:book_swap/widgets/sign_button.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignIn extends StatefulWidget {
  static String routeName = '/sigin_screen';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  bool isRedEyeIconPressed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              signField(
                  hintText: 'Email Address',
                  textController: emailController,
                  key: emailKey,
                  keyboardType: TextInputType.emailAddress),
              signField(
                  hintText: 'Password',
                  textController: passwordController,
                  key: passwordKey,
                  keyboardType: TextInputType.number),
              ScopedModelDescendant(
                builder: (context, child, MainModel model) => Builder(
                  builder: (context) => SignButton(
                      text: 'Sign in',
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          Scaffold.of(context).showSnackBar(
                              buildSnackBar('Some fields required'));
                        } else if (passwordController.text.length < 6){
                          Scaffold.of(context).showSnackBar(
                              buildSnackBar('Password should be longer than 6 '));
                        }
                         else {
                          bool _isSigned = await model.signIn(
                              emailController.text.trim(),
                              passwordController.text.trim());
                          if (_isSigned == true) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          } else {
                            Scaffold.of(context).showSnackBar(
                                buildSnackBar('Incorrect Email or password '));
                          }
                        }
                      }),
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Text(
                    'Or Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: primaryColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  buildSnackBar(String content) {
    return SnackBar(
      content: Text(content),
      duration: Duration(seconds: 4),
    );
  }

  signField(
      {String hintText,
      TextEditingController textController,
      Key key,
      TextInputType keyboardType}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) => value.isEmpty ? 'Some fields required' : null,
        key: key,
        controller: textController,
        keyboardType: keyboardType,
        obscureText: hintText == 'Password' ? isRedEyeIconPressed : false,
        decoration: InputDecoration(
            suffixIcon: hintText == 'Password'
                ? IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        isRedEyeIconPressed = !isRedEyeIconPressed;
                      });
                    })
                : null,
            fillColor: scaffoldBackgroundColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: hintText),
      ),
    );
  }
}
