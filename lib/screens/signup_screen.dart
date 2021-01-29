import 'package:book_swap/auth/authentication.dart';
import 'package:book_swap/constants.dart';
import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/screens/navigationBar/home_screen.dart';
import 'package:book_swap/widgets/sign_button.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUp extends StatefulWidget {
  static String routeName = '/signup_screen';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final usernameKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final confirmPasswordKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  bool isRedEyeIconPressed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 80),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                signField(
                    hintText: 'Username',
                    textController: usernameController,
                    key: usernameKey,
                    keyboardType: TextInputType.name),
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
                signField(
                    hintText: 'Confirm Password',
                    textController: confirmPasswordController,
                    key: confirmPasswordKey,
                    keyboardType: TextInputType.number),
                ScopedModelDescendant(
                  builder: (context, child, MainModel model) => Builder(
                    builder: (context) => SignButton(
                        text: 'Sign Up',
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(
                                buildSnackBar('Some fields required'));
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            Scaffold.of(context).showSnackBar(
                                buildSnackBar('Password doesn\'t match'));
                          } else if (passwordController.text.length < 6 || confirmPasswordController.text.length < 6) {
                            Scaffold.of(context).showSnackBar(buildSnackBar(
                                'Password should be longer than 6 '));
                          } else {
                            bool _isSignedUp = await model.signUp(
                                emailController.text.trim(),
                                passwordController.text.trim());
                            if (_isSignedUp == true) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            } else {
                              Scaffold.of(context).showSnackBar(
                                  buildSnackBar('Something went wrong'));
                            }
                          }
                        }),
                  ),
                )
              ],
            )),
      ),
    );
  }

  SnackBar buildSnackBar(String content) {
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
        obscureText: hintText == 'Password' || hintText == 'Confirm Password'
            ? isRedEyeIconPressed
            : false,
        decoration: InputDecoration(
            suffixIcon: hintText == 'Password' || hintText == 'Confirm Password'
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
