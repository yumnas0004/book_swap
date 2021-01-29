import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

mixin AuthModel on Model {
  final auth = FirebaseAuth.instance;
  bool _isSignIn;
  bool get isSignIn => _isSignIn;
  bool _isSignUp;
  bool get isSignUp => _isSignUp;
  bool _isSignOut;
  bool get isSignOut => _isSignOut;

  Future<bool> signIn(String email, String password) async {
    _isSignIn = true;
    notifyListeners();

    try {
     auth.signInWithEmailAndPassword(email: email, password: password);
      _isSignIn = false;
      notifyListeners();
      return true;
    }  catch (e) {
      print(e);
      _isSignIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    _isSignUp = true;
    notifyListeners();
    try {
      auth.createUserWithEmailAndPassword(email: email, password: password);
      _isSignUp = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e.message);
      _isSignUp = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signOut() async {
    _isSignOut = true;
    notifyListeners();
    try {
      auth.signOut();
      _isSignOut = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSignOut = false;
      notifyListeners();
      return false;
    }
  }
}
