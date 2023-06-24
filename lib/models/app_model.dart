import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppModel extends Model {
  /// Create Singleton factory for [AppModel]
  ///
  static final AppModel _appModel = AppModel._internal();
  factory AppModel() {
    return _appModel;
  }
  AppModel._internal();
  // End

  // user sign up method
  void userSignUp({
    required String email,
    required String password,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      String result = '';
      if (e.code == 'weak-password') {
        result = 'The password provided is too weak.';
      } else if (e.code == 'invalid-email') {
        result = 'The email address is badly formatted.';
      } else if (e.code == 'email-already-in-use') {
        result = 'The account already exists for that email.';
      } else {
        result = 'Something went wrong.';
      }
      onError(result);
    } catch (e) {
      onError('Network error!');
    }
  }

  // user sign up method
  void userSignIn({
    required String email,
    required String password,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      String result = '';
      if (e.code == 'user-not-found') {
        result = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        result = 'The email address is badly formatted.';
      } else if (e.code == 'wrong-password') {
        result = 'Wrong password provided for that user.';
      } else {
        debugPrint(e.code);
        result = 'Something went wrong.';
      }
      onError(result);
    } catch (e) {
      onError('Network error!');
    }
  }
}
