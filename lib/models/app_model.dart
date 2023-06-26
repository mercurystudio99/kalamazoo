import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalamazoo/utils/constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';

class AppModel extends Model {
  // Variables
  final _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot<Map<String, dynamic>>> users = [];

  String? retrieveEmail;

  /// Create Singleton factory for [AppModel]
  ///
  static final AppModel _appModel = AppModel._internal();
  factory AppModel() {
    return _appModel;
  }
  AppModel._internal();
  // End
  EmailOTP myauth = EmailOTP();

  // user sign up method
  void userSignUp({
    required String name,
    required String email,
    required String password,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    final user = <String, dynamic>{
      USER_FULLNAME: name,
      USER_EMAIL: email,
      USER_PASS: password
    };
    _firestore.collection(C_USERS).add(user).then((DocumentReference doc) =>
        debugPrint('DocumentSnapshot added with ID: ${doc.id}'));

    // onSuccess();
    // String result = '';
    // if (e.code == 'weak-password') {
    //   result = 'The password provided is too weak.';
    // } else if (e.code == 'invalid-email') {
    //   result = 'The email address is badly formatted.';
    // } else if (e.code == 'email-already-in-use') {
    //   result = 'The account already exists for that email.';
    // } else {
    //   result = 'Something went wrong.';
    // }
    // onError(result);
    // onError('Network error!');
  }

  // user sign in method
  void userSignIn({
    required String email,
    required String password,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    _firestore
        .collection(C_USERS)
        .where(USER_EMAIL, isEqualTo: email)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var docSnapshot in querySnapshot.docs) {
            docSnapshot.data()[USER_PASS] == password
                ? onSuccess()
                : onError('Wrong password provided for that user.');
            break;
          }
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
    // onSuccess();
    // String result = '';
    // if (e.code == 'user-not-found') {
    //   result = 'No user found for that email.';
    // } else if (e.code == 'invalid-email') {
    //   result = 'The email address is badly formatted.';
    // } else if (e.code == 'wrong-password') {
    //   result = 'Wrong password provided for that user.';
    // } else {
    //   debugPrint(e.code);
    //   result = 'Something went wrong.';
    // }
    // onError(result);
  }

  // user exist method
  void userExist({
    required String email,
    // callback functions
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) {
    _firestore
        .collection(C_USERS)
        .where(USER_EMAIL, isEqualTo: email)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          retrieveEmail = email;
          onSuccess();
        } else {
          onError('No user found for that email.');
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  // user send OTP method
  void sendOTP({
    required String email,
    // callback functions
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    myauth.setConfig(
        appEmail: "kalamazoo@gmail.com",
        appName: 'Kalamazoo',
        userEmail: email,
        otpLength: 4,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      onSuccess();
    } else {
      onError();
    }
  }

  // user verify OTP method
  void verifyOTP({
    required String otp,
    // callback functions
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    if (await myauth.verifyOTP(otp: otp) == true) {
      onSuccess();
    } else {
      onError();
    }
  }
}
